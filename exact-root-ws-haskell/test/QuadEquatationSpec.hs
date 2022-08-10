module QuadEquatationSpec where

import Test.Hspec
import QuadEquation 
-- (berechneEineNullStelle, berechneDiskriminante, ExacteZahl(..), Form (..), NullStellen (..))
import qualified Data.Ratio as DR

spec :: Spec
spec = do
  describe "Berechne nur eine Nullstellen" $ do
    it "x² + 2x + 1, x1 = -1" $ do -- D = b² - 4ac = 2² - 4 * 1 * 1 = 4 - 4 = 0
      berechneZweiNullStellen (F 1 2 1) (EZ (Just (-1)) (Just 2) (Just (-1))) 
      `shouldBe` 
      NS {zns_x1 = Just (EZ {ez_multiplikator = Just 0, ez_wurzelwert = Just 0, ez_radikand = Just 2}), zns_x2 = Nothing}

    it "x² + 2x + 1, x1 = -1 D = 0" $ do
      berechneEineNullStelle (F 1 2 1) `shouldBe` (-1) DR.% 1
  describe "Berechne Diskriminante" $ do 
    it "x² + 2x + 1, D = 0" $ do 
      berechneDiskriminante (F 1 2 1) `shouldBe` 0
    it "2x² + 2x + 1, D = -4" $ do 
      berechneDiskriminante (F 2 2 1) `shouldBe` -4
    it "x² + 4x + 1, D = 12" $ do 
      berechneDiskriminante (F 1 4 1) `shouldBe` 12
    it "3x² + 2x - 1, D = 0" $ do 
      berechneDiskriminante (F 3 2 (-1)) `shouldBe` 16
