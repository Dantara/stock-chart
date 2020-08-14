{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Mode.LongPolling where

import           Config
import           Control.Concurrent
import           Control.Lens
import           Data.Aeson
import           Data.ByteString.Lazy (ByteString)
import qualified Data.Text            as T
import           Data.Text.Encoding
import           Error
import           GHC.Generics
import           Internal
import           Network.Wreq
import           System.Console.ANSI

data Quote = Quote {
    currentPrice       :: Double
  , highPrice          :: Double
  , lowPrice           :: Double
  , openPrice          :: Double
  , previousClosePrice :: Double
  } deriving (Show, Generic)

instance FromJSON Quote where
  parseJSON = withObject "Quote" $ \v -> Quote
        <$> v .: "c"
        <*> v .: "h"
        <*> v .: "l"
        <*> v .: "o"
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
    url = apiUrl <> "quote?symbol=" <> T.unpack (ticker cfg)

runQuoteLP :: Config -> ([Double] -> IO ()) -> Int -> IO ()
runQuoteLP cfg f tic = go [0]
  where
    go :: [Double] -> IO ()
    go xs = do
      upd <- getUpdate cfg
      case upd of
        (Right quote) -> do
          let x = currentPrice quote
          clearScreen
          putStrLn $ "Data for " <> show (ticker cfg) <> " ticker:\n"
          f $ reverse (x:xs)
          putStrLn $ "\nCurrent price: " <> show x <> "$\n"
          putStrLn $ "High price: " <> show (highPrice quote) <> "$"
          putStrLn $ "Low price: " <> show (lowPrice quote) <> "$"
          putStrLn $ "Open price: " <> show (openPrice quote) <> "$"
          putStrLn $ "Previous close price: " <> show (previousClosePrice quote) <> "$"
          threadDelay tic
          go (x:xs)
        (Left e) -> print e
