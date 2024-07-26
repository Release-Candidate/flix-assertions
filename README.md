> [!WARNING]
> This repository has been moved to [Codeberg: Flix Assertions](https://codeberg.org/Release-Candidate/flix-assertions)

# Flix Assertions

Various additional assertions for the [Flix](https://flix.dev) programming language.

- [Latest Version](#latest-version)
- [Usage](#usage)
  - [Example](#example)
  - [Infix Format](#infix-format)
  - [Tests for "Contains"](#tests-for-contains)
  - [Emptiness](#emptiness)
  - [Why these Explicit Assertions?](#why-these-explicit-assertions)
- [Changes](#changes)
- [Build targets](#build-targets)
- [License](#license)

## Latest Version

See the latest [GitHub Release](https://github.com/Release-Candidate/flix-assertions/releases/latest)

## Usage

Add the following stanza to your `flix.toml`:

```toml
[dependencies]
"github:Release-Candidate/flix-assertions" = "0.3.0"
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
- String predicates:
  - `containsString`
  - `notContainsString`
  - `matchesString` - whether the whole string is matched by a regex
  - `notMatchesString` - whether the regex does not match the whole string
  - `matchesSubString` - whether the regex matches a substring of the given string
  - `notMatchesSubString` - whether the regex does not matche a substring of the given string
- Test, if a container contains a given element, for types like `List` or `Map`:
  - `FlixAssertion.contains`
  - `FlixAssertion.notContains`
- Test, if a container contains a given element, for mutable types like `MutList` or `Array`:
  - `FlixAssertion.containsEff`
  - `FlixAssertion.notContainsEff`
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

### Tests for "Contains"

To be able to test your type if it contains a given element, it must implement the `Contains` or `ContainsEff` type class.

The following Flix types already implement one of these:

- `Contains`:
  - `List`
  - `Vector`
  - `Chain`
  - `Nel`
  - `Nec`
  - `Map`
  - `Set`
  - `Multimap`
- `ContainsEff`:
  - `MutList`
  - `MutSet`
  - `Array`
  - `MutMap`

Examples on how to implement `Contains` and `ContainsEff`:

```flix
instance FlixAssertion.Contains[Nel] {

    pub override def contains(xs: Nel[a], x: a): Bool with Eq[a] =
        Nel.exists(e -> e == x, xs)
}
```

```flix
instance FlixAssertion.ContainsEff[MutSet] {

    pub override def contains(xs: MutSet[a, r], x: a): Bool \ {ef, r} with Eq[a] =
        checked_ecast(MutSet.exists(e -> e == x, xs))
}
```

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

### Why these Explicit Assertions?

Why does e.g. `containsString` exist and why isn't `eq` enough?

With the explicit comparisons the actual value that is compared is automatically printed, wheres with `eq` you needed to add it as `message` argument.

Example:

```flix
@Test
def testContainsText01(): Bool =
    FlixAssertion.eq(true, String.contains({substr = "The"}, "Find the word"), "Substring is not in string!")
```

error message:

```text
FAIL  testContainsText01
Assertion Error: Substring is not in string!
  Expected: true
  Actual:   false
```

vs.

```flix
@Test
def testContainsText02(): Bool =
    FlixAssertion.containsString("The", "Find the word", "Substring is not in string!")
```

error message:

```text
FAIL  testContainsText02
Assertion Error: Substring is not in string!
  Expected: 'Find the word' contains substring 'The'
  Actual:   'Find the word' does not contain 'The'
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
