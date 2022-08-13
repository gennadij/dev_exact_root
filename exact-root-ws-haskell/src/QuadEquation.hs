module QuadEquation (
  berechneZweiNullStellen
  , berechneEineNullStelle
  , ermittleDiskriminante
  , berechneWurzelVonDiskriment
  , berechne 
  , ExacteZahl(..)
  , Form(..)
  , NullStellen(..)
  , ErgebnisDiskriminante (..)
  , AnzahlNullStellen (..)
  , Ergebnis (..)
) where

import qualified ExactRoot as ER (berechneExacteWurzel, Res ( .. ))
import qualified Data.Maybe as DM
import qualified Data.Ratio as DR
import ExactRoot (Res(multiplikator))

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
-- berecheDiskriminante gibt Anzahl der Nullstellen zureuck
data AnzahlNullStellen =  Keine | Eine | Zwei | Ungueltig deriving (Show, Eq)

data Form = F {
  f_a :: Int,
  f_b :: Int,
  f_c :: Int
}

data Ergebnis = E {
  e_x1 :: ErgebnisX1,
  e_x2 :: ErgebnisX2
} deriving (Eq, Show)

data ErgebnisX1 = EX1 {
  ex1_radikand :: Maybe Int,
  ex1_wurzelwert :: Maybe Rational,
  ex1_miltiplikator :: Maybe Int
} deriving (Eq, Show)

data ErgebnisX2 = EX2 {
  ex2_radikand :: Maybe Int,
  ex2_wurzelwert :: Maybe Rational,
  ex2_miltiplikator :: Maybe Int
} deriving (Eq, Show)

data ErgebnisDiskriminante = ED {
  ed_diskriminante :: Int,
  ed_anzahlNullstellen :: AnzahlNullStellen
} deriving (Show, Eq)

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
berechne form = case ermittleDiskriminante form of
    ED d Eine -> berechneEineNullStelle form
    ED d Keine -> undefined
    ED d Zwei -> berechneZweiNullStellen form (berechneWurzelVonDiskriment d)
    ED d Ungueltig -> undefined



ermittleDiskriminante :: Form -> ErgebnisDiskriminante
ermittleDiskriminante f = pruefeDiskriminate berechneDiskriminante
  where b = f_b f
        a = f_a f
        c = f_c f
        berechneDiskriminante :: Int
        berechneDiskriminante = (b * b) - (4 * a * c)
        pruefeDiskriminate :: Int -> ErgebnisDiskriminante
        pruefeDiskriminate d 
          | d == 0 = ED d Eine
          | d <  0 = ED d Keine
          | d >  0 = ED d Zwei
          | otherwise = ED d Ungueltig

berechneWurzelVonDiskriment :: Int -> ER.Res
berechneWurzelVonDiskriment = ER.berechneExacteWurzel

{- 
Wenn wurzelwert > 0 (Just) rechne mit wurzelwert
Wenn radikand > 0 (Just) rechne mit multiplikator und schleppe radikand mit

Test
berechneZweiNullStellen (F 1 2 3) (EZ (Just (-1)) (Just 2) (Just (-1)))
-}
berechneZweiNullStellen :: Form -> ER.Res-> Ergebnis
berechneZweiNullStellen f d
  | dMult == (-1) && dWurzelWert >= 1 && dRadikand == (-1)= do -- Einfache Wurzelberechnung rechne mit dWurzelwert
    let x1 = toInteger ((-1) * b + dWurzelWert) DR.% toInteger (2 * a)
    let x2 = ((-1) * b - dWurzelWert) DR.% (2 * a)
    E 1 x1
  | dRadikand == (-1) = undefined-- rechne mit Multiplikator und Wurzelwert mitschleppen
  | dMult == (-1) && dWurzelWert == (-1) = undefined-- rechne mit Multiplikator == 1 und schleppe radikand mit  (-1) * b + dMult
  | otherwise = undefined
  where a = f_a f
        b = f_b f
        c = f_c f
        dMult = ER.multiplikator d
        dRadikand = ER.radikand d
        dWurzelWert = ER.wurzelwert d

berechneEineNullStelle :: Form -> Ergebnis
berechneEineNullStelle f = E 1 (toInteger ((-1) * b) DR.% toInteger (2 * a))
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