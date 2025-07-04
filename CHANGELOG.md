# Changelog [![Elm package](https://img.shields.io/elm-package/v/dillonkearns/elm-rss.svg)](https://package.elm-lang.org/packages/dillonkearns/elm-rss/latest/)

All notable changes to
[the `dillonkearns/elm-rss` elm package](http://package.elm-lang.org/packages/dillonkearns/elm-rss/latest)
will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to
[Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.5] - 2025-06-18

### Fixed

- Fixed bug where `content:encoded` CDATA sections were incorrectly HTML-escaped, causing RSS feeds with HTML content to be malformed. The library now properly generates unescaped CDATA sections.

### Changed

- Switched from `billstclair/elm-xml-eeue56` to `dillonkearns/elm-xml-encode` for XML generation with proper CDATA support.

## [2.0.4] - 2024-04-02

### Fixed

- Bump minimum dependency of [`dmy/elm-imf-date-time`](https://package.elm-lang.org/packages/dmy/elm-imf-date-time) to 1.0.2 to remove dependency on
  renamed package (see https://github.com/dmy/elm-imf-date-time/pull/1).


## [2.0.3] - 2022-09-28

### Changed

- Updated <https://package.elm-lang.org/packages/justinmimbs/date/latest/> dependency.

## [2.0.2] - 2021-06-04

### Changed

- Updated <https://package.elm-lang.org/packages/billstclair/elm-xml-eeue56/latest> dependency.

## [2.0.1] - 2021-05-12

### Fixed

- Show categories in XML output (https://github.com/dillonkearns/elm-rss/pull/2).

## [2.0.0] - 2020-06-06

### Added

- Support enclosures (embedded files) and
    `<content:encoded>` tags (useful for embedding rendered HTML strings).

## [1.0.1] - 2020-06-06

### Fixed

- The `siteUrl`, and entries' `path`s are now correctly joined together with any
  permutation of trailing and leading slashes.
