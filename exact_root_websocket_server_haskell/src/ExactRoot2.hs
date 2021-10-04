module ExactRoot2
(
  berechneExacteWurzel
) where

berechneExacteWurzel :: Int -> Maybe(Int, Int)
berechneExacteWurzel radikand = do
  let ungeradeZahlen    = berechneUngeradeZahlen radikand
  let einfacheReihe       = berechneEinfacheReihe radikand
  let standardWerte       = berechneStandardWerte2 ungeradeZahlen
  let radikandWurzelwerte = zippen einfacheReihe standardWerte
  let einfacheWurzelwerte = berechneEinfacheWurzelwert' radikand radikandWurzelwerte
  let komplexeWurzelwerte = berechneKomplexeWurzelwert' radikand radikandWurzelwerte
  case einfacheWurzelwerte of
    Just r        -> Just(1, r)
    Nothing       -> komplexeWurzelwerte
    -- unberecenbare Radikand loest Nothig aus

berechneUngeradeZahlen :: Int -> [Int]
berechneUngeradeZahlen radikand = filter odd [1 .. radikand]

berechneEinfacheReihe :: Int -> [Int]
berechneEinfacheReihe radikand = [2 .. ((radikand `quot` 2) +1)]

berechneStandardWerte2 :: [Int] -> [Int]
berechneStandardWerte2 [] = []
berechneStandardWerte2 [x] = []
berechneStandardWerte2 (x:y:xs) = x + y : berechneStandardWerte2(x + y :xs)

zippen :: [Int] -> [Int] -> [(Int, Int)]
zippen = zip

berechneEinfacheWurzelwert' :: Int -> [(Int, Int)] -> Maybe Int
berechneEinfacheWurzelwert' radikand radikandWurzelwert = auspacken sucheEinfacheWurzelWert
  where
    auspacken :: [(Int, Int)] -> Maybe Int
    auspacken [(r,_)] = Just r
    auspacken ((_,_):y) = Nothing
    auspacken []  = Nothing
    sucheEinfacheWurzelWert :: [(Int, Int)]
    sucheEinfacheWurzelWert = filter (\(r, w) -> w == radikand) radikandWurzelwert

berechneKomplexeWurzelwert' :: Int -> [(Int, Int)] -> Maybe (Int, Int)
berechneKomplexeWurzelwert' radikand radikandWurzelwert = auspacken sucheKomplexeWurzelwert
  where
    auspacken :: [(Int, Int)] -> Maybe(Int, Int)
    auspacken [] = Nothing
    auspacken [(r, w)] = Just (r, radikand `quot` w)
    auspacken ((r, w) : y) = Just(r, radikand `quot` w)
    sucheKomplexeWurzelwert :: [(Int, Int)]
    sucheKomplexeWurzelwert = filter(\(r, w) -> (radikand `mod` w) == 0) radikandWurzelwert

    