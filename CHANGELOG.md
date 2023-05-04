# Flix Assertions Changelog

## Version 0.3.0 (2023-05-04)

* add assertions `contains`, `notContains`, `containsEff`, `notContainsEff`
* add assertions `containsString`, `notContainsString`, `matchesString`, `notMatchesString`, `matchesSubString`, `notMatchesSubString`
* add documentation

### Internal Changes

* GitHub runners: use Flix 0.36.0
* GitHub runners: use environment variable `JAVA_HOME_17_X64` to get the path to Java 17
* GitHub release action: use Python script instead of the Rust script in `./scripts`

## Version 0.2.0 (2023-05-03)

* Add assertions: `lt` (`$<`), `lte` (`$<=`), `gt` (`$>`) and `gte` (`$>=`)
* add documentation

## Version 0.1.0 (2023-05-03)

Initial release
