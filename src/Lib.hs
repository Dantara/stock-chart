module Lib
    ( someFunc
    ) where

import           Control.Concurrent
import           Data.Text.Chart     (plot)
import           System.Console.ANSI

someFunc :: IO ()
someFunc = do
  clearScreen
  plot $ [1..20] <> [20,19..10]
  threadDelay 1000000
  clearScreen
  plot $ [1..20] <> [20,19..10] <> [10..30]
