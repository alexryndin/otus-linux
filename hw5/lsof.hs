import System.Directory
import Control.Monad
import System.Posix.Files
import Data.Char

getProcs :: IO [FilePath]
getProcs = (filter (\x -> not (any isAlpha x)) <$> (listDirectory "/proc"))

getProcsFullPaths :: IO [FilePath]
getProcsFullPaths = (fmap . fmap) ("/proc/" ++) getProcs

getProcsFDPaths :: IO [FilePath]
getProcsFDPaths = (fmap . fmap) (++ "/fd") getProcsFullPaths

getFDSLs :: IO [[FilePath]]
getFDSLs = join (sequence <$> (fmap . fmap) listDirectory  getProcsFDPaths )

--getSLPaths :: IO [[FilePath]]
--getSLPaths = do
--  x <- getProcsFDPaths
--  y <- x
--  x1 <- getSLPaths
--  y1 <- x1
--  z1 <- y1
--  return $ return $ return $ readSymbolicLink (y ++ z1)
--listFDSLs 
