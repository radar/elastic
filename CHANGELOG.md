# Elastic Changelog

## 2.2.1

Handle `econnrefused` and `nxdomain` errors gracefully.

## 2.2

Added `Elastic.Document.API.search_query` for better compatibility with [`scrivener_elastic`](https://github.com/radar/scrivener_elastic).

## 2.1

* `Document.API.count` has now been moved to `Document.API.raw_count`. Use `raw_count` if you want to maintain the behaviour from 2.0.
* Added `Elastic.Query` for `Scrivener` compatibility. See the [`scrivener_elastic`](https://github.com/radar/scrivener_elastic) package for more information.

## 2.0

* `Document.API.search` has now been moved to `Document.API.raw_search`. Use `raw_search` if you want to maintain the behaviour from 1.0.

## 1.0

* Initial release.
