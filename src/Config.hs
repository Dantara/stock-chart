{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Config where

import           Data.Aeson
import           Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Lazy as BS
import           Data.Text            (Text)
import qualified Data.Text            as T
import           Error
import           GHC.Generics
import           Internal

data Config = Config {
    apiKey :: Text
  , ticker :: Text
  } deriving (Show, Generic, FromJSON, ToJSON)

readConfig :: String -> IO (Either Error Config)
readConfig str = do
  x <- BS.readFile str
  return $ maybeToEither ConfigError $ decode x
