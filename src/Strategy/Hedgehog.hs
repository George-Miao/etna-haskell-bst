{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TemplateHaskell #-}

module Strategy.Hedgehog where

import Etna.Lib
import qualified Hedgehog as HH
import qualified Hedgehog.Gen as Gen
import qualified Hedgehog.Range as Range
import Impl
import Spec

class HGen a where
  hgen :: HH.Gen a

instance HGen Key where
  hgen = Key <$> Gen.int (Range.linear (-1000) 1000)

instance HGen Val where
  hgen = Val <$> Gen.int (Range.linear (-1000) 1000)

instance HGen BST where
  hgen =
    Gen.recursive
      Gen.choice
      [pure E]
      [T <$> hgen <*> hgen <*> hgen <*> hgen]

instance (HGen a, HGen b) => HGen (a, b) where
  hgen = (,) <$> hgen <*> hgen

instance (HGen a, HGen b, HGen c) => HGen (a, b, c) where
  hgen = (,,) <$> hgen <*> hgen <*> hgen

instance (HGen a, HGen b, HGen c, HGen d) => HGen (a, b, c, d) where
  hgen = (,,,) <$> hgen <*> hgen <*> hgen <*> hgen

instance (HGen a, HGen b, HGen c, HGen d, HGen e) => HGen (a, b, c, d, e) where
  hgen = (,,,,) <$> hgen <*> hgen <*> hgen <*> hgen <*> hgen

$( mkStrategies
     [|hhRunGen hhDefaults Naive hgen|]
     [ 'prop_InsertValid,
       'prop_DeleteValid,
       'prop_UnionValid,
       'prop_InsertPost,
       'prop_DeletePost,
       'prop_UnionPost,
       'prop_InsertModel,
       'prop_DeleteModel,
       'prop_UnionModel,
       'prop_InsertInsert,
       'prop_InsertDelete,
       'prop_InsertUnion,
       'prop_DeleteInsert,
       'prop_DeleteDelete,
       'prop_DeleteUnion,
       'prop_UnionDeleteInsert,
       'prop_UnionUnionAssoc
     ]
 )

test_UnionUnionIdem = hhRunGen hhDefaults Correct hgen prop_UnionUnionIdem
