import deck.{type Direction, ClockWise, CounterClockWise}
import player_count.{type PlayerCount}
import player_id.{type PlayerId}
import players.{type Players}
import prng/seed.{type Seed}

pub opaque type Turn {
  Turn(player: PlayerId, players: Players, direction: Direction)
}

pub fn start(seed: Seed, count: PlayerCount) {
  let players = players.from_count(count)
  let first_player = players.pick_first_player(players, seed)
  Turn(first_player, players, ClockWise)
}

pub fn start_with_player(count: PlayerCount, first_player: PlayerId) {
  let players = players.from_count(count)
  Turn(first_player, players, ClockWise)
}

pub fn next(turn: Turn) {
  case turn.direction {
    ClockWise -> {
      Turn(..turn, player: turn.players |> players.next_player(turn.player))
    }
    CounterClockWise -> {
      Turn(..turn, player: turn.players |> players.previous_player(turn.player))
    }
  }
}

pub fn is_players_turn(turn: Turn, player: PlayerId) {
  turn.player == player
}

pub fn current_player(turn: Turn) {
  turn.player
}

pub fn with_player(turn: Turn, player: PlayerId) {
  Turn(..turn, player: player)
}

pub fn current_direction(turn: Turn) {
  turn.direction
}

pub fn with_direction(turn: Turn, direction: Direction) {
  Turn(..turn, direction: direction)
}

pub fn skip(turn: Turn) {
  turn
  |> next
  |> next
}

pub fn reverse(turn: Turn) {
  case turn.direction {
    ClockWise -> {
      Turn(..turn, direction: CounterClockWise)
    }
    CounterClockWise -> {
      Turn(..turn, direction: ClockWise)
    }
  }
}
