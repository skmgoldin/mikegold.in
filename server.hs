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
    logLock <- newMVar ()
    threadRequests logLock lSock
  where
    threadRequests logLock lSock =
      do
        (connSock, clientAddr) <- accept lSock  
        forkIO $ procRequest logLock connSock clientAddr
        threadRequests logLock lSock

    procRequest logLock connSock clientAddr =
      do
        logHandler logLock clientAddr "client connected"
        -- I'm going to assume anybody sending me a request greater than 4K in
        -- size is trolling for now, but this is a BUG.
        req <- recv connSock 4096
        httpHandler req connSock

        mapM_ (logHandler logLock clientAddr) (lines req)
	close connSock
        logHandler logLock clientAddr "client disconnected"

logHandler logLock addr msg =
  withMVar logLock (\a -> putStrLn ("From " ++ show addr ++ ": " ++ msg)
                          >> return a)
  
httpHandler req connSock =
  do
    let reqUrl = if (getReqUrl req) == "/" then "html/index.html"
                                           else "html/" ++ (getReqUrl req)
    reqFile <- openFile reqUrl ReadMode
    dataString <- hGetContents reqFile
    send connSock dataString
    hClose reqFile
  where
    getReqUrl req = 
      foldl (\x y -> if (head y) == '/' then y else x) "" (words req)

main =
  let port = "80" in
  handleConnection port 
