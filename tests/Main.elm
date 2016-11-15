port module Main exposing (..)

import Test.Runner.Node exposing (run, TestProgram)
import Json.Encode exposing (Value)

import StringDistanceTest


main : TestProgram
main =
    run emit StringDistanceTest.tests


port emit : ( String, Value ) -> Cmd msg
