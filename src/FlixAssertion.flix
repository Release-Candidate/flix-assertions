// SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
// SPDX-License-Identifier: Apache-2.0
//
// Project:  flix-assertions
// File:     FlixAssertion.flix
// Date:     02.May.2023
//
// =============================================================================
///
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

    ///
    /// A type class to use as a "is the given container empty or not" predicate.
    ///
    /// Example:
    ///
    /// ```flix
    /// instance Empty[Chain[a]] {
    ///
    ///     pub override def isEmpty(x: Chain[a]): Bool = Chain.isEmpty(x)
    ///
    ///     pub def name(_: Chain[a]): String = "Chain"
    ///
    /// }
    /// ```
    ///
    pub class Empty[a] {

        ///
        /// A function that returns the name of the type.
        ///
        /// Example:
        /// `pub def name(_: a): String = "List"`
        ///
        pub def name(_: a): String

        ///
        /// A functions that returns `true` if the given container is empty.
        /// Empty means, that there are not elements in this container.
        ///
        /// One of `isEmpty` or `isNotEmpty` shall be overwritten.
        ///
        pub def isEmpty(x: a): Bool = not Empty.isNotEmpty(x)

        ///
        /// A functions that returns `true` if the given container is not empty.
        /// Empty means, that there is at least one elements in this container.
        ///
        /// One of `isEmpty` or `isNotEmpty` shall be overwritten.
        ///
        pub def isNotEmpty(x: a): Bool = not Empty.isEmpty(x)
    }

    ///
    /// A type class to use as a "is the given container empty or not" predicate.
    ///
    /// Example:
    ///
    /// ```flix
    /// instance EmptyEff[MutDeque[a]] {
    ///
    ///         pub override def isEmpty(x: MutDeque[a, r]): Bool \ r = MutDeque.isEmpty(x)
    ///
    ///         pub def name(_: MutDeque[a, r]): String = "MutDeque"
    ///     }
    /// ```
    ///
    pub class EmptyEff[m: Bool -> Type] {

        ///
        /// A function that returns the name of the type.
        ///
        /// Example:
        /// `pub def name(_: a): String = "MutMap"`
        ///
        pub def name(_: m[r]): String

        ///
        /// A functions that returns `true` if the given container is empty.
        /// Empty means, that there are not elements in this container.
        ///
        /// One of `isEmpty` or `isNotEmpty` shall be overwritten.
        ///
        pub def isEmpty(x: m[r]): Bool \ r = not EmptyEff.isNotEmpty(x)

        ///
        /// A functions that returns `true` if the given container is not empty.
        /// Empty means, that there is at least one elements in this container.
        ///
        /// One of `isEmpty` or `isNotEmpty` shall be overwritten.
        ///
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
    /// This is an alias of the infix operator `$==`.
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
    /// Asserts that `expected` must equal `actual`.
    ///
    /// Aborts execution if the two values are not equal and prints the error
    /// message `message`.
    ///
    /// This is an alias of `eq`.
    ///
    pub def $==(expected: a, actual: a, message: String): Bool with Eq[a], ToString[a] =
        eq(expected, actual, message)

    ///
    /// Asserts that `expected` must not equal `actual`.
    ///
    /// Aborts execution if the two values are equal and prints the error
    /// message `message`.
    ///
    /// This is an alias of the infix operator `$!=`.
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
            ?flixAssertNeq
        }
    })

    ///
    /// Asserts that `expected` must not equal `actual`.
    ///
    /// Aborts execution if the two values are equal and prints the error
    /// message `message`.
    ///
    /// This is an alias of `neq`.
    ///
    pub def $!=(expected: a, actual: a, message: String): Bool with Eq[a], ToString[a] =
        neq(expected, actual, message)

    ///
    /// Asserts that `smaller` is less than `bigger`.
    ///
    /// Aborts execution if `smaller` >= `bigger` and prints the error message
    /// `message`.
    ///
    /// This is an alias of `$<`.
    ///
    pub def lt(smaller: a, bigger: a, message: String): Bool with Order[a], ToString[a] = masked_cast({
        if (smaller < bigger)
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green(smaller)} ${green("<")} ${green(bigger)}");
            println("  Actual:   ${red(smaller)} ${red(">=")} ${red(bigger)}");
            println("");
            ?flixAssertLt
        }
    })

    ///
    /// Asserts that `smaller` is less than `bigger`.
    ///
    /// Aborts execution if `smaller` >= `bigger` and prints the error message
    /// `message`.
    ///
    /// This is an alias of `lt`.
    ///
    pub def $<(smaller: a, bigger: a, message: String): Bool with Order[a], ToString[a] =
        lt(smaller, bigger, message)

    ///
    /// Asserts that `smaller` is less than or equal to `bigger`.
    ///
    /// Aborts execution if `smaller` > `bigger` and prints the error message
    /// `message`.
    ///
    /// This is an alias of `$<=`.
    ///
    pub def lte(smaller: a, bigger: a, message: String): Bool with Order[a], ToString[a] = masked_cast({
        if (smaller <= bigger)
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green(smaller)} ${green("<=")} ${green(bigger)}");
            println("  Actual:   ${red(smaller)} ${red(">")} ${red(bigger)}");
            println("");
            ?flixAssertLte
        }
    })

    ///
    /// Asserts that `smaller` is less than or equal to `bigger`.
    ///
    /// Aborts execution if `smaller` >`bigger` and prints the error message
    /// `message`.
    ///
    /// This is an alias of `lte`.
    ///
    pub def $<=(smaller: a, bigger: a, message: String): Bool with Order[a], ToString[a] =
        lte(smaller, bigger, message)

    ///
    /// Asserts that `bigger` is greater than `smaller`.
    ///
    /// Aborts execution if `bigger` < `smaller` and prints the error message
    /// `message`.
    ///
    /// This is an alias of `$>`.
    ///
    pub def gt(bigger: a, smaller: a, message: String): Bool with Order[a], ToString[a] = masked_cast({
        if (smaller > bigger)
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green(bigger)} ${green(">")} ${green(smaller)}");
            println("  Actual:   ${red(bigger)} ${red("<=")} ${red(smaller)}");
            println("");
            ?flixAssertGt
        }
    })

    ///
    /// Asserts that `bigger` is greater than `smaller`.
    ///
    /// Aborts execution if `bigger` <= `smaller` and prints the error message
    /// `message`.
    ///
    /// This is an alias of `gt`.
    ///
    pub def $>(bigger: a, smaller: a, message: String): Bool with Order[a], ToString[a] =
        gt(bigger, smaller, message)

    ///
    /// Asserts that `bigger` is greater than or equal to `smaller`.
    ///
    /// Aborts execution if `bigger` < `smaller` and prints the error message
    /// `message`.
    ///
    /// This is an alias of `$<=`.
    ///
    pub def gte(bigger: a, smaller: a, message: String): Bool with Order[a], ToString[a] = masked_cast({
        if (bigger >= smaller)
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green(bigger)} ${green(">=")} ${green(smaller)}");
            println("  Actual:   ${red(bigger)} ${red("<")} ${red(smaller)}");
            println("");
            ?flixAssertGte
        }
    })

    ///
    /// Asserts that `bigger` is greater than or equal to `smaller`.
    ///
    /// Aborts execution if `bigger` < `smaller` and prints the error message
    /// `message`.
    ///
    /// This is an alias of `gte`.
    ///
    pub def $>=(bigger: a, smaller: a, message: String): Bool with Order[a], ToString[a] =
        gte(bigger, smaller, message)

    ///
    /// Asserts that `x` is empty (the empty list, empty set, empty map, ...).
    ///
    /// Aborts execution if `x` is not empty and prints the error message `message`.
    ///
    pub def isEmpty(x: m[a], message: String): Bool with ToString[m[a]], Empty[m[a]] = masked_cast({
         if (Empty.isEmpty(x))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green("empty ${Empty.name(x)}")}");
            println("  Actual:   ${red(x)}");
            println("");
            ?flixAssertEmpty
        }
    })

    ///
    /// Asserts that `x` is not empty (not the empty list, empty set, empty map, ...).
    ///
    /// Aborts execution if `x` is empty and prints the error message `message`.
    ///
    pub def isNotEmpty(x: m[a], message: String): Bool with ToString[m[a]], Empty[m[a]] = masked_cast({
         if (Empty.isNotEmpty(x))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green("not empty ${Empty.name(x)}")}");
            println("  Actual:   ${red(x)}");
            println("");
            ?flixAssertNotEmpty
        }
    })

    ///
    /// Asserts that `x` is empty (the empty list, empty set, empty map, ...).
    /// Needs a function `toString` with which to convert the given type
    /// to a `String`.
    ///
    /// Aborts execution if `x` is not empty and prints the error message `message`.
    ///
    pub def isEmptyEff[m: Type -> Bool -> Type, a: Type, r: Bool]
            (l: m[a, r], message: String, toString: m[a, r] -> String \ r): Bool with ToString[a], EmptyEff[m[a]] =
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

    ///
    /// Asserts that `x` is not empty (not the empty list, empty set, empty map,
    /// ...). Needs a function `toString` with which to convert the given type
    /// to a `String`.
    ///
    /// Aborts execution if `x` is empty and prints the error message `message`.
    ///
    pub def isNotEmptyEff[m: Type-> Bool -> Type, a: Type, r: Bool]
            (l: m[a, r], message: String, toString: m[a, r] -> String \ r): Bool with ToString[a], EmptyEff[m[a]] =
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

    // Implementations of `Empty` and `EmptyEff`. ==============================

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
