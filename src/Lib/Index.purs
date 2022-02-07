module Lib.Index where

import Prelude
import Hby.Task (Task)
import Lib.Data (Time, WSHand, WSSHand, WSSConf)

-- wss
foreign import getWssHand :: WSSConf -> Task WSSHand

foreign import setWssOnConn :: WSSHand -> (WSHand -> Task Unit) -> Task Unit

-- ws
foreign import setWsOnPlay :: WSHand -> Task Unit -> Task Unit

foreign import setWsOnStop :: WSHand -> Task Unit -> Task Unit

foreign import setWsOnGoto :: WSHand -> (Time -> Task Unit) -> Task Unit

foreign import setWsOnDisConn :: WSHand -> (WSHand -> Task Unit) -> Task Unit

foreign import addId :: WSHand -> Task WSHand

-- link
foreign import getAllLink :: Task (Array WSHand)

foreign import addLink :: WSHand -> Task Unit

foreign import delLink :: WSHand -> Task Unit

foreign import getLinkNum :: Task Int
