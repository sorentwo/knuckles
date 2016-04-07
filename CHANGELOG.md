## v0.3.0 - 2016-04-07

* Added: Tons of documentation.
* Removed: Remove stage manipulation (`insert_*`, `delete`). All configuration
  must be done on pipeline init.
* Change: Move stage modules into the `Stages` namespace.
* Change: Use module names rather than provide a custom name method.

## v0.2.0 - 2016-03-23

* Add: Introduce the enhancer stage, used to augment data after it has been
  rendered but before it is combined. This allows pruning or augmenting rendered
  data after it has been retrieved from the cache, meaning results can be
  tailored to the "current user" of a request without per-user-caching.
* Add: Uniformly combine cached and rendered results regardless of key type.
  This also sees an improvement to the `uniq` check performed during dumping.

## v0.1.1 - 2016-03-22

* Performance: Improve unique handling by favoring a single `uniq!` call over
  the use of `Set`.

## v0.1.0 - 2016-03-21

* Initial release (third time's the charm).
