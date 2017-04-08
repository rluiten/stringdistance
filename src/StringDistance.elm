module StringDistance
    exposing
        ( sift3Distance
        , lcs
        , lcsLimit
        )

{-| A library to calculate a metric indicating the string distance between two strings.

This library was extracted from the Elm implementation of mailcheck <http://package.elm-lang.org/packages/rluiten/mailcheck/latest>.

The `lcs` and `lcsLimit` functions are more general and support more than just
Char as list elements.


## Functions

@docs sift3Distance
@docs lcs
@docs lcsLimit

-}

import String


{-| Calculate sift3 string distance between candidate strings.

```elm
    sift3Distance "" "abc" == 3.0
    sift3Distance "ab" "" == 2.0
    sift3Distance "abc" "abc" == 0
    sift3Distance "abc" "ab"  == 0.5
```

-}
sift3Distance : String -> String -> Float
sift3Distance s1 s2 =
    let
        s1Len =
            String.length s1

        s2Len =
            String.length s2

        lcs_ : List Char -> List Char -> List Char
        lcs_ =
            lcsLimit 5
    in
        if s1Len == 0 then
            toFloat s2Len
        else if s2Len == 0 then
            toFloat s1Len
        else
            let
                common =
                    lcs_ (String.toList s1) (String.toList s2)

                --_ = Debug.log("sift3Distance") (s1, s2, common, List.length common)
            in
                (toFloat (s1Len + s2Len) / 2) - toFloat (List.length common)


{-| Longest Common Subsequence

This is a simple implementation and would benefit from memoization if
performance is a problem. It does not limit look ahead
which can be very costly see lcsLimit for a limited look ahead version.

Warning this gets very slow very quickly with increases in list lengths even
17 character lists can cause things to bog down.

This implementation is based on <http://rosettacode.org/wiki/Longest_common_subsequence#Haskell>

```elm
    lcs ["a", "b", "c"] ["b", "c", "d"] == ["b", "c"]
```

-}
lcs : List a -> List a -> List a
lcs xs_ ys_ =
    case ( xs_, ys_ ) of
        ( x :: xs, y :: ys ) ->
            if x == y then
                x :: lcs xs ys
            else
                maxl (lcs xs_ ys) (lcs xs ys_)

        _ ->
            []


{-| Return function which returns lcs with limited look ahead.

Warning maxLookAhead quickly makes the returned function costly stay
below 8 if you want responsiveness.

```elm
    lcsLimit 5 ["a", "b", "c"] ["b", "c", "d"] == ["b", "c"]
```

-}
lcsLimit : Int -> List a -> List a -> List a
lcsLimit =
    lcsLimit_ 0


{-| Implementation of Longest Common Subsequence with look ahead limit.

This is a simple implementation and would benefit from memoization.

-}
lcsLimit_ : Int -> Int -> List a -> List a -> List a
lcsLimit_ offset maxLookAhead xs_ ys_ =
    if offset > maxLookAhead then
        []
    else
        case ( xs_, ys_ ) of
            ( x :: xs, y :: ys ) ->
                if x == y then
                    x :: lcsLimit_ 0 maxLookAhead xs ys
                else
                    maxl
                        (lcsLimit_ (offset + 1) maxLookAhead xs_ ys)
                        (lcsLimit_ (offset + 1) maxLookAhead xs ys_)

            _ ->
                []


{-| Return the List which is longer
-}
maxl xs ys =
    if List.length xs > List.length ys then
        xs
    else
        ys
