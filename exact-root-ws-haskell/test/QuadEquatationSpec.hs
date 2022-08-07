module QuadEquatationSpec where

import Test.Hspec
import QuadEquation

spec :: Spec
spec = do
  describe "Berechne nur eine Nullstellen" $ do
    it "x² + 2x + 1, x1 = -1" $ do -- D = b² + 4ac = 2² - 4 * 1 * 1 = 4 + 4 = 0
      berechneZweiNullStellen (F 1 2 1) (EZ (Just (-1)) (Just 2) (Just (-1))) `shouldBe` NS {zns_x1 = Just (EZ {ez_multiplikator = Just 0, ez_wurzelwert = Just 0, ez_radikand = Just 2}), zns_x2 = Nothing}

    -- it "returns the first element of an *arbitrary* list" $
    --   property $ \x xs -> head (x:xs) == (x :: Int)

    -- it "throws an exception if used with an empty list" $ do
    --  evaluate (head []) `shouldThrow` anyException
