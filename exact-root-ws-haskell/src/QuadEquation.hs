module QuadEquation (
  berechneZweiNullStellen
  , berechneEineNullStelle
  , berechneDiskriminante
  , ExacteZahl(..)
  , Form(..)
  , NullStellen(..)
) where
  
import qualified ExactRoot as ER (berechneExacteWurzel, Res ( .. ))
import qualified Data.Maybe as DM
import qualified Data.Ratio as DR

{--
ax² + bx + c = 0

       -b +- sqrt(D)
x12 = ----------------------
              2a
D = b² - 4ac

D == 0 x1
D < 0 
D > 0 x1/2

m * sqrt(D)
sqrt(D)

Devidend
---------
Devisor

--}


data Form = F {
  f_a :: Int,
  f_b :: Int,
  f_c :: Int
}

data Ergebnis = E {
  e_radikand :: Int,
  e_multiplikator :: Int
}

data ErgebnisDiskriminante = ED {
  ed_diskriminante :: Deskriminante,
  ed_anzahlNullstellen :: Int
}

data Deskriminante = D {
  d_wurzelWert :: Int,
  d_multiplikator :: Int
}

data ExacteZahl = EZ {
  ez_multiplikator :: Maybe Int, -- immer 1 wenn radikand 
  ez_wurzelwert :: Maybe Int,
  ez_radikand :: Maybe Int
} deriving (Eq, Show)

-- neue Data fuer Nullstellen, vorerst in zns_x1 Wurzelwert.
data NullStellen = NS {
  zns_x1 :: Maybe ExacteZahl,
  zns_x2 :: Maybe ExacteZahl
} deriving (Eq, Show)

berechne :: Form -> Ergebnis
berechne form = undefined

berechneDiskriminante_ :: Form -> ErgebnisDiskriminante
berechneDiskriminante_ f = ED diskriminante nullstellen
  where diskriminante :: Deskriminante
        diskriminante = undefined
        nullstellen :: Int
        nullstellen = undefined

pruefeDiskrimente :: Int -> Int
pruefeDiskrimente d
  | d < 0 = -1
  | d > 0 = 0
  | otherwise = 1

berechneDiskriminante :: Form -> Int
berechneDiskriminante f = berechneRadikand
  where berechneRadikand :: Int
        berechneRadikand = (b * b) - (4 * a * c)
          where b = f_b f
                a = f_a f
                c = f_c f

berechneWurzelVonDiskriment :: Int -> ER.Res
berechneWurzelVonDiskriment = ER.berechneExacteWurzel

{- 
Wenn wurzelwert > 0 (Just) rechne mit wurzelwert
Wenn radikand > 0 (Just) rechne mit multiplikator und schleppe radikand mit

Test
berechneZweiNullStellen (F 1 2 3) (EZ (Just (-1)) (Just 2) (Just (-1)))
-}
berechneZweiNullStellen :: Form -> ExacteZahl -> NullStellen
berechneZweiNullStellen f d
  | dMult == (-1) && dRadikand == (-1) = do -- Einfache Wurzelberechnung rechne mit dWurzelwert
    let devidend = berechneDevidendMitWurzelwertPositiv b dWurzelWert
    let devisor = berechneDevisorMitWurzelwert a
    if checkIfDevisionSuccessful devidend devisor
      then NS (Just (EZ (Just devidend) (Just (devidend `quot` devisor)) (Just devisor))) Nothing
      else NS Nothing Nothing
  | dRadikand == (-1) = undefined-- rechne mit Multiplikator und Wurzelwert mitschleppen
  | dMult == (-1) && dWurzelWert == (-1) = undefined-- rechne mit Multiplikator == 1 und schleppe radikand mit  (-1) * b + dMult
  | otherwise = undefined
  where a = f_a f
        b = f_b f
        c = f_c f
        dMult = DM.fromMaybe undefined (ez_multiplikator d)
        dRadikand = DM.fromMaybe undefined (ez_radikand d)
        dWurzelWert = DM.fromMaybe undefined (ez_wurzelwert d)

berechneEineNullStelle :: Form -> Rational
berechneEineNullStelle f = toInteger ((-1) * b) DR.% toInteger (2 * a)
  where a = f_a f
        b = f_b f
        c = f_c f

berechneDevidendMitWurzelwertPositiv :: Int -> Int -> Int
berechneDevidendMitWurzelwertPositiv b wurzelwert = (-1) * b + wurzelwert

berechneDevidendMitWurzelwertNegativ :: Int -> Int -> Int
berechneDevidendMitWurzelwertNegativ b wurzelwert = (-1) * b - wurzelwert

berechneDevisorMitWurzelwert :: Int -> Int
berechneDevisorMitWurzelwert a = 2 * a

checkIfDevisionSuccessful :: Int -> Int -> Bool
checkIfDevisionSuccessful devidend devisor
  | (devidend `mod` devisor) == 0 = True
  | otherwise = False

testBerechneZweiNullStellenEinfacheWurzelberechnung :: IO ()
testBerechneZweiNullStellenEinfacheWurzelberechnung =
  print $ berechneZweiNullStellen (F 1 2 3) (EZ (Just (-1)) (Just 2) (Just (-1)))