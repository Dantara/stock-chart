{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( someFunc
    ) where

import           Control.Concurrent
import           Data.Aeson
import           Data.Text           (Text)
import qualified Data.Text           as T
import           Data.Text.Chart     (plot)
import           GHC.Generics
import           System.Console.ANSI

myLoop :: IO ()
myLoop = do
  clearScreen
  plot $ [1..20] <> [20,19..10]
  putStrLn "Current price: 5000"
  threadDelay 1000000
  clearScreen
  plot $ [1..20] <> [20,19..10] <> [10..30]
  threadDelay 1000000

someFunc :: IO ()
-- someFunc = sequence_ $ repeat myLoop
someFunc = return ()
