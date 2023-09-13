
# Changelog

## GHC 9.4.7

* cabal-install is now version 3.10
* `prune-juice` has been removed. It is [deprecated](https://github.com/dfithian/prune-juice#readme).
  Users of this image should use `-Wunused-packages` [instead](https://downloads.haskell.org/~ghc/9.4.7/docs/users_guide/using-warnings.html?highlight=wunused%20packages#ghc-flag--Wunused-packages).
