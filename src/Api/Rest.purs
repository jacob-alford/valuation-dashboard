module Api.Rest
  ( AffjaxFetchMethods
  , FetchMethods(..)
  , affjaxEnv
  )
  where

import Affjax as Affjax
import Affjax.ResponseFormat as AffjaxRF
import Affjax.RequestBody as AffjaxRB
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Argonaut.Core (Json)
import Data.Either (Either)
import Data.Maybe as M
import Prelude
import Effect.Aff (Aff)

type FetchMethods e a = {
  get :: String -> Aff (Either e a),
  put :: forall c. EncodeJson c => String -> c -> Aff (Either e a),
  post :: forall c. EncodeJson c => String -> c -> Aff (Either e a),
  getResponseBody :: a -> Json
}

type AffjaxFetchMethods = FetchMethods Affjax.Error (Affjax.Response Json)

affjaxEnv :: AffjaxFetchMethods
affjaxEnv = {
  get: Affjax.get AffjaxRF.json,
  put: \url c -> Affjax.put AffjaxRF.json url (M.Just $ AffjaxRB.json $ encodeJson c),
  post: \url c -> Affjax.post AffjaxRF.json url (M.Just $ AffjaxRB.json $ encodeJson c),
  getResponseBody: \r -> r.body
}
