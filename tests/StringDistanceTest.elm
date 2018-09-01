module StringDistanceTest exposing (expectFloatEqual, tests)

import Expect
import StringDistance exposing (sift3Distance)
import Test exposing (..)


expectFloatEqual expected actual =
    actual |> Expect.within (Expect.Absolute 0.0000000001) expected


tests : Test
tests =
    let
        testLcs s1 s2 =
            String.fromList (StringDistance.lcs (String.toList s1) (String.toList s2))

        testLcsLimit5 s1 s2 =
            String.fromList (StringDistance.lcsLimit 5 (String.toList s1) (String.toList s2))
    in
    describe "StringDistance tests"
        [ test "Trivial Test to ensure ElmTest is behaving" <| \() -> Expect.equal "a" "a"
        , describe "sift3Distance tests"
            [ test "Both strings empty returns 0" <| \() -> Expect.equal 0 (sift3Distance "" "")
            , test "First string empty returns length of Second string" <| \() -> Expect.equal 3 (sift3Distance "" "abc")
            , test "Second string empty returns length of First string" <| \() -> Expect.equal 2 (sift3Distance "ab" "")
            , test "Two same strings" <| \() -> Expect.equal 0 (sift3Distance "abc" "abc")
            , test "Two different strings \"abc\" \"ab\"" <| \() -> expectFloatEqual 0.5 (sift3Distance "abc" "ab")
            , test "Two different strings \"helloworld\" \"world\"" <| \() -> expectFloatEqual 2.5 (sift3Distance "helloworld" "world")

            -- These are to slow using lcs, fine with lcsLimit
            , test "1 char different start 17 chars long" <| \() -> expectFloatEqual 0.5 (sift3Distance "abcdefghijklmnopq" "bcdefghijklmnopq")
            , test "2 char different start 17 chars long" <| \() -> expectFloatEqual 1.0 (sift3Distance "abcdefghijklmnopq" "cdefghijklmnopq")
            , test "3 char different start 17 chars long" <| \() -> expectFloatEqual 1.5 (sift3Distance "abcdefghijklmnopq" "defghijklmnopq")
            , test "4 char different start 17 chars long" <| \() -> expectFloatEqual 2.0 (sift3Distance "abcdefghijklmnopq" "efghijklmnopq")
            , test "5 char different start 17 chars long" <| \() -> expectFloatEqual 2.5 (sift3Distance "abcdefghijklmnopq" "fghijklmnopq")
            , test "6 char different start 17 chars long" <| \() -> Expect.equal 14 (sift3Distance "abcdefghijklmnopq" "ghijklmnopq")

            -- this correlates with a test in Mailcheck for suggest to check string distance for its domains
            , test "check distance on this case" <| \() -> expectFloatEqual 7.5 (sift3Distance "kicksend.com" "emaildomain.com")
            ]
        , describe "lcs tests"
            [ test
                "1 char different start \"abcdefgh\" \"bcdefgh\""
              <|
                \() -> Expect.equal "bcdefgh" (testLcs "abcdefgh" "bcdefgh")
            , test
                "2 char different start\"abcdefgh\" \"cdefgh\""
              <|
                \() -> Expect.equal "cdefgh" (testLcs "abcdefgh" "cdefgh")
            , test
                "3 char different start \"abcdefgh\" \"defgh\""
              <|
                \() -> Expect.equal "defgh" (testLcs "abcdefgh" "defgh")
            , test
                "4 char different start \"abcdefgh\" \"efgh\""
              <|
                \() -> Expect.equal "efgh" (testLcs "abcdefgh" "efgh")
            , test
                "5 char different start \"abcdefgh\" \"fgh\""
              <|
                \() -> Expect.equal "fgh" (testLcs "abcdefgh" "fgh")
            ]
        , describe "lcsLimit tests"
            [ test
                "1 char different start \"abcdefgh\" \"bcdefgh\""
              <|
                \() -> Expect.equal "bcdefgh" (testLcsLimit5 "abcdefgh" "bcdefgh")
            , test
                "2 char different start\"abcdefgh\" \"cdefgh\""
              <|
                \() -> Expect.equal "cdefgh" (testLcsLimit5 "abcdefgh" "cdefgh")
            , test
                "3 char different start \"abcdefgh\" \"defgh\""
              <|
                \() -> Expect.equal "defgh" (testLcsLimit5 "abcdefgh" "defgh")
            , test
                "4 char different start \"abcdefgh\" \"efgh\""
              <|
                \() -> Expect.equal "efgh" (testLcsLimit5 "abcdefgh" "efgh")
            , test
                "5 char different start \"abcdefgh\" \"fgh\""
              <|
                \() -> Expect.equal "fgh" (testLcsLimit5 "abcdefgh" "fgh")
            , test
                "6 char different start \"abcdefgh\" \"gh\""
              <|
                \() -> Expect.equal "" (testLcsLimit5 "abcdefgh" "gh")
            , test
                "1 char different start longer string \"abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQURSTUVWXYZ\" \"bcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQURSTUVWXYZ\""
              <|
                \() ->
                    Expect.equal "bcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQURSTUVWXYZ"
                        (testLcsLimit5 "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQURSTUVWXYZ" "bcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQURSTUVWXYZ")
            ]
        ]
