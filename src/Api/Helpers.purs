module Api.Helpers
  ( ApiError(..)
  , decodeResponseBody
  )
  where

import Data.Argonaut.Decode (decodeJson, class DecodeJson, JsonDecodeError)
import Prelude
import Data.Bifunctor (lmap)
import Data.Either (Either)

import Rest (FetchMethods)

data ApiError e = DecodeError JsonDecodeError | FetchError e

decodeResponseBody :: forall e a o. DecodeJson o => (FetchMethods e a) -> a -> Either (ApiError e) o
decodeResponseBody { getResponseBody } = lmap DecodeError <<< decodeJson <<< getResponseBody