module QuadEquation () where
import qualified ExactRoot as ER (berechneWurzel, Res ( .. ))

{--
ax² + bx + c = 0

       -b +- sqrt(D)
x12 = ----------------------
              2a
D = b² + 4ac

D == 0 x1
D < 0 
D > 0 x1/2

m * sqrt(D)
sqrt(D)

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

data NullStellen = NS {
  zns_x1 :: Maybe ExacteZahl
  zns_x2 :: Maybe ExacteZahl
}

berechne :: Form -> Ergebnis
berechne form = undefined



berechneDiskriminante_ :: Form -> ErgebnisDiskriminante
berechneDiskriminante_ f = ED diskriminante nullstellen
  where diskriminante :: Deskriminante 
        diskriminante = undefined 
        nullstellen :: Int
        nullstellen = 1


pruefeDiskrimente :: Int -> Int
pruefeDiskrimente d
  | d < 0 = -1
  | d > 0 = 
  | otherwise = 1 

berechneDiskriminante :: Form -> Int
berechneDiskriminante f = berechneRadikand
  where berechneRadikand :: Int 
        berechneRadikand = (b * b) - (4 * a * c)
          where b = f_b f
                a = f_a f
                c = f_c f

berechneWurzelVonDiskriment :: Int -> ER.Res
berechneWurzelVonDiskriment -> berechneWurzel

{- 
Wenn wurzelwert > 0 (Just) rechne mit wurzelwert
Wenn radikand > 0 (Just) rechne mit multiplikator und sleppe radikand mit
-}
berechneZweiNullStellen :: Form -> ExacteZahl -> ExacteZahl
berechneZweiNullStellen f d  = (-1) * b + dMult
  where a = f_a f
        b = f_b f
        c = f_c f
        dMult = ez_multiplikator d
        dRadikand = ez_radikand d
        dWurzelWert = ez_wurzelwert d