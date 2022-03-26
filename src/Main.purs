module Main where

import Prelude

import Effect.Aff (launchAff)
import Effect (Effect)
import Effect.Console (log)

import Api.AlphaVantage (getQuote)
import Api.Rest (affjaxEnv)
import Lib.ReaderAffEither (unwrap, supplyEnv)

{--

########### TODO ###########
* --Create Rest.FetchMethods--
* --Create API Structure--
* --Create ReaderAffEither module--
* Add API functions
  * Stocks
  * Crypto
  * Commodities
* Test API with CLI
* Add Halogen
  * Test run
* Finish TODO List with items from dashboard-persistence api

-}
main :: Effect Unit
main = do
  result <- launchAff $ supplyEnv { fetchMethods: affjaxEnv, apiKey: "T8IH8HUTJCHZ4X66" } $ getQuote { symbol: "IBM" }
  log result.run."Global Quote"."02. open"
