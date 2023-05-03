// SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
// SPDX-License-Identifier: Apache-2.0
//
// Project:  flix-assertions
// File:     FlixAssertion.flix
// Date:     02.May.2023
//
// ==============================================================================
/// Example:
///
/// ```flix
/// @Test
/// def test01(): Bool =
///     FlixAssertion.eq(3, 1 + 1, "Something went wrong: '1 + 1'")
/// ```
/// Yields the error:
/// ```
///  FAIL  test01
///   Assertion Error: Something went wrong: '1 + 1'
///     Expected: 3
///     Actual:   2
/// ```

mod FlixAssertion {

    pub class Empty[a] {

        pub def name(_: a): String

        pub def isEmpty(x: a): Bool = not Empty.isNotEmpty(x)

        pub def isNotEmpty(x: a): Bool = not Empty.isEmpty(x)
    }

    pub class EmptyEff[m: Bool -> Type] {

        pub def name(_: m[r]): String

        pub def isEmpty(x: m[r]): Bool \ r = not EmptyEff.isNotEmpty(x)

        pub def isNotEmpty(x: m[r]): Bool \ r = not EmptyEff.isEmpty(x)
    }

    ///
    /// Backward pipe.
    ///
    /// `f(x) == f <| x`
    ///
    /// To enable writing e.g. `eq(e, a, message)` as
    /// ```
    /// (e `eq` a) <| message
    /// ```
    ///
    pub def <|(f: a -> b, x: a): b = f(x)

    ///
    /// Asserts that `expected` must equal `actual`.
    ///
    /// Aborts execution if the two values are not equal and prints the error
    /// message `message`.
    ///
    pub def eq(expected: a, actual: a, message: String): Bool with Eq[a], ToString[a] = masked_cast({
        if (expected == actual)
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green(expected)}");
            println("  Actual:   ${red(actual)}");
            println("");
            ?flixAssertEq
        }
    })

    ///
    /// Asserts that `expected` must not equal `actual`.
    ///
    /// Aborts execution if the two values are equal and prints the error
    /// message `message`.
    ///
    pub def neq(expected: a, actual: a, message: String): Bool with Eq[a], ToString[a] = masked_cast({
        if (expected != actual)
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green(expected)} != ${green(actual)}");
            println("  Actual:   ${red(expected)} == ${red(actual)}");
            println("");
            ?flixAssertEq
        }
    })

    pub def isEmpty(l: m[a], message: String): Bool with ToString[m[a]], Empty[m[a]] = masked_cast({
         if (Empty.isEmpty(l))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green("empty ${Empty.name(l)}")}");
            println("  Actual:   ${red(l)}");
            println("");
            ?flixAssertEmpty
        }
    })

    pub def isNotEmpty(l: m[a], message: String): Bool with ToString[m[a]], Empty[m[a]] = masked_cast({
         if (Empty.isNotEmpty(l))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green("not empty ${Empty.name(l)}")}");
            println("  Actual:   ${red(l)}");
            println("");
            ?flixAssertNotEmpty
        }
    })

    pub def isEmptyEff[m: Type -> Bool -> Type, a: Type, r: Bool](l: m[a, r], message: String, toString: m[a, r] -> String \ r): Bool with ToString[a], EmptyEff[m[a]] =
        masked_cast({
            if (EmptyEff.isEmpty(l))
                true
            else {
                use Console.{green, red};
                println("Assertion Error: ${red(message)}");
                println("  Expected: ${green("empty ${EmptyEff.name(l)}")}");
                println("  Actual:   ${red(toString(l))}");
                println("");
                ?flixAssertEmptyEff
            }
        })

    pub def isNotEmptyEff[m: Type-> Bool -> Type, a: Type, r: Bool](l: m[a, r], message: String, toString: m[a, r] -> String \ r): Bool with ToString[a], EmptyEff[m[a]] =
        masked_cast({
            if (EmptyEff.isNotEmpty(l))
                true
            else {
                use Console.{green, red};
                println("Assertion Error: ${red(message)}");
                println("  Expected: ${green("not empty ${EmptyEff.name(l)}")}");
                println("  Actual:   ${red(toString(l))}");
                println("");
                ?flixAssertNotEmptyEff
            }
        })

    instance Empty[List[a]] {

        pub override def isEmpty(x: List[a]): Bool = List.isEmpty(x)

        pub def name(_: List[a]): String = "List"
    }

    instance Empty[Vector[a]] {

        pub override def isEmpty(x: Vector[a]): Bool= Vector.isEmpty(x)

        pub def name(_: Vector[a]): String = "Vector"

    }

    instance Empty[Chain[a]] {

        pub override def isEmpty(x: Chain[a]): Bool = Chain.isEmpty(x)

        pub def name(_: Chain[a]): String = "Chain"

    }

    instance Empty[Map[k, v]] {

        pub override def isEmpty(x: Map[k, v]): Bool = Map.isEmpty(x)

        pub def name(_: Map[k, v]): String = "Map"

    }

    instance Empty[Set[a]] {

        pub override def isEmpty(x: Set[a]): Bool = Set.isEmpty(x)

        pub def name(_: Set[a]): String = "Set"

    }

    instance Empty[MultiMap[k, v]] {

        pub override def isEmpty(x: MultiMap[k, v]): Bool = MultiMap.isEmpty(x)

        pub def name(_: MultiMap[k, v]): String = "MultiMap"

    }

    instance EmptyEff[MutList[a]] {

        pub override def isEmpty(x: MutList[a, r]): Bool \ r  = MutList.isEmpty(x)

        pub def name(_: MutList[a, r]): String = "MutList"

    }

    instance EmptyEff[MutSet[a]] {

        pub override def isEmpty(x: MutSet[a, r]): Bool \ r = MutSet.isEmpty(x)

        pub def name(_: MutSet[a, r]): String = "MutSet"
    }

    instance EmptyEff[MutDeque[a]] {

        pub override def isEmpty(x: MutDeque[a, r]): Bool \ r = MutDeque.isEmpty(x)

        pub def name(_: MutDeque[a, r]): String = "MutDeque"
   }

    instance EmptyEff[Array[a]] {

        pub override def isEmpty(x: Array[a, r]): Bool \ r = checked_ecast(Array.isEmpty(x))

        pub def name(_: Array[a, r]): String = "Array"
    }

    instance EmptyEff[MutMap[k, v]] {

        pub override def isEmpty(x: MutMap[k, v, r]): Bool \ r = MutMap.isEmpty(x)

        pub def name(_: MutMap[k, v, r]): String = "MutMap"
    }

}
