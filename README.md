# Flix Assertions

Various additional assertions for the [Flix](https://flix.dev) programming language.

## Usage

Add the following stanza to your `flix.toml`:

```toml
[dependencies]
"github:Release-Candidate/flix-assertions" = "0.1.0"
```

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

The following three examples `test01`, `test02` and `test03` are the same:

```flix
@Test
def test01(): Bool =
    FlixAssertion.eq(3, 1 + 1, "Something went wrong: '1 + 1'")

@Test
def test02(): Bool =
    use FlixAssertion.{eq};
    "Something went wrong: '1 + 1'" |> (3 `eq` (1 + 1))

@Test
def test03(): Bool =
    use FlixAssertion.{eq, <|};
    (3 `eq` (1 + 1)) <| "Something went wrong: '1 + 1'"
```

## License

Flix Assertions is licensed under the Apache 2.0 license, see file [./LICENSE.md](./LICENSE.md)
