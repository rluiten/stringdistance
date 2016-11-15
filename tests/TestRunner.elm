module TestRunner exposing (..)

import Html
import Runner.Log
import String
import Test exposing (..)
import Test.Runner exposing (run)

import StringDistanceTest


main : Program Never () msg
main =
  Html.beginnerProgram
    { model = ()
    , update = \_ _ -> ()
    , view = \() -> Html.text "Check the console for useful output!"
    }
    |> Runner.Log.run
      ( describe "Element Test Runner Tests"
        [ StringDistanceTest.tests
        ]
      )
