module Internal where

maybeToEither :: b -> Maybe a -> Either b a
maybeToEither x Nothing  = Left x
maybeToEither _ (Just x) = Right x
