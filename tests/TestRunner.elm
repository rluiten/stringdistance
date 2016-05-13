module TestRunner exposing (..)

import String
import ElmTest exposing (..)

import StringDistanceTest


main =
  runSuite
    ( suite "Element Test Runner Tests"
      [ StringDistanceTest.tests
      ]
    )
