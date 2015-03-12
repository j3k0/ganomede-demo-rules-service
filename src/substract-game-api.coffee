restify = require "restify"
log = require "./log"

postGame = (req, res, next) ->
  id = req.body?.id
  players = req.body?.players

  if !id or !players or !players.length
    return next new restify.BadRequestError "Missing required parameters"

  res.send
    id: id
    players: players
    turn: players[0]
    status: "active"
    gameData:
      total: 200
      nMoves: 0
  next()

postMove = (req, res, next) ->
  id = req.body?.id
  players = req.body?.players
  turn = req.body?.turn
  status = req.body?.status
  gameData = req.body?.gameData
  moveData = req.body?.moveData

  if (!id or !players or !turn or
    !status or !gameData or !moveData
  ) then return next new restify.BadRequestError "Missing required parameters"

  gameData.total -= moveData.number
  gameData.nMoves += 1

  if gameData.total < 0
    return res.send new restify.RestError
      statusCode: 400
      restCode: "InvalidMove"
      message: "Impossible to perform requested move"

  if gameData.total == 0
    status = "gameover"

  res.send
    id: id
    players: players
    scores: [gameData.nMoves * 10]
    turn: turn
    status: status
    gameData:
      total: gameData.total
      nMoves: gameData.nMoves

  next()

addRoutes = (prefix, server) ->
  log.info "POST /#{prefix}/game"
  server.post "/#{prefix}/games", postGame

  log.info "POST /#{prefix}/moves"
  server.post "/#{prefix}/moves", postMove

module.exports =
  addRoutes: addRoutes

# vim: ts=2:sw=2:et:
