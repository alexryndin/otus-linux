import System.Directory
import System.FilePath
import Control.Monad
import Control.Exception
import System.Posix.Files
import Data.Foldable
import Data.List.Split
import Data.Char

getAbsDirectoryContents :: FilePath -> IO [FilePath]
getAbsDirectoryContents dir = map (dir </>) <$> getDirectoryContents dir

getProcs :: IO [FilePath]
getProcs = (filter (all isNumber) <$> (listDirectory "/proc"))

getProcsFullPaths :: IO [FilePath]
getProcsFullPaths = (fmap . fmap) ("/proc/" ++) getProcs

getProcsFDPaths :: IO [FilePath]
getProcsFDPaths = (fmap . fmap) (++ "/fd") getProcsFullPaths

getFDContents :: IO [[FilePath]]
getFDContents = join (sequence <$> (fmap . fmap) getAbsDirectoryContents getProcsFDPaths )

getPid :: FilePath -> String
getPid f = splitOn "/" f !! 2

getFileStatusSafe :: FilePath -> IO (Maybe FileStatus)
getFileStatusSafe p = do
  result <- try $ getFileStatus p :: IO (Either SomeException FileStatus)
  case result of
    Left _ -> return Nothing
    Right val -> return $ Just val

getFDSLs = join $ traverse (filterM (check)) <$> getFDContents
  where check p = do
          result <- try $ getFileStatus p :: IO (Either SomeException FileStatus)
          case result of
            Left _ -> return False
            Right val -> return $ (not $ isDirectory val)

-- main :: IO ()
-- main = do
--   result <- getFDSLs
--   do
--     files <- result
--     file <- files
--     do
--       result <- try $ putStrLn file
--       case result of
--         Left _ -> putStrLn "1123"
--         Right a -> putStrLn a

main :: IO ()
main = do
  result <- try getFDSLs :: IO (Either SomeException [[FilePath]])
  putStrLn "PID\tFD"
  case result of
    Left ex -> putStrLn "Fuck"
    Right val -> for_ (concat val) $ \fn -> do
      name <- readSymbolicLink fn
      putStrLn $ getPid fn ++ "\t" ++ name
      -- fs <- (traverse (readSymbolicLink) [file | files <- val, file <- files])
      -- traverse_ putStrLn (fs)
--      where out = fmap getPid fs ++ fmap (++ "\n") fs


--getSLPaths :: IO [[FilePath]]
--getSLPaths = do
--  x <- getProcsFDPaths
--  y <- x
--  x1 <- getSLPaths
--  y1 <- x1
--  z1 <- y1
--  return $ return $ return $ readSymbolicLink (y ++ z1)
