module Lib.Data where

type Time
  = Int

type WSSConf
  = { port :: Int
    }

foreign import data WSSHand :: Type

foreign import data WSHand :: Type
