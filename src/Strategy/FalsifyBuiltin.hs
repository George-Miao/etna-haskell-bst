{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TemplateHaskell #-}

module Strategy.FalsifyBuiltin where

import Etna.Lib
import Impl
import Spec
import Test.Falsify.Generator (Gen)
import qualified Test.Falsify.Generator as Gen
import qualified Test.Falsify.Range as Range
import Unsafe.Coerce (unsafeCoerce)

class FGen a where
  fgen :: Gen a

instance FGen Key where
  fgen = Key <$> Gen.int (Range.withOrigin (-1000, 1000) 0)

instance FGen Val where
  fgen = Val <$> Gen.int (Range.withOrigin (-1000, 1000) 0)

instance FGen BST where
  fgen =
    fromBuiltinBST
      <$> Gen.bst genVal (mkInclusiveInterval (-1000 :: Int) (1000 :: Int))
    where
      genVal :: Int -> Gen Val
      genVal _ = fgen

instance (FGen a, FGen b) => FGen (a, b) where
  fgen = (,) <$> fgen <*> fgen

instance (FGen a, FGen b, FGen c) => FGen (a, b, c) where
  fgen = (,,) <$> fgen <*> fgen <*> fgen

instance (FGen a, FGen b, FGen c, FGen d) => FGen (a, b, c, d) where
  fgen = (,,,) <$> fgen <*> fgen <*> fgen <*> fgen

instance (FGen a, FGen b, FGen c, FGen d, FGen e) => FGen (a, b, c, d, e) where
  fgen = (,,,,) <$> fgen <*> fgen <*> fgen <*> fgen <*> fgen

fromBuiltinBST :: Gen.Tree (Int, Val) -> BST
fromBuiltinBST Gen.Leaf = E
fromBuiltinBST (Gen.Branch (k, v) l r) =
  T (fromBuiltinBST l) (Key k) v (fromBuiltinBST r)

data EndpointShim a
  = InclusiveShim a
  | ExclusiveShim a

data IntervalShim a = IntervalShim (EndpointShim a) (EndpointShim a)

-- falsify-0.3.0 exports `bst` but does not publicly export `Interval`.
mkInclusiveInterval :: a -> a -> b
mkInclusiveInterval lo hi =
  unsafeCoerce (IntervalShim (InclusiveShim lo) (InclusiveShim hi))

$( mkStrategies
     [|fsRunGen fsDefaults Naive fgen|]
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

test_UnionUnionIdem = fsRunGen fsDefaults Correct fgen prop_UnionUnionIdem
