Rules API
---------

This is a protocol to implement by "rules" services.

Rules services use no storage, they should be pure compute services.

# Game

A game has the following fields:

 * `id`
 * `players`: Array of players username
 * `turn`: username of the next player
 * `status`: one of
   * `active`
   * `gameover`
 * `gameData`:
   * `total`: remaining stones
   * `nMoves`: number of moves

# Moves

 * `moveData`:
   * `number`: 21

Will substract 21 to the number of remaining stones. Should be less that the total.

# /substract-game/v1/games [POST]

+ Parameters
    + type (string) ... Type of game

## body (application/json)

    {
        "id": "string",
        "players": [ "some_username", "other_username" ]
    }

## response [200] OK

    {
        "id": "string",
        "players": [ "some_username", "other_username" ],
        "turn": "some_username",
        "status": "active",
        "gameData": {
            "total": 121,
            "nMoves": 0
        }
    }

## /substract-game/v1/moves [POST]

+ Parameters
    + type (string) ... Type of game

## body (application/json)

    {
        "id": "string",
        "players": [ "some_username", "other_username" ],
        "turn": "some_username",
        "status": "active",
        "gameData": {
            "total": 121,
            "nMoves": 0
        },
        "moveData": {
            "number": 21
        }
    }

## response [200] OK

    {
        "id": "string",
        "players": [ "some_username", "other_username" ],
        "turn": "other_username",
        "status": "active",
        "gameData": {
            "total": 100,
            "nMoves": 1
        },
        "moveResult" {
        }
    }

## response [400] Bad Request

    {
        "code": "InvalidNumber"
    }

If a number > total was selected.

