{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveAnyClass #-}
module Main where
import Data.Char (isPunctuation, isSpace, isDigit)
import Data.Monoid (mappend)
import Data.Text (Text)
import Control.Exception (finally)
import Control.Monad (forM_, forever, mzero)
import Control.Concurrent (MVar, newMVar, modifyMVar_, modifyMVar, readMVar)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Network.WebSockets as WS

import qualified ExactRoot as ER ( berechneWurzel, Ergebnis ( .. ))
import qualified ExactRoot2 as ER2 ( berechneExacteWurzel, Res ( .. )) 
import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as LB
import GHC.Base (MonadPlus(mzero))

-- new TestTyp
type Clients = [WS.Connection]

-- newClient
newClients :: Clients
newClients = []
-- Get the number of active clients:

-- new addClient
addClient :: WS.Connection -> Clients -> Clients
addClient conn clients = conn : clients

data RequestJson = RequestJson{
  requestAction :: String,
  requestData :: JsonData
} deriving (Show, Generic, FromJSON, ToJSON)

data JsonData = JsonData {
  radicand :: Int,
  resExactRootMultiplier :: String,
  resExactRootSqrt :: String
} deriving (Show, Generic, FromJSON, ToJSON)

data ResponseJson = ResponseJson {
  responseAction :: String,
  responseData :: JsonData
} deriving (Show, Generic, FromJSON, ToJSON)

-- Client request `{"jsonrpc":"2.0","method":"exact_root","params":{"radikand":50},"id":1}`

-- Server respons `{"jsonrpc":"2.0","result":{"multiplikator":5,"wurzelwert":2},"id":1}`
data Response = Response {
  response_jsonrpc :: String,
  response_result :: Result',
  response_id :: Int
} deriving (Show)

data Result' = Result' {
  result_multiplikator :: Int,
  result_wurzelwert :: Int,
  result_radikand :: Int
} deriving (Show)

data Request = Request {
  request_jsonrpc :: String,
  request_method :: String,
  request_params :: Params,
  request_id :: Int
} deriving (Show)

newtype Params = Params {
  params_radikand :: Int
} deriving (Show)

instance FromJSON Request where
 parseJSON (Object v) =
    Request <$> v .: "jsonrpc"
           <*> v .: "method"
           <*> v .: "params"
           <*> v .: "id"
 parseJSON _ = mzero

instance FromJSON Params where 
  parseJSON (Object v) = 
    Params <$> v .: "radikand"
  parseJSON _ = mzero

instance ToJSON Response where
 toJSON (Response response_jsonrpc response_result response_id) =
    object [ "jsonrpc"  .= response_jsonrpc
           , "result"   .= response_result
           , "id"       .= response_id
             ]

instance ToJSON Result' where
  toJSON (Result' result_multiplikator result_wurzelwert result_radikand) = 
    object [ "multiplikator" .= result_multiplikator
           , "wurzelwert" .= result_wurzelwert
           , "radikand" .= result_radikand
    ]
main :: IO ()
main = do
--    state <- newMVar newServerState
    T.putStrLn "Server started."
    
    clients <- newMVar newClients
    WS.runServer "127.0.0.1" 9160 $ application clients

-- Our main application has the type:

application :: MVar Clients -> WS.ServerApp

application clients pending = do
  conn <- WS.acceptRequest pending
  WS.withPingThread conn 30 (return ()) $ do
      modifyMVar_ clients $ \c -> do
        let cl = addClient conn c
        T.putStrLn "Client Connected."
        return cl
      -- WS.sendTextData conn ("Client connected" :: Text)
      talk conn clients

talk :: WS.Connection -> MVar Clients -> IO ()
talk conn clients = forever $ do
  msg <- WS.receiveData conn
  let response = Response {
    response_jsonrpc = "2.0",
    response_result = Result' 1 2 3, 
    response_id = 1
  }
  print (show (encode response))
  print msg
  handleMsg (decodeJson msg) conn

convertTextToInt :: Text -> Int
convertTextToInt st = read (T.unpack st) :: Int

handleMsg :: Maybe RequestJson -> WS.Connection -> IO ()
handleMsg jObject conn = case jObject of
  Just obj | isExactRoot $ requestAction obj -> WS.sendTextData conn (convertToJsonResponse (radicand (requestData obj)))
           | otherwise -> WS.sendTextData conn ("Unbekannte Anfrage" :: Text)
  Nothing -> WS.sendTextData conn ("Unbekante Anfrage" :: Text)

isNummeric :: String -> Bool
isNummeric [] = False
isNummeric xs = all isDigit xs

-- execExactRootString :: Int -> String
-- execExactRootString = calcExactRootString

convertToJsonResponse :: Int -> LB.ByteString
convertToJsonResponse radicand = encode (
  ResponseJson {
    responseAction = "exactRoot",
    responseData = JsonData {
      radicand = 0,
      resExactRootMultiplier = multiplier,
      resExactRootSqrt = sqrt
    }
  })
  where 
    multiplier = getMuliplier exactRoot
    sqrt = getSqrt exactRoot
    exactRoot = execExactRoot radicand


isExactRoot :: String -> Bool
isExactRoot action =
  action == "exactRoot"

decodeJson :: Text -> Maybe RequestJson
decodeJson msg = decode (WS.toLazyByteString msg) :: Maybe RequestJson

execExactRoot :: Int -> ER.Ergebnis
execExactRoot = ER.berechneWurzel

getMuliplier :: ER.Ergebnis -> String
getMuliplier e = show (ER.multiplikator e)

getSqrt :: ER.Ergebnis -> String
getSqrt e = show (ER.wurzelWert e) 
