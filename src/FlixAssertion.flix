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
    /// A type class to use as `does the container contain the given element?`
    /// predicate.
    ///
    /// Example:
    ///
    /// ```flix
    /// instance FlixAssertion.Contains[Nec] {
    ///
    ///     pub override def contains(xs: Nec[a], x: a): Bool with Eq[a] =
    ///          Nec.exists(e -> e == x, xs)
    // }
    /// ```
    ///
    pub class Contains[m: Type -> Type] {

        ///
        /// Return `true` if `xs` contains the element `x`, `false` else.
        ///
        /// Only one of `contains` and `notContains` shall be overwritten.
        ///
        pub def contains(xs: m[a], x: a): Bool with Eq[a] =
            not Contains.notContains(xs, x)

        ///
        /// Return `true` if `xs` does not contain the element `x`, `false` else.
        ///
        /// Only one of `contains` and `notContains` shall be overwritten.
        ///
        pub def notContains(xs: m[a], x: a): Bool with Eq[a] =
            not Contains.contains(xs, x)
    }

    ///
    /// A type class to use as `does the container contain the given element?`
    /// predicate for mutable types (like `MutList`).
    ///
    /// Example:
    ///
    /// ```flix
    /// instance FlixAssertion.ContainsEff[MutList] {
    ///
    ///     pub override def contains(xs: MutList[a, r], x: a): Bool \ {ef, r} with Eq[a] =
    ///         checked_ecast(MutList.exists(e -> e == x, xs))
    ///
    /// }
    /// ```
    ///
    pub class ContainsEff[m: Type -> Bool -> Type] {

        ///
        /// Return `true` if `xs` contains the element `x`, `false` else.
        ///
        /// Only one of `contains` and `notContains` shall be overwritten.
        ///
        pub def contains(xs: m[a, r], x: a): Bool \ {ef, r} with Eq[a] =
            not ContainsEff.notContains(xs, x)

        ///
        /// Return `true` if `xs` does not contain the element `x`, `false` else.
        ///
        /// Only one of `contains` and `notContains` shall be overwritten.
        ///
        pub def notContains(xs: m[a, r], x: a): Bool \ {ef, r} with Eq[a] =
            not ContainsEff.contains(xs, x)
    }

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
    /// Asserts that the string `s` contains the substring `subString`.
    ///
    /// Aborts execution if the string `s` does not contain the substring
    /// `subString` and prints the error message `message`.
    ///
    pub def containsString(subString: String, s: String, message: String): Bool = masked_cast({
        if (String.contains({substr = subString}, s))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: '${green(s)}' contains substring '${green(subString)}'");
            println("  Actual:   '${red(s)}' does not contain '${red(subString)}'");
            println("");
            ?flixAssertSubStr
        }
    })

    ///
    /// Asserts that the string `s` does not contain the substring `subString`.
    ///
    /// Aborts execution if the string `s` contains the substring `subString`
    /// and prints the error message `message`.
    ///
    pub def notContainsString(subString: String, s: String, message: String): Bool = masked_cast({
        if (not String.contains({substr = subString}, s))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: '${green(s)}' does not contain substring '${green(subString)}'");
            println("  Actual:   '${red(s)}' contains '${red(subString)}'");
            println("");
            ?flixAssertNotSubStr
        }
    })

    ///
    /// Asserts that the regex `regex` matches the whole string `s`.
    ///
    /// Aborts execution if the string `s` is not matched as a whole by the regex
    /// `regex` and prints the error message `message`.
    ///
    pub def matchesString(regex: String, s: String, message: String): Bool = masked_cast({
        if (String.isMatch({ regex = regex }, s))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: regex '${green(regex)}' matches string '${green(s)}'");
            println("  Actual:   regex '${red(regex)}' does not match string '${red(s)}'");
            println("");
            ?flixAssertMatch
        }
    })

    ///
    /// Asserts that the regex `regex` does not match the whole string `s`.
    ///
    /// Aborts execution if the string `s` is matched as a whole by the regex
    /// `regex` and prints the error message `message`.
    ///
    pub def notMatchesString(regex: String, s: String, message: String): Bool = masked_cast({
        if (not String.isMatch({ regex = regex }, s))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: regex '${green(regex)}' does not match string '${green(s)}'");
            println("  Actual:   regex '${red(regex)}' matches string '${red(s)}'");
            println("");
            ?flixAssertNotMatch
        }
    })

    ///
    /// Asserts that the regex `regex` matches a substring of string `s`.
    ///
    /// Aborts execution if no substring of the string `s` is  matched by the regex
    /// `regex` and prints the error message `message`.
    ///
    pub def matchesSubString(regex: String, s: String, message: String): Bool = masked_cast({
        if (String.isSubmatch({ regex = regex }, s))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: regex '${green(regex)}' matches substring of '${green(s)}'");
            println("  Actual:   regex '${red(regex)}' does not match substring of '${red(s)}'");
            println("");
            ?flixAssertMatchSub
        }
    })

    ///
    /// Asserts that the regex `regex` matches a substring of string `s`.
    ///
    /// Aborts execution if no substring of the string `s` is  matched by the regex
    /// `regex` and prints the error message `message`.
    ///
    pub def notMatchesSubString(regex: String, s: String, message: String): Bool = masked_cast({
        if (not String.isSubmatch({ regex = regex }, s))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: regex '${green(regex)}' does not match substring of '${green(s)}'");
            println("  Actual:   regex '${red(regex)}' matches substring of '${red(s)}'");
            println("");
            ?flixAssertNotMatchSub
        }
    })

    ///
    /// Asserts that the container `xs` contains the element `x`.
    ///
    /// Aborts execution if the container `xs` does not contain the element
    /// `x` and prints the error message `message`.
    ///
    pub def contains(xs: m[a], x: a, message: String): Bool with ToString[m[a]], ToString[a], Contains[m], Eq[a] = masked_cast({
        if (Contains.contains(xs, x))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green(xs)} contains ${green(x)}");
            println("  Actual:   ${red(xs)} does not contain ${red(x)}");
            println("");
            ?flixAssertContains
        }
    })

    ///
    /// Asserts that the mutable container `xs` contains the element `x`.
    /// Needs a function `toString` with which to convert the given type
    /// to a `String`.
    ///
    /// Aborts execution if the container `xs` does not contain the element
    /// `x` and prints the error message `message`.
    ///
    pub def containsEff[m: Type -> Bool -> Type, a: Type, r: Bool]
            (xs: m[a, r], x: a, message: String, toString: m[a, r] -> String \ r):
                 Bool with ToString[a], ContainsEff[m], Eq[a] = masked_cast({
        if (ContainsEff.contains(xs, x))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green(toString(xs))} contains ${green(x)}");
            println("  Actual:   ${red(toString(xs))} does not contain ${red(x)}");
            println("");
            ?flixAssertContainsEff
        }
    })

    ///
    /// Asserts that the container `xs` does not contain the element `x`.
    ///
    /// Aborts execution if the container `xs` contains the element
    /// `x` and prints the error message `message`.
    ///
    pub def notContains(xs: m[a], x: a, message: String): Bool with ToString[m[a]], ToString[a], Contains[m], Eq[a] = masked_cast({
        if (Contains.notContains(xs, x))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green(xs)} does not contain ${green(x)}");
            println("  Actual:   ${red(xs)} contains ${red(x)}");
            println("");
            ?flixAssertNotContains
        }
    })

    ///
    /// Asserts that the mutable container `xs` does not contain the element `x`.
    /// Needs a function `toString` with which to convert the given type
    /// to a `String`.
    ///
    /// Aborts execution if the container `xs` contains the element
    /// `x` and prints the error message `message`.
    ///
    pub def notContainsEff[m: Type -> Bool -> Type, a: Type, r: Bool]
        (xs: m[a, r], x: a, message: String, toString: m[a, r] -> String \ r):
            Bool with ToString[a], ContainsEff[m], Eq[a] = masked_cast({
        if (ContainsEff.notContains(xs, x))
            true
        else {
            use Console.{green, red};
            println("Assertion Error: ${red(message)}");
            println("  Expected: ${green(toString(xs))} does not contain ${green(x)}");
            println("  Actual:   ${red(toString(xs))} contains ${red(x)}");
            println("");
            ?flixAssertNotContainsEff
        }
    })

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

    // Implementations of `Contains` and `ContainsEff` =========================

    instance FlixAssertion.Contains[List] {

        pub override def contains(xs: List[a], x: a): Bool with Eq[a] =
            List.exists(e -> e == x, xs)
    }

    instance FlixAssertion.Contains[Vector] {

        pub override def contains(xs: Vector[a], x: a): Bool with Eq[a] =
            Vector.exists(e -> e == x, xs)
    }

    instance FlixAssertion.Contains[Chain] {

        pub override def contains(xs: Chain[a], x: a): Bool with Eq[a] =
            Chain.exists(e -> e == x, xs)
    }

    instance FlixAssertion.Contains[Nel] {

        pub override def contains(xs: Nel[a], x: a): Bool with Eq[a] =
             Nel.exists(e -> e == x, xs)
    }

    instance FlixAssertion.Contains[Nec] {

        pub override def contains(xs: Nec[a], x: a): Bool with Eq[a] =
             Nec.exists(e -> e == x, xs)
    }

    instance FlixAssertion.Contains[Set] {

        pub override def contains(xs: Set[a], x: a): Bool with Eq[a] =
            Set.exists(e -> e == x, xs)
    }

    instance FlixAssertion.Contains[Map[k]] {

        pub override def contains(xs: Map[k, v], x: v): Bool with Eq[v] =
            Map.exists((_, v) -> v == x, xs)
    }

    instance FlixAssertion.Contains[MultiMap[k]] {

        pub override def contains(xs: MultiMap[k, v], x: v): Bool with Eq[v] =
            MultiMap.exists((_, v) -> v == x, xs)
    }

    instance FlixAssertion.ContainsEff[MutList] {

        pub override def contains(xs: MutList[a, r], x: a): Bool \ {ef, r} with Eq[a] =
            checked_ecast(MutList.exists(e -> e == x, xs))

    }

    instance FlixAssertion.ContainsEff[MutSet] {

        pub override def contains(xs: MutSet[a, r], x: a): Bool \ {ef, r} with Eq[a] =
            checked_ecast(MutSet.exists(e -> e == x, xs))
    }

    instance FlixAssertion.ContainsEff[Array] {

        pub override def contains(xs: Array[a, r], x: a): Bool \ {ef, r} with Eq[a] =
            checked_ecast(Array.exists(e -> e == x, xs))
    }

    instance FlixAssertion.ContainsEff[MutMap[k]] {

        pub override def contains(xs: MutMap[k, v, r], x: v): Bool \ {ef, r} with Eq[v] =
            checked_ecast(MutMap.exists((_, v) -> v == x, xs))
    }

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
