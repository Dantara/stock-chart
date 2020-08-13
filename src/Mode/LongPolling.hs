{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Mode.LongPolling where

import           Config
import           Control.Lens
import           Data.Aeson
import           Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Lazy as BS
import           Data.Text
import           Data.Text.Encoding
import           Debug.Trace
import           Error
import           GHC.Generics
import           Internal
import           Network.Wreq

data Quote = Quote {
    openPrice          :: Double
  , highPrice          :: Double
  , currentPrice       :: Double
  , previousClosePrice :: Double
  } deriving (Show, Generic)

instance FromJSON Quote where
  parseJSON = withObject "Quote" $ \v -> Quote
        <$> v .: "o"
        <*> v .: "h"
        <*> v .: "c"
        <*> v .: "pc"

sendRequest :: String -> Config -> IO (Either Error ByteString)
sendRequest url config = do
  resp <- getWith opts url
  return $ maybeToEither RequestError $ resp ^? responseBody
    where
      opts = defaults
        & header "Accept" .~ ["application/json"]
        & header "X-Finnhub-Token" .~ [encodeUtf8 $ apiKey config]

getUpdate :: Config -> IO (Either Error Quote)
getUpdate cfg = do
  resp <- sendRequest url cfg
  case resp of
    (Right r) -> return $ maybeToEither UpdateError $ decode r
    (Left e)  -> return (Left e)
  where
    url = apiUrl <> "quote?symbol=" <> unpack (ticker cfg)
