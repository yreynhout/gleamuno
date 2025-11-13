import gleam/list
import player_count.{type PlayerCount}
import player_id.{type PlayerId, from_int}
import prng/random
import prng/seed.{type Seed}

pub opaque type Players {
  Players(players: List(PlayerId))
}

pub fn from_count(count: PlayerCount) {
  Players(
    list.range(1, player_count.to_int(count))
    |> list.map(fn(id) { from_int(id) }),
  )
}

pub fn pick_first_player(players: Players, seed: Seed) {
  case players {
    Players(players) -> {
      let #(player, _) =
        random.int(1, list.length(players))
        |> random.map(fn(id) { player_id.from_int(id) })
        |> random.step(seed)
      player
    }
  }
}

pub fn next_player(players: Players, player: PlayerId) {
  case players {
    Players(player_list) -> {
      let player_count = list.length(player_list)
      let current_index = player.value - 1
      // Convert 1-based ID to 0-based index
      let next_index = { current_index + 1 } % player_count
      from_int(next_index + 1)
      // Convert back to 1-based ID
    }
  }
}

pub fn previous_player(players: Players, player: PlayerId) {
  case players {
    Players(player_list) -> {
      let player_count = list.length(player_list)
      let current_index = player.value - 1
      // Convert 1-based ID to 0-based index
      let previous_index = { current_index - 1 + player_count } % player_count
      from_int(previous_index + 1)
      // Convert back to 1-based ID
    }
  }
}
