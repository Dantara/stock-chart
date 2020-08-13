{-# LANGUAGE OverloadedStrings #-}

module Error where

data Error = ConfigError
           | ConnectionError
           | RequestError
           | UpdateError
           deriving (Show)
