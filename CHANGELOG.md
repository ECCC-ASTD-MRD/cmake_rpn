## Version 2.0.0

- The mechanism used to produce build_info.h files was modified to prevent regenerating
  those files every single time `make` was invoked. This caused needless rebuilds which
  could be quite quite long for larger projects. Instead, now the build_info.h files are
  only updated when the repository status' has changed.

 
### Breaking changes
- `BUILD_TIMESTAMP` is no longer defined in build_info.h Use `GIT_COMMIT_TIMESTAMP` instead.


### Non breaking changes
- `GIT_COMMIT` a string containing the commit hash was added to build_info.h
- `GIT_COMMIT_TIMESTAMP` a string containing the commit's timestamp was added to build_info.h
- `GIT_STATUS` a string representing the repository status (Clean|Dirty) was added
  to build_info.h
- `PROJECT_VERSION_STRING` the timestamp at the end of the string now corresponds to the
  commit instead of the build time