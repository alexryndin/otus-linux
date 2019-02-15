import System.Directory
import System.FilePath
import Control.Monad
import Control.Exception
import System.Posix.Files
import Data.Foldable

import Data.Char

getAbsDirectoryContents :: FilePath -> IO [FilePath]
getAbsDirectoryContents dir = map (dir </>) <$> getDirectoryContents dir

getProcs :: IO [FilePath]
getProcs = (filter (\x -> not (any isAlpha x)) <$> (listDirectory "/proc"))

getProcsFullPaths :: IO [FilePath]
getProcsFullPaths = (fmap . fmap) ("/proc/" ++) getProcs

getProcsFDPaths :: IO [FilePath]
getProcsFDPaths = (fmap . fmap) (++ "/fd") getProcsFullPaths

getFDContents :: IO [[FilePath]]
getFDContents = join (sequence <$> (fmap . fmap) getAbsDirectoryContents getProcsFDPaths )

getFDSLs = join $ traverse (filterM (fmap (not . isDirectory) . getFileStatus)) <$> getFDContents

main :: IO ()
main = do
  result <- try getFDSLs :: IO (Either SomeException [[FilePath]])
  case result of
    Left ex -> putStrLn "Fuck"
    Right val -> do
      sequence_ [putStrLn file | files <- val, file <- files]
--getSLPaths :: IO [[FilePath]]
--getSLPaths = do
--  x <- getProcsFDPaths
--  y <- x
--  x1 <- getSLPaths
--  y1 <- x1
--  z1 <- y1
--  return $ return $ return $ readSymbolicLink (y ++ z1)