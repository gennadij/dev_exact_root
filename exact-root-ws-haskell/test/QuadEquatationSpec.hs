module QuadEquatationSpec where

import Test.Hspec
import QuadEquation
import ExactRoot (Res (..))
import qualified Data.Ratio as DR

spec :: Spec
spec = do
  -- describe "Berechne nur eine Nullstellen" $ do
  --   it "x² + 2x + 1, x1 = -1" $ do -- D = b² - 4ac = 2² - 4 * 1 * 1 = 4 - 4 = 0
  --     berechneZweiNullStellen (F 1 2 1) (EZ (Just (-1)) (Just 2) (Just (-1))) 
  --     `shouldBe` 
  --     NS {zns_x1 = Just (EZ {ez_multiplikator = Just 0, ez_wurzelwert = Just 0, ez_radikand = Just 2}), zns_x2 = Nothing}
  --   it "x² + 2x + 1, x1 = -1 D = 0" $ do
  --     berechneEineNullStelle (F 1 2 1) `shouldBe` (-1) DR.% 1

  describe "Berechne Diskriminante" $ do 
    it "x² + 2x + 1, D = 0" $ do 
      ermittleDiskriminante (F 1 2 1) `shouldBe` ED 0 Eine
    it "2x² + 2x + 1, D = -4" $ do 
      ermittleDiskriminante (F 2 2 1) `shouldBe` ED (-4) Keine
    it "x² + 4x + 1, D = 12" $ do 
      ermittleDiskriminante (F 1 4 1) `shouldBe` ED 12 Zwei
    it "3x² + 2x - 1, D = 0" $ do 
      ermittleDiskriminante (F 3 2 (-1)) `shouldBe` ED 16 Zwei
  describe "Berechne Wurzel aus Diskriminante" $ do 
    it "D = 0" $ do
      berechneWurzelVonDiskriment 0 `shouldBe` Res (-1) (-1) 0
    it "D = -4" $ do
      berechneWurzelVonDiskriment (-4) `shouldBe` Res (-1) (-1) (-1)
    it "D = 12" $ do
      berechneWurzelVonDiskriment 12 `shouldBe` Res 2 3 (-1)
    it "D = 16" $ do
      berechneWurzelVonDiskriment 16 `shouldBe` Res (-1) 4 (-1) 
  describe "Berechen eine Nullstelle D = 0" $ do
    it "x² + 2x + 1, x1 = -1 D = 0" $ do
      berechne (F 1 2 1) `shouldBe` E 1 ((-1) DR.% 1)

    
