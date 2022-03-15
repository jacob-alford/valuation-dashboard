module RemoteData where

import Prelude
import Data.Bifunctor (class Bifunctor)

data RemoteData e a = Initial | Pending | Failure e | Success a

instance functorRemoteData :: Functor (RemoteData e) where
  map f (Success a) = Success (f a)
  map _ (Failure e) = Failure e
  map _ Initial = Initial
  map _ Pending = Pending

instance applyRemoteData :: Apply (RemoteData e) where
  apply (Failure e) Initial = Failure e
  apply _ Initial = Initial
  apply Pending Pending = Pending
  apply (Success _) Pending = Pending
  apply Initial Pending = Initial
  apply (Failure e) Pending = Failure e
  apply (Failure e) (Failure _) = Failure e
  apply _ (Failure e) = Failure e
  apply (Success f) (Success a) = Success (f a)
  apply Initial (Success _) = Initial
  apply Pending (Success _) = Pending
  apply (Failure e) (Success _) = Failure e

instance bindRemoteData :: Bind (RemoteData e) where
  bind (Success a) f = f a
  bind Initial _ = Initial
  bind Pending _ = Pending
  bind (Failure e) _ = Failure e

instance applicativeRemoteData :: Applicative (RemoteData e) where
  pure = Success

instance monadRemoteData :: Monad (RemoteData e)

instance bifunctorRemoteData :: Bifunctor RemoteData where
  bimap f _ (Failure e) = Failure (f e)
  bimap _ g (Success a) = Success (g a)
  bimap _ _ Initial = Initial
  bimap _ _ Pending = Pending