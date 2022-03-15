module Api
  ( ApiError(..)
  , TestResponse2
  , combinedRAEs
  , getTest
  )
  where

import Data.Argonaut.Decode (decodeJson, JsonDecodeError)
import Prelude
import Data.Bifunctor (lmap)
import Data.Either (Either(..))

import Rest (FetchMethods)
import ReaderAffEither (ReaderAffEither(..))

data ApiError e = DecodeError JsonDecodeError | FetchError e

type TestResponse = {
  a :: Int,
  b :: Int
}

getTest :: forall e a. ReaderAffEither (FetchMethods e a) (ApiError e) TestResponse
getTest = ReaderAffEither \fetchMethods -> 
  let 
    decodeResponseBody :: a -> Either (ApiError e) TestResponse
    decodeResponseBody = lmap DecodeError <<< decodeJson <<< fetchMethods.getResponseBody
  in do 
    restResult <- fetchMethods.get "/test"
    pure $ case restResult of 
      Left e -> Left (FetchError e)
      Right a -> decodeResponseBody a

type TestResponse2 = {
  c :: Int,
  d :: Int
}

getTest2 :: forall e a. ReaderAffEither (FetchMethods e a) (ApiError e) TestResponse2
getTest2 = ReaderAffEither \fetchMethods -> 
  let 
    decodeResponseBody :: a -> Either (ApiError e) TestResponse2
    decodeResponseBody = lmap DecodeError <<< decodeJson <<< fetchMethods.getResponseBody
  in do 
    restResult <- fetchMethods.get "/test"
    pure $ case restResult of 
      Left e -> Left (FetchError e)
      Right a -> decodeResponseBody a

combinedRAEs :: forall e a. ReaderAffEither (FetchMethods e a) (ApiError e) Int
combinedRAEs = do
  test1 <- getTest
  test2 <- getTest2
  pure $ test1.a + test2.c