{-# LANGUAGE OverloadedStrings #-}

module Error where

data Error = ConfigError | ConnectionError deriving (Show)
