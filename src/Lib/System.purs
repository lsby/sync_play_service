module Lib.System where

import Hby.Task (Task)

foreign import getWssPort :: Task Int
