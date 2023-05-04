// SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
// SPDX-License-Identifier: Apache-2.0
//
// Project:  flix-assertions
// File:     TestMain.flix
// Date:     02.May.2023
//
// =============================================================================
/// All tests fail!

// The same test in 4 different versions =======================================
// `FlixAssertion.eq`

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

// The same test in 4 different versions =======================================
// `FlixAssertion.neq`

@Test
def testNeq01(): Bool =
    FlixAssertion.neq(2, 1 + 1, "Something went wrong: '1 + 1'")

@Test
def testNeq02(): Bool =
    use FlixAssertion.{neq};
    "Something went wrong: '1 + 1'" |> (2 `neq` (1 + 1))

@Test
def testNeq03(): Bool =
    use FlixAssertion.{neq, <|};
    (2 `neq` (1 + 1)) <| "Something went wrong: '1 + 1'"

@Test
def testNeq04(): Bool =
    use FlixAssertion.{$!=, <|};
    (2 $!= (1 + 1)) <| "Something went wrong: '1 + 1'"

// The same test in 4 different versions =======================================
// `FlixAssertion.lt`

@Test
def testLt01(): Bool =
    FlixAssertion.lt(2, 1 + 1, "Something went wrong: '1 + 1'")

@Test
def testLt02(): Bool =
    use FlixAssertion.{lt };
    "Something went wrong: '1 + 1'" |> (2 `lt` (1 + 1))

@Test
def testLt03(): Bool =
    use FlixAssertion.{lt, <|};
    (2 `lt` (1 + 1)) <| "Something went wrong: '1 + 1'"

@Test
def testLt04(): Bool =
    use FlixAssertion.{$<, <|};
    (2 $< (1 + 1)) <| "Something went wrong: '1 + 1'"

// The same test in 4 different versions =======================================
// `FlixAssertion.lte`

@Test
def testLte01(): Bool =
    FlixAssertion.lte(3, 1 + 1, "Something went wrong: '1 + 1'")

@Test
def testLte02(): Bool =
    use FlixAssertion.{lte};
    "Something went wrong: '1 + 1'" |> (3 `lte` (1 + 1))

@Test
def testLte03(): Bool =
    use FlixAssertion.{lte, <|};
    (3 `lte` (1 + 1)) <| "Something went wrong: '1 + 1'"

@Test
def testLte04(): Bool =
    use FlixAssertion.{$<=, <|};
    (3 $<= (1 + 1)) <| "Something went wrong: '1 + 1'"

// The same test in 4 different versions =======================================
// `FlixAssertion.gt`

@Test
def testGt01(): Bool =
    FlixAssertion.gt(2, 1 + 1, "Something went wrong: '1 + 1'")

@Test
def testGt02(): Bool =
    use FlixAssertion.{gt};
    "Something went wrong: '1 + 1'" |> (2 `gt` (1 + 1))

@Test
def testGt03(): Bool =
    use FlixAssertion.{gt, <|};
    (2 `gt` (1 + 1)) <| "Something went wrong: '1 + 1'"

@Test
def testGt04(): Bool =
    use FlixAssertion.{$>, <|};
    (2 $> (1 + 1)) <| "Something went wrong: '1 + 1'"

// The same test in 4 different versions =======================================
// `FlixAssertion.gte`

@Test
def testGte01(): Bool =
    FlixAssertion.gte(1, 1 + 1, "Something went wrong: '1 + 1'")

@Test
def testGte02(): Bool =
    use FlixAssertion.{gte};
    "Something went wrong: '1 + 1'" |> (1 `gte` (1 + 1))

@Test
def testGte03(): Bool =
    use FlixAssertion.{gte, <|};
    (1 `gte` (1 + 1)) <| "Something went wrong: '1 + 1'"

@Test
def testGte04(): Bool =
    use FlixAssertion.{$>=, <|};
    (1 $>= (1 + 1)) <| "Something went wrong: '1 + 1'"

// End: the same test in 4 different versions ==================================

@Test
def testContainsString(): Bool =
    FlixAssertion.containsString("subString",
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean et est a dui semper facilisis. Pellentesque placerat elit a nunc. Nullam tortor odio, rutrum quis, egestas ut, posuere sed, felis. Vestibulum placerat feugiat nisl. Suspendisse lacinia, odio non feugiat vestibulum, sem erat blandit metus, ac nonummy magna odio pharetra felis. Vivamus vehicula velit non metus faucibus auctor. Nam sed augue. Donec orci. Cras eget diam et dolor dapibus sollicitudin. In lacinia, tellus vitae laoreet ultrices, lectus ligula dictum dui, eget condimentum velit dui vitae ante. Nulla nonummy augue nec pede. Pellentesque ut nulla. Donec at libero. Pellentesque at nisl ac nisi fermentum viverra. Praesent odio. Phasellus tincidunt diam ut ipsum. Donec eget est.",
     "Substring not found! :(")

@Test
def testNotContainsString(): Bool =
    FlixAssertion.notContainsString("facilisis",
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean et est a dui semper facilisis. Pellentesque placerat elit a nunc. Nullam tortor odio, rutrum quis, egestas ut, posuere sed, felis. Vestibulum placerat feugiat nisl. Suspendisse lacinia, odio non feugiat vestibulum, sem erat blandit metus, ac nonummy magna odio pharetra felis. Vivamus vehicula velit non metus faucibus auctor. Nam sed augue. Donec orci. Cras eget diam et dolor dapibus sollicitudin. In lacinia, tellus vitae laoreet ultrices, lectus ligula dictum dui, eget condimentum velit dui vitae ante. Nulla nonummy augue nec pede. Pellentesque ut nulla. Donec at libero. Pellentesque at nisl ac nisi fermentum viverra. Praesent odio. Phasellus tincidunt diam ut ipsum. Donec eget est.",
     "Substring found! :(")

