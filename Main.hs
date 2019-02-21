module Main where

import Control.Concurrent
import Foreign.C.Types
import Foreign.Ptr

import Wrapper

haskellC :: IO (Ptr CInt)
haskellC = do
    base1 <- c'debug_current_stack_address
    putStrLn $ "haskellC base1 = " ++ show base1
    base2 <- c'report_stack_base
    putStrLn $ "haskellC base2 = " ++ show base2
    return base1

report :: Ptr CInt -> IO ()
report base2 = do
    putStrLn "Reporting C stack by calling back into Haskell from C, again"
    _ <- c'report_stack_base
    g <- mkCallback haskellC
    _ <- c'report_stack_base
    base4 <- c'call_func g
    _ <- c'report_stack_base
    putStrLn $ "base4 = " ++ show base4
    putStrLn $ "base4 - base2 = " ++ show (base2 `minusPtr` base4)

main :: IO ()
main = do
    putStrLn "Reporting C stack by obtaining it from C and reporting in Haskell"
    base1 <- c'report_stack_base
    base2 <- c'report_stack_base

    runInBoundThread $ do
      putStrLn "Reporting C stack by calling back into Haskell from C"
      _ <- c'report_stack_base
      f <- mkCallback haskellC
      _ <- c'report_stack_base
      base3 <- c'call_func f
      _ <- c'report_stack_base
      putStrLn $ "base3 = " ++ show base3
      putStrLn $ "base3 - base1 = " ++ show (base1 `minusPtr` base3)
      putStrLn $ "base3 - base2 = " ++ show (base2 `minusPtr` base3)

      report base2
