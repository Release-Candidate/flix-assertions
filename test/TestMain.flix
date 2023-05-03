// SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
// SPDX-License-Identifier: Apache-2.0
//
// Project:  flix-assertions
// File:     TestMain.flix
// Date:     02.May.2023
//
// ==============================================================================

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
        FlixAssertion.isNotEmptyEff(MutList.new(r): MutList[Int32, r], "This should not be the empty MutList!", MutList.toString)
    }

pub def main(): Unit \ IO = println("main")
