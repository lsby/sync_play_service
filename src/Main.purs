module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Hby.Task (Task, liftEffect, runTask_)
import Lib.Data (WSHand)
import Lib.Index (addId, addLink, delLink, getLinkNum, getWssHand, setWsOnDisConn, setWsOnGoto, setWsOnPlay, setWsOnStop, setWssOnConn)
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
    num <- getLinkNum
    liftEffect $ log $ "有客户端连接, 当前人数: " <> show (num + 1)
    ws' <- addId ws
    addLink ws'
    setWsOnPlay ws' do
      liftEffect $ log "广播Play消息"
      sendToAllLink $ PlayCmd
    setWsOnStop ws' do
      liftEffect $ log "广播Stop消息"
      sendToAllLink $ StopCmd
    setWsOnGoto ws' \t -> do
      liftEffect $ log $ "广播Goto消息:" <> show t
      sendToAllLink $ GotoCmd t
    setWsOnDisConn ws' \w -> do
      n <- getLinkNum
      liftEffect $ log $ "有客户端断开, 当前人数: " <> show (n - 1)
      delLink w
