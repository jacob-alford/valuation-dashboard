module Api
  ( ApiError(..),
  getTest
  )
  where

import Data.Argonaut.Decode (class DecodeJson, decodeJson, JsonDecodeError)
import Prelude
import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Effect.Aff (Aff)

import Rest (FetchMethods(..))

data ApiError e = DecodeError JsonDecodeError | FetchError e

getTest :: forall e r a. DecodeJson a => FetchMethods e r -> Aff (Either (ApiError e) a)
getTest (FetchMethods { get, getResponseBody }) = do 
  restResult <- get "/test"
  pure $ case restResult of 
    Left e -> Left (FetchError e)
    Right r -> decodeResponseBody r
  where
    decodeResponseBody :: r -> Either (ApiError e) a
    decodeResponseBody = (lmap $ DecodeError) <<< decodeJson <<< getResponseBody