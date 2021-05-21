# Elastic Changelog

## 3.7.0

Added a new `index` field to structs - if available - #38

## 3.5.0

Switched to passing authorization headers, rather than parameters, through to AWS (for AWS Signature v4). It seemed that AWS was passing these parameters through to Elastic Search, which was causing issues. See #23 for the original issue, and #24 for the fix.

## 3.4.0

Added `basic_auth` and `timeout` options to HTTP requests - #22

## 3.3.0

Fixed issue where posting with NDJSON body was broken - #20 / #31

## 3.2.0

* Bumped dependencies
* Switched from Poison to Jason for JSON encoding / decoding

## 3.1.1

Reject empty strings in Index.name/1 - #19

## 3.1.0

Added parameterised version of `Index.create` - #18

## 3.0.0

Support lots of different ElasticSearch versions.

## 2.6.1

Relax Poison dependency to allow ~> 2.2 or ~> 3.0.

## 2.6.0

* Increased default `Elastic.HTTP` timeout from 5 seconds to 30 seconds. This change was made because sufficiently large `bulk_create` queries may cause Elastic Search to take longer than 5 seconds to process them. If you're still seeing `bulk_create` queries timing out, consider splitting them into smaller queries.

## 2.5.0

* Added `Elastic.Scroller` for Scroll API support.

## 2.4.0

* Added `Elastic.Index.open/1` and `Elastic.Index.close/1`

## 2.3.5

* Added missing documentation for `Elastic.Index`

## 2.3.4

* Gracefully handle `connection_closed` errors from Elastic Search. These can occur, for example, when you're trying to index a document with an invalid ID: `Elastic.HTTP.post("/elastic_test/test/1 foo", body: %{test: true})`. (The ID of "1 foo" is not valid)
* Added `index_exists?` to `Document.API` so that you can call this function on the module that uses `Document.API`, rather than rolling your own version.

## 2.3.3

* Fixed a tiny issue with `Document.API` documentaiton.

## 2.3.2

* Added `Elastic.HTTP.head` for making `HEAD` requests.
* Added `Elastic.Index.exists?` for checking if an index exists or not.

## 2.3.1

* Fix bug where `Elastic.Bulk.update` would throw an error.

## 2.3.0

* Added `Elastic.Bulk` for bulk operations. Currently only supports `create` and `update`. See documentation for more information.
* `Document.API.index` and `Document.API.update` are no longer interchangeable. `update` will now do a partial update to the document, rather than creating a new version of that document.

## 2.2.2

Added `Elastic.HTTP.bulk`.

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
