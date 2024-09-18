## Version 1.7.0

- The mechanism used to produce build_info.h files was modified to prevent regenerating
  those files every single time `make` was invoked. This caused needless rebuilds which
  could be quite quite long for larger projects. Instead, the build_info.h files are now
  only updated when the repository status' has changed.

### Deprecation
- `BUILD_TIMESTAMP` is deprecated and should no longer be used.
  Use `GIT_COMMIT_TIMESTAMP` instead.
  `BUILD_TIMESTAMP` will be removed in version 2.0.0.
  It is only kept for backward compatibility and no longer contains
  the actual build date but instead the date of the latest commit.


### Breaking changes
None.


### Non breaking changes
- `GIT_COMMIT` a string containing the commit hash was added to build_info.h
- `GIT_COMMIT_TIMESTAMP` a string containing the commit's timestamp was added to build_info.h
- `GIT_STATUS` a string representing the repository status (Clean|Dirty) was added
  to build_info.h
- `PROJECT_VERSION_STRING` the timestamp at the end of the string now corresponds to the
  commit instead of the build time