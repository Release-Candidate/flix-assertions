# Flix Assertions

Various additional assertions for the [Flix](https://flix.dev) programming language.

- [Latest Version](#latest-version)
- [Usage](#usage)
  - [Example](#example)
  - [Infix Format](#infix-format)
  - [Emptiness](#emptiness)
- [Changes](#changes)
- [Build targets](#build-targets)
- [License](#license)

## Latest Version

See the latest [GitHub Release](https://github.com/Release-Candidate/flix-assertions/releases/latest)

## Usage

Add the following stanza to your `flix.toml`:

```toml
[dependencies]
"github:Release-Candidate/flix-assertions" = "0.2.0"
```

Available assertions:

- Equality:
  - `==`: `FlixAssertion.eq`, `FlixAssertion.$==`
  - `!=`: `FlixAssertion.neq`, `FlixAssertion.$!=`
- Ordering:
  - `>`: `FlixAssertion.gt`, `FlixAssertion.$>`
  - `>=`: `FlixAssertion.gte`, `FlixAssertion.$>=`
  - `<`: `FlixAssertion.lt`, `FlixAssertion.$<`
  - `<=`: `FlixAssertion.lte`, `FlixAssertion.$<=`
- Tests for emptiness, for types like `List` or `Map`:
  - `FlixAssertion.isEmpty`
  - `FlixAssertion.isNotEmpty`
- Tests for emptiness, version for mutable types like `MutList` or `Array`:
  - `FlixAssertion.isEmptyEff`
  - `FlixAssertion.isNotEmptyEff`

### Example

The following failing test

```flix
@Test
def test01(): Bool =
    FlixAssertion.eq(3, 1 + 1, "Something went wrong: '1 + 1'")
```

yields the error:

```text
 FAIL  test01
  Assertion Error: Something went wrong: '1 + 1'
    Expected: 3
    Actual:   2
```

### Infix Format

The following four examples `testEq0[1-4]` are the same:

```flix
@Test
def testEq01(): Bool =
    FlixAssertion.eq(3, 1 + 1, "Something went wrong: '1 + 1'")

@Test
def testEq02(): Bool =
    use FlixAssertion.{eq};
    "Something went wrong: '1 + 1'" |> (3 `eq` (1 + 1))

@Test
def testEq03(): Bool =
    use FlixAssertion.{eq, <|};
    (3 `eq` (1 + 1)) <| "Something went wrong: '1 + 1'"

@Test
def testEq04(): Bool =
    use FlixAssertion.{$==, <|};
    (3 $== (1 + 1)) <| "Something went wrong: '1 + 1'"
```

For more examples see the test source file [./test/TestMain.flix](./test/TestMain.flix)

### Emptiness

To be able to test your type for emptiness, it must implement the `Empty` or `EmptyEff` type class.

The following Flix types already implement one of these:

- `Empty`:
  - `List`
  - `Vector`
  - `Chain`
  - `Map`
  - `Set`
  - `Multimap`
- `EmptyEff`:
  - `MutList`
  - `MutSet`
  - `MutDeque`
  - `Array`
  - `MutMap`

Examples on how to implement `Empty` and `EmptyEff`:

```flix
instance Empty[Chain[a]] {

    pub override def isEmpty(x: Chain[a]): Bool = Chain.isEmpty(x)

    pub def name(_: Chain[a]): String = "Chain"

}
```

```flix
instance EmptyEff[MutMap[k, v]] {

    pub override def isEmpty(x: MutMap[k, v, r]): Bool \ r = MutMap.isEmpty(x)

    pub def name(_: MutMap[k, v, r]): String = "MutMap"
}
```

## Changes

See file [./CHANGELOG.md](./CHANGELOG.md)

## Build targets

The needed commands to build and test the library:

- display help: `java -jar flix.jar --help`
- open a REPL of the project: `java -jar flix.jar repl`
- typecheck the project: `java -jar flix.jar check`
- run the tests: `java -jar flix.jar test`
- compile sources: `java -jar flix.jar build`
- generate a Flix package: `java -jar flix.jar build-pkg`

## License

Flix Assertions is licensed under the Apache 2.0 license, see file [./LICENSE.md](./LICENSE.md)
