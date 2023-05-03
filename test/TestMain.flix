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
