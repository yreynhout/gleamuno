import decider.{type Decider, Decider}
import deck.{type Card, type Direction, CounterClockWise, Digit, KickBack, Skip}
import game_id.{type GameId}
import player_count.{type PlayerCount}
import player_id.{type PlayerId}
import players
import prng/seed.{type Seed}
import turn.{type Turn}

pub type Command {
  StartGame(game: GameId, player_count: PlayerCount, first_card: Card)
  PlayCard(game: GameId, player: PlayerId, card: Card)
}

pub type Event {
  GameStarted(
    game: GameId,
    player_count: PlayerCount,
    first_card: Card,
    first_player: PlayerId,
  )
  CardPlayed(game: GameId, player: PlayerId, card: Card, next_player: PlayerId)
  PlayerPlayedAtWrongTurn(game: GameId, player: PlayerId, card: Card)
  PlayerPlayedWrongCard(game: GameId, player: PlayerId, card: Card)
  DirectionChanged(game: GameId, direction: Direction)
}

pub type State {
  NotStarted
  Started(turn: Turn, top_card: Card)
}

pub type Error {
  GameAlreadyStarted
  GameHasNotStarted
}

pub fn game(seed: Seed) -> Decider(Command, State, Event, Error) {
  Decider(
    decide: fn(command, state) {
      case state, command {
        Started(_, _), StartGame(_, _, _) -> {
          Error(GameAlreadyStarted)
        }
        NotStarted, StartGame(game, player_count, first_card) -> {
          let players = players.from_count(player_count)
          let first_player =
            players
            |> players.pick_first_player(seed)
          let next_player =
            players
            |> players.next_player(first_player)
          case first_card {
            KickBack(_) ->
              Ok([
                GameStarted(game, player_count, first_card, first_player),
                DirectionChanged(game, CounterClockWise),
              ])
            Skip(_) -> {
              Ok([
                GameStarted(game, player_count, first_card, next_player),
              ])
            }
            Digit(_, _) ->
              Ok([
                GameStarted(game, player_count, first_card, first_player),
              ])
          }
        }
        NotStarted, PlayCard(_, _, _) -> {
          Error(GameHasNotStarted)
        }
        Started(turn, top_card), PlayCard(game, player, card) -> {
          case turn |> turn.is_players_turn(player) {
            False -> Ok([PlayerPlayedAtWrongTurn(game, player, card)])
            True -> {
              let cards_are_same_color_or_value =
                deck.are_same_color(card, top_card)
                || deck.are_same_value(card, top_card)
              case cards_are_same_color_or_value {
                True -> {
                  case card {
                    KickBack(_) -> {
                      let next_turn =
                        turn
                        |> turn.reverse
                        |> turn.next
                      Ok([
                        CardPlayed(
                          game,
                          player,
                          card,
                          next_turn |> turn.current_player,
                        ),
                        DirectionChanged(
                          game,
                          next_turn |> turn.current_direction,
                        ),
                      ])
                    }
                    Skip(_) -> {
                      let next_turn = turn |> turn.skip
                      Ok([
                        CardPlayed(
                          game,
                          player,
                          card,
                          next_turn |> turn.current_player,
                        ),
                      ])
                    }
                    Digit(_, _) -> {
                      let next_turn = turn |> turn.next
                      Ok([
                        CardPlayed(
                          game,
                          player,
                          card,
                          next_turn |> turn.current_player,
                        ),
                      ])
                    }
                  }
                }
                False -> Ok([{ PlayerPlayedWrongCard(game, player, card) }])
              }
            }
          }
        }
      }
    },
    evolve: fn(state, event) {
      case state, event {
        _, GameStarted(_, player_count, first_card, first_player) ->
          Started(turn.start_with_player(player_count, first_player), first_card)
        Started(turn, _), CardPlayed(_, _, card, next_player) ->
          Started(turn |> turn.with_player(next_player), card)
        Started(turn, top_card), DirectionChanged(_, direction) ->
          Started(turn |> turn.with_direction(direction), top_card)
        _, _ -> state
      }
    },
    initial_state: NotStarted,
  )
}
