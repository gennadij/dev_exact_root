# dev_rust
Dieser Projekt hat ein Ziel zu zeigen, wie sich die Implementierung gleicher 
Logik in Sprachen **c++**, **rust**, **haskel** unterscheiden.    

## Logik der Berechnung

Exacte Berechnung der Wurzel
Die Berechnung beruht auf das Prenzip der Summe ungeraden Reihen.

Beispiel sqrt(50)
1 + 3 = [4]
4 + 5 = [4,9]
9 + 7 = [4,9,16]
16 + 9 = [4,9,16,25]
25 + 11 = [4,9,16,25,36]
36 + 13 = [4,9,16,25,36,49]

1. Berschne ungerade Reihe bis 50
2. Berechne in der ungerade Reihe die summe der ersten zwei Elemente und hänge
   diese an der neue Reihe (siehe oben). 
3. Parallel zu der o.g. Reihe wird zu jedem Wert einen Wert aus der einfache 
   Reihe angehaengt z.B. [(2,4),(3,9),(4,16)]. In weiteren Beschreibung wird 
   diese Reihe als Wurzelwert_Radikand genannt.
   Funktion : berechneStandardwerte Int -> StandardWerte
4. Berechne einfache Wurzelwert z.B. sqrt(25) = 5
   Dazu wird einfach in der Reihe Wurzelwert_Radikand der zweite Wert 
   (Radikand) verglichen und der erste Wert (Wurzelwert) als Ergebnis
   ausgegeben
   Funktion : berechneEinfacheWurzelwert
5. Berechnung des komplexen Wurzelwertes z.B. sqrt(50) = 5 * sqrt(2)
   Bei der komplexen Berechnung wird Iterativ versucht jeden Radikand aus der 
   Reihe Wurzelwert_Radikand mit Hilfe der quotRem funktion zu teilen.
   Wenn einen Teiler ohne Rest gefunden wird wird der Ergebnis zu dem
   unberechnetem Radikand unter Wurzel und der Wurzelwert aus der Reihe 
   Werzelwert_Radikand zu dem Multiplikator. 
   5 = Multiplikator
   sqrt(2) =  unberechneter Radikand

# JSON Format

Client request {"jsonrpc":"2.0","method":"exact_root","params":{"radikand":50},"id":1}
Server respons {"jsonrpc":"2.0","result":{"multiplikator":5,"wurzelwert":2},"id":1}