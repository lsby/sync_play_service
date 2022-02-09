module Lib.SendToWs (sendToWs, Cmd(..), sendToAllLink) where

import Prelude
import Control.Apply (lift2)
import Data.Array (foldl)
import Hby.Task (Task)
import Lib.Data (WSHand, Time)
import Lib.Index (getAllLink)

type RawObj
  = { cmd :: String, data :: Time }

foreign import _sendToWs :: WSHand -> RawObj -> Task Unit

data Cmd
  = PlayCmd
  | StopCmd
  | GotoCmd Time

sendToWs :: WSHand -> Cmd -> Task Unit
sendToWs ws cmd = case cmd of
  PlayCmd -> _sendToWs ws { cmd: "play", data: 0 }
  StopCmd -> _sendToWs ws { cmd: "stop", data: 0 }
  GotoCmd a -> _sendToWs ws { cmd: "goto", data: a }

sendToAllLink :: Cmd -> Task Unit
sendToAllLink cmd = do
  arr <- getAllLink
  foldl append mempty $ lift2 sendToWs arr $ pure cmd
