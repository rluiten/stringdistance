module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import StringDistanceTest


all : Test
all =
    StringDistanceTest.tests
