module Rest
  ( FetchMethods(..)
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

data FetchMethods e r = FetchMethods {
  get :: String -> Aff (Either e r),
  put :: forall c. EncodeJson c => String -> c -> Aff (Either e r),
  post :: forall c. EncodeJson c => String -> c -> Aff (Either e r),
  getResponseBody :: r -> Json
}

affjaxEnv :: FetchMethods Affjax.Error (Affjax.Response Json)
affjaxEnv = FetchMethods {
  get: Affjax.get AffjaxRF.json,
  put: \url c -> Affjax.put AffjaxRF.json url (M.Just $ AffjaxRB.json $ encodeJson c),
  post: \url c -> Affjax.post AffjaxRF.json url (M.Just $ AffjaxRB.json $ encodeJson c),
  getResponseBody: \r -> r.body
}
