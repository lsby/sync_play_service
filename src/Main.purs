module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Hby.Task (Task, liftEffect, runTask_)
import Lib.Data (WSHand)
import Lib.Index (addId, addLink, delLink, getWssHand, setWsOnDisConn, setWsOnPlay, setWsOnStop, setWsOnGoto, setWssOnConn)
import Lib.SendToWs (Cmd(..), sendToAllLink)
import Lib.System (getWssPort)

main :: Effect Unit
main =
  runTask_ do
    wssPort <- getWssPort
    wss <- getWssHand { port: wssPort }
    liftEffect $ log "服务器已启动"
    setWssOnConn wss onConn
  where
  onConn :: WSHand -> Task Unit
  onConn ws = do
    liftEffect $ log "有客户端连接"
    addId ws
    addLink ws
    setWsOnPlay ws do
      liftEffect $ log "广播Play消息"
      sendToAllLink $ PlayCmd
    setWsOnStop ws do
      liftEffect $ log "广播Stop消息"
      sendToAllLink $ StopCmd
    setWsOnGoto ws \t -> do
      liftEffect $ log $ "广播Goto消息:" <> show t
      sendToAllLink $ GotoCmd t
    setWsOnDisConn ws \w -> do
      liftEffect $ log "有客户端断开"
      delLink w
