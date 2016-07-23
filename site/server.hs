import Data.Bits
import Network.Socket
import Network.BSD
import Data.List
import Control.Concurrent
import Control.Concurrent.MVar
import Control.Monad
import System.IO
import System.Directory

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
                withMVar logLock (\a -> putStrLn ((show clientAddr) ++ " connected.")
                                        >> return a)

                -- I'm going to assume anybody sending me a request greater than 4K in
                -- size is trolling for now, but this is a BUG.
                req <- recv connSock 4096
                httpHandler req connSock

                logHandler logLock clientAddr req
                close connSock
                withMVar logLock (\a -> putStrLn ((show clientAddr) ++ " disconnected.")
                                        >> return a)

logHandler logLock addr msg =
    withMVar logLock (\a -> putStrLn ("From " ++ show addr ++ ":")
                            >> putStrLn msg
                            >> return a)
  
httpHandler req connSock =
    do
        let reqUrl = if (getReqUrl req) == "/" then "./html/index.html"
                                                else "./html/" ++ (getReqUrl req)

        exists <- doesFileExist reqUrl
        if (not exists)
           then do return ()
           else do
                reqFile <- openFile reqUrl ReadMode
                dataString <- hGetContents reqFile
                sendMsg dataString connSock
                hClose reqFile

                where
                    getReqUrl req = foldl (\x y -> if (head y) == '/' then y else x) "" (words req)

                    sendMsg dataString connSock =
                        if (length dataString) /= 0 then
                            do
                                let (sendChunk, remain) = splitAt 4096 dataString
                                bytesSent <- send connSock sendChunk
                                putStrLn $ "BYTES SENT: " ++ (show bytesSent) 
                                sendMsg ((drop bytesSent sendChunk) ++ remain) connSock
                            else
                                return 0

main =
    let port = "80" in
    handleConnection port 
