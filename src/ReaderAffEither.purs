module ReaderAffEither
  ( ReaderAffEither(..)
  , unwrap
  )
  where

import Prelude
import Data.Bifunctor (class Bifunctor, bimap)
import Data.Either (Either(..))
import Effect.Aff (Aff)

newtype ReaderAffEither r e a = ReaderAffEither (r -> Aff (Either e a))

unwrap :: forall r e a. ReaderAffEither r e a -> r -> Aff (Either e a)
unwrap (ReaderAffEither reb) = reb

instance functorReaderAffEither :: Functor (ReaderAffEither r e) where
  map f (ReaderAffEither fa) = ReaderAffEither (map (map f) <<< fa)

instance applyReaderAffEither :: Apply (ReaderAffEither r e) where
  apply (ReaderAffEither fab) (ReaderAffEither fa) = ReaderAffEither \r -> do
    eab <- fab r
    ea <- fa r
    pure $ eab <*> ea

instance bindReaderAffEither :: Bind (ReaderAffEither r e) where
  bind (ReaderAffEither ma) amb = ReaderAffEither \r -> ma r >>= \ea ->
    case ea of
      (Left e) -> pure $ Left e
      (Right a) -> unwrap (amb a) $ r

instance applicativeReaderAffEither :: Applicative (ReaderAffEither r e) where
  pure = ReaderAffEither <<< const <<< pure <<< pure

instance monadReaderAffEither :: Monad (ReaderAffEither r e)

instance bifunctorReaderAffEither :: Bifunctor (ReaderAffEither r) where
  bimap fab fcd (ReaderAffEither fa) = ReaderAffEither \r -> fa r <#> bimap fab fcd