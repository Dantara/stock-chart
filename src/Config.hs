{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Config where

import           Data.Aeson
import           Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Lazy as BS
import           Data.Text            (Text)
import qualified Data.Text            as T
import           GHC.Generics

data DefaultConfig = DefaultConfig {
    apiKey        :: Text
  , defaultTicker :: Text
  } deriving (Show, Generic, FromJSON)

readConfig :: String -> IO (Maybe DefaultConfig)
readConfig str = do
  x <- BS.readFile str
  return $ decode x
