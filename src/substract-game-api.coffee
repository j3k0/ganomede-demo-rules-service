restify = require "restify"
restifyErrors = require "restify-errors"
log = require "./log"

alternateTurn = (players, lastTurn) ->
  if players.length == 1
    return players[0]
  return if lastTurn == players[0] then players[1] else players[0]

awardScores = (score, players, winner) ->
  return players.map (player) ->
    return if player == winner then score else 0

zeroScores = (players) ->
  return players.map () -> 0

postGame = (req, res, next) ->
  id = req.body?.id
  players = req.body?.players

  if !id or !players or !players.length
    return next new restifyErrors.BadRequestError "Missing required parameters"

  res.json
    id: id
    type: req.body.type
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
  finished = false

  if (!id or !players or !turn or
    !status or !gameData or !moveData
  ) then return next new restifyErrors.BadRequestError(
    "Missing required parameters")

  gameData.total -= moveData.number
  gameData.nMoves += 1

  if gameData.total < 0
    return res.send new restifyErrors.RestError
      statusCode: 400
      restCode: "InvalidMove"
      message: "Impossible to perform requested move"

  if gameData.total == 0
    status = "gameover"
    finished = true

  res.send
    id: id
    players: players
    type: req.body.type
    scores: if !finished then zeroScores(players) else
      awardScores(gameData.nMoves * 10, players, turn)
    turn: if finished then turn else alternateTurn(players, turn)
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
