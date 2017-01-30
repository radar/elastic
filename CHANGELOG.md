# Elastic Changelog

## dev

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
