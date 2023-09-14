
# Changelog

## GHC 9.4.7

* cabal-install is now version 3.10
* **Breaking:** `prune-juice` has been removed. It is [deprecated](https://github.com/dfithian/prune-juice#readme).
  Users of this image should use `-Wunused-packages` [instead](https://downloads.haskell.org/~ghc/9.4.7/docs/users_guide/using-warnings.html?highlight=wunused%20packages#ghc-flag--Wunused-packages).
* **Breaking** `packdeps` has been removed.
  It has not had any updates since [2021](https://github.com/snoyberg/packdeps),
  requires building with GHC 8, and `cabal` now offers [similar functionality](https://cabal.readthedocs.io/en/stable/cabal-package.html#listing-outdated-dependency-version-bounds).