@Test
def testMatchesString(): Bool =
    FlixAssertion.matchesString("ipsum.*",
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean et est a dui semper facilisis. Pellentesque placerat elit a nunc. Nullam tortor odio, rutrum quis, egestas ut, posuere sed, felis. Vestibulum placerat feugiat nisl. Suspendisse lacinia, odio non feugiat vestibulum, sem erat blandit metus, ac nonummy magna odio pharetra felis. Vivamus vehicula velit non metus faucibus auctor. Nam sed augue. Donec orci. Cras eget diam et dolor dapibus sollicitudin. In lacinia, tellus vitae laoreet ultrices, lectus ligula dictum dui, eget condimentum velit dui vitae ante. Nulla nonummy augue nec pede. Pellentesque ut nulla. Donec at libero. Pellentesque at nisl ac nisi fermentum viverra. Praesent odio. Phasellus tincidunt diam ut ipsum. Donec eget est.",
     "Regex does not match! :(")

@Test
def testNotMatchesString(): Bool =
    FlixAssertion.notMatchesString("Lorem.*est.",
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean et est a dui semper facilisis. Pellentesque placerat elit a nunc. Nullam tortor odio, rutrum quis, egestas ut, posuere sed, felis. Vestibulum placerat feugiat nisl. Suspendisse lacinia, odio non feugiat vestibulum, sem erat blandit metus, ac nonummy magna odio pharetra felis. Vivamus vehicula velit non metus faucibus auctor. Nam sed augue. Donec orci. Cras eget diam et dolor dapibus sollicitudin. In lacinia, tellus vitae laoreet ultrices, lectus ligula dictum dui, eget condimentum velit dui vitae ante. Nulla nonummy augue nec pede. Pellentesque ut nulla. Donec at libero. Pellentesque at nisl ac nisi fermentum viverra. Praesent odio. Phasellus tincidunt diam ut ipsum. Donec eget est.",
     "Regex does match! :(")

@Test
def testMatchesSubString(): Bool =
    FlixAssertion.matchesSubString("[0-9]+",
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean et est a dui semper facilisis. Pellentesque placerat elit a nunc. Nullam tortor odio, rutrum quis, egestas ut, posuere sed, felis. Vestibulum placerat feugiat nisl. Suspendisse lacinia, odio non feugiat vestibulum, sem erat blandit metus, ac nonummy magna odio pharetra felis. Vivamus vehicula velit non metus faucibus auctor. Nam sed augue. Donec orci. Cras eget diam et dolor dapibus sollicitudin. In lacinia, tellus vitae laoreet ultrices, lectus ligula dictum dui, eget condimentum velit dui vitae ante. Nulla nonummy augue nec pede. Pellentesque ut nulla. Donec at libero. Pellentesque at nisl ac nisi fermentum viverra. Praesent odio. Phasellus tincidunt diam ut ipsum. Donec eget est.",
     "Regex does not match! :(")

@Test
def testNotMatchesSubString(): Bool =
    FlixAssertion.notMatchesSubString("\\S+",
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean et est a dui semper facilisis. Pellentesque placerat elit a nunc. Nullam tortor odio, rutrum quis, egestas ut, posuere sed, felis. Vestibulum placerat feugiat nisl. Suspendisse lacinia, odio non feugiat vestibulum, sem erat blandit metus, ac nonummy magna odio pharetra felis. Vivamus vehicula velit non metus faucibus auctor. Nam sed augue. Donec orci. Cras eget diam et dolor dapibus sollicitudin. In lacinia, tellus vitae laoreet ultrices, lectus ligula dictum dui, eget condimentum velit dui vitae ante. Nulla nonummy augue nec pede. Pellentesque ut nulla. Donec at libero. Pellentesque at nisl ac nisi fermentum viverra. Praesent odio. Phasellus tincidunt diam ut ipsum. Donec eget est.",
     "Regex does match! :(")

@Test
def testContains01(): Bool =
    use FlixAssertion.{contains, <|};
    (Map#{"foo" => 12, "bar" => 42} `contains` 43) <| "Does Map contain 43?"

@Test
def testNotContains01(): Bool =
    use FlixAssertion.{notContains, <|};
    (Map#{"foo" => 12, "bar" => 42} `notContains` 42) <| "Does Map not contain 42?"

@Test
def testContainsEff01(): Bool =
    region r {
        let set = MutSet.new(r);
        MutSet.add!(5, set);
        MutSet.add!(2, set);
        FlixAssertion.containsEff(set, 43, "Does MutSet contain 43?", MutSet.toString)
    }

@Test
def testNotContainsEff01(): Bool =
    region r {
        let set = MutSet.new(r);
        MutSet.add!(5, set);
        MutSet.add!(42, set);
        FlixAssertion.notContainsEff(set, 42, "Does MutSet not contain 42?", MutSet.toString)
    }

@Test
def testEmpty01(): Bool =
    FlixAssertion.isEmpty(1 :: Nil, "This should be empty!")

@Test
def testNotEmpty01(): Bool =
    FlixAssertion.isNotEmpty(Vector#{}: Vector[Int32], "This should not be the empty vector!")

@Test
def testEmptyEff01(): Bool =
    region r {
        FlixAssertion.isEmptyEff(Array#{1, 2} @ r, "This should be empty!", Array.toString)
    }

@Test
def testNotEmptyEff01(): Bool =
    region r {
        let emptyList = MutList.new(r): MutList[Int32, r];
        FlixAssertion.isNotEmptyEff(emptyList, "This should not be the empty MutList!", MutList.toString)
    }

pub def main(): Unit \ IO = println("main")
