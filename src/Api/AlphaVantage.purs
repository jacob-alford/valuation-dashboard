module Api.AlphaVantage where

import Prelude

import Api.Helpers (ApiError(..), decodeResponseBody)
import Rest (FetchMethods)
import Data.Either (Either(..))
import Lib.ReaderAffEither (ReaderAffEither(..))

baseUrl :: String
baseUrl = "https://www.alphavantage.co"

makeUrl :: String -> String
makeUrl = (<>) baseUrl

type Environment e a = {
  fetchMethods :: FetchMethods e a,
  apiKey :: String
}

type QuoteEndpointParams = {
  symbol :: String
}

type QuoteEndpointResponse = {
  "Global Quote" :: {
    "01. symbol" :: String,
    "02. open" :: String,
    "03. high" :: String,
    "04. low" :: String,
    "05. price" :: String,
    "06. volume" :: String,
    "07. latest trading day" :: String,
    "08. previous close" :: String,
    "09. change" :: String,
    "10. change percent" :: String
  }
}

getQuote :: forall e a. QuoteEndpointParams -> ReaderAffEither (Environment e a) (ApiError e) QuoteEndpointResponse
getQuote { symbol } = ReaderAffEither \{ fetchMethods, apiKey } -> do 
    restResult <- fetchMethods.get $ makeUrl ("/query?function=GLOBAL_QUOTES&symbol=" <> symbol <> "&apikey=" <> apiKey )
    pure $ case restResult of 
      Left e -> Left (FetchError e)
      Right a -> decodeResponseBody fetchMethods a