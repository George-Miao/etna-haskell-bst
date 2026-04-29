{-# LANGUAGE TemplateHaskell #-}

module Main where

import Etna.Lib
import Data.List (lookup)
import Data.Maybe
import Strategy.Correct as Correct
import Strategy.Falsify as Falsify
import Strategy.FalsifyBuiltin as FalsifyBuiltin
import Strategy.Hedgehog as Hedgehog
import Strategy.Lean as Lean
import Strategy.LeanRev as LeanRev
import Strategy.Quick as Quick
import Strategy.Size as Size
import Strategy.Small as Small
import Strategy.SmallRev as SmallRev
import System.Environment (getArgs)

$( mkMain
     ( return
         [ "Correct",
           "Falsify",
           "FalsifyBuiltin",
           "Hedgehog",
           "Lean",
           "LeanRev",
           "Quick",
           "Size",
           "Small",
           "SmallRev"
         ]
     )
     (allProps "src/Spec.hs")
 )
