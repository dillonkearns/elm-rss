# Changelog [![Elm package](https://img.shields.io/elm-package/v/dillonkearns/elm-rss.svg)](https://package.elm-lang.org/packages/dillonkearns/elm-rss/latest/)

All notable changes to
[the `dillonkearns/elm-rss` elm package](http://package.elm-lang.org/packages/dillonkearns/elm-rss/latest)
will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to
[Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- The `siteUrl`, and entries' `path`s are now correctly joined together with any
  permutation of trailing and leading slashes.
