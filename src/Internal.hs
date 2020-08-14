module Internal where

import           Data.Text.Chart (plot)

maybeToEither :: b -> Maybe a -> Either b a
maybeToEither x Nothing  = Left x
maybeToEither _ (Just x) = Right x

apiUrl :: String
apiUrl = "https://finnhub.io/api/v1/"

realPlot :: RealFrac a => [a] -> IO ()
realPlot = plot . map round
