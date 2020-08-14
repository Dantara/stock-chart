{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( runQuote
    ) where

import           Config
import           Control.Concurrent
import           Data.Aeson
import           Data.Text           (Text)
import qualified Data.Text           as T
import           Data.Text.Chart     (plot)
import           Error
import           GHC.Generics
import           Internal
import           Mode.LongPolling
import           System.Console.ANSI

runQuote :: IO ()
runQuote = do
  configE <- readConfig "config.json"
  case configE of
    (Right cfg) ->
      runQuoteLP cfg realPlot 1500000
    (Left e) -> print e
