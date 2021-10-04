module ExactRoot
(
  berechneWurzel,
  Ergebnis ( .. )
) where
import Data.ByteString.Builder (int16HexFixed)
import Data.List.NonEmpty (nonEmpty)

data Ergebnis = Ergebnis {
  wurzelWert :: Int,
  multiplikator :: Int,
  berechnebar :: Bool
 } deriving (Eq, Show)

newtype EinfacheErgebnis = EE {
  ee_wurzelWert :: Int
} deriving (Eq, Show)

data KomplexeErgebnis = KE {
  ke_radikand :: Int,
  ke_multiplikator :: Int
} deriving (Eq, Show)

type Wurzelwert = Int
type Radikand   = Int

data StandardWerte = StandardWerte {
  radikands :: [Int],
  wurzelwerte_radikands :: [(Wurzelwert, Radikand)]
} deriving (Eq, Show)

-- Hauptfunktion welche die Schnittstelle difeniert
berechneWurzel :: Int -> Ergebnis
berechneWurzel radikand
  | multiplikator == 0 && rad == 0 = Ergebnis 0 0 False
  | einfacheWurzelwert == 0 = Ergebnis rad multiplikator True
  | otherwise = Ergebnis einfacheWurzelwert 0 True
    where standardWerte = berechneStandardwerte radikand
          einfacheErgebnis = berechneEinfacheWurzelwert radikand standardWerte
          komplexeWurzelwert = berechneKomplexeWurzelwert radikand standardWerte
          einfacheWurzelwert = ee_wurzelWert einfacheErgebnis
          multiplikator = ke_multiplikator komplexeWurzelwert
          rad = ke_radikand komplexeWurzelwert

berechneStandardwerte :: Int -> StandardWerte
berechneStandardwerte radikand =
  StandardWerte
    (berechneWurzelWerte ungeradeZahlen)
    (zip [2 .. radikand `quot` 2] (berechneWurzelWerte ungeradeZahlen))
  where
    ungeradeZahlen :: [Int]
    ungeradeZahlen = filter odd [1 .. radikand]
    berechneWurzelWerte :: [Int] -> [Int]
    berechneWurzelWerte [x] = []
    berechneWurzelWerte (x:y:xs)
      | summe <= radikand = summe : berechneWurzelWerte (summe : xs)
      | otherwise         = []
      where
        summe = x + y

berechneEinfacheWurzelwert :: Int -> StandardWerte -> EinfacheErgebnis
berechneEinfacheWurzelwert radikand_ standardWerte
  | null (radikands standardWerte) = EE 0
  | null einfacheWurzelWert          = EE 0
  | otherwise                        = EE (fst (head einfacheWurzelWert))
                                      where
                                        einfacheWurzelWert =
                                          filter
                                            (\radikand -> radikand_ == snd radikand)
                                            (wurzelwerte_radikands standardWerte)

-- quotRem -> (It returns a tuple: (result of integer division, reminder) )
berechneKomplexeWurzelwert :: Int -> StandardWerte -> KomplexeErgebnis
berechneKomplexeWurzelwert radikand_ standardWerte
  | null wW    = KE 0 0
  | otherwise  = KE (snd $ radicand wW) (fst $ radicand wW)
                    where
                      wW :: [(Int, Int)]
                      wW = wurzelwerte_radikands standardWerte
                      radicand :: [(Wurzelwert, Radikand)] -> (Int, Int)
                      radicand [] = (0, 0)
                      radicand (x:xs)
                        | snd ergebnisVonQuotRem == 0 = (fst x, fst ergebnisVonQuotRem)
                        | snd ergebnisVonQuotRem > 0  = radicand xs
                        | otherwise                   = (fst x, 0)
                        where ergebnisVonQuotRem = quotRem radikand_ (snd x)

