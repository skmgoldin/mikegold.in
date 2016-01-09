import Data.Bits
import Network.Socket
import Network.BSD
import Data.List
import Control.Concurrent
import Control.Concurrent.MVar
import System.IO

-- Adapted from Real World Haskell:
-- http://book.realworldhaskell.org/read/sockets-and-syslog.html
handleConnection listenPort =
  do
    addrinfo <- getAddrInfo (Just (defaultHints {addrFlags = [AI_PASSIVE]}))
                Nothing (Just listenPort)
    let servaddr = head addrinfo
    lSock <- socket (addrFamily servaddr) Stream defaultProtocol
    bind lSock (addrAddress servaddr)
    listen lSock 5
    -- We'll use this lock to sync access to our handlers
    lock <- newMVar ()
    threadRequests lock lSock
  where
    -- Listen-loop. Spin here forever.
    threadRequests lock lSock =
      do
        -- connSock is the socket we should serve over, reserve lSock for
        -- listening for and accepting new connections.
        (connSock, clientAddr) <- accept lSock  
        forkIO $ procRequest lock connSock clientAddr
        threadRequests lock lSock

    procRequest lock connSock clientAddr =
      do
        logHandler clientAddr "client connected"
        -- I'm going to assume anybody sending me a request greater than 4K in
        -- size is trolling for now, but this is a BUG. Do I need to lock?
        req <- recv connSock 4096
        httpHandler req connSock

        mapM_ (handle logHandler lock clientAddr) (lines req)
	close connSock
        handle logHandler lock clientAddr "client disconnected"

    handle handler lock clientAddr msg =
      withMVar lock (\a -> handler clientAddr msg >> return a)

logHandler addr msg =
  putStrLn $ "From " ++ show addr ++ ": " ++ msg

httpHandler req connSock =
  do
    let reqUrl = if (getReqUrl req) == "/" then "html/index.html"
                                           else "html/" ++ (getReqUrl req)
    reqFile <- openFile reqUrl ReadMode
    dataString <- hGetContents reqFile
    send connSock dataString
  where
    getReqUrl req = 
      foldl (\x y -> if (head y) == '/' then y else x) "" (words req)

main =
  let port = "80" in
  handleConnection port 
