{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
  [ "aff"
  , "affjax"
  , "argonaut"
  , "argonaut-codecs"
  , "bifunctors"
  , "console"
  , "effect"
  , "maybe"
  , "psci-support"
  , "remotedata"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
