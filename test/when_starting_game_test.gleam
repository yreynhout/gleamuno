import deck.{Blue, CounterClockWise, Digit, KickBack, Red, Skip, Three}
import game.{DirectionChanged, GameAlreadyStarted, GameStarted, StartGame, game}
import game_id
import player_count
import player_id
import prng/seed
import scenario.{Scenario, verify}

// Test 1: Game can start with 4 players and a red Three
pub fn game_can_start_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four
  let first_card = Digit(Three, Red)

  Scenario(
    name: "Game can start with 4 players and a red Three",
    given: [],
    when: StartGame(game_id, player_count, first_card),
    then: Ok([
      GameStarted(game_id, player_count, first_card, player_id.from_int(2)),
    ]),
  )
  |> verify(game_decider)
}

// Test 2: Starting a game that's already started should fail
pub fn cannot_start_game_twice_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four
  let first_card = Digit(Three, Red)

  Scenario(
    name: "Cannot start a game that's already started",
    given: [
      GameStarted(game_id, player_count, first_card, player_id.from_int(2)),
    ],
    when: StartGame(game_id, player_count, first_card),
    then: Error(GameAlreadyStarted),
  )
  |> verify(game_decider)
}

// Test 3: Starting with a KickBack card should change direction to CounterClockWise
pub fn starting_with_kickback_changes_direction_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four
  let first_card = KickBack(Blue)

  Scenario(
    name: "Starting with KickBack changes direction to CounterClockWise",
    given: [],
    when: StartGame(game_id, player_count, first_card),
    then: Ok([
      GameStarted(game_id, player_count, first_card, player_id.from_int(2)),
      DirectionChanged(game_id, CounterClockWise),
    ]),
  )
  |> verify(game_decider)
}

// Test 4: Starting with a Skip card should skip the first player
pub fn starting_with_skip_skips_first_player_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four
  let first_card = Skip(Blue)

  Scenario(
    name: "Starting with Skip skips the first player",
    given: [],
    when: StartGame(game_id, player_count, first_card),
    then: Ok([
      GameStarted(game_id, player_count, first_card, player_id.from_int(3)),
    ]),
  )
  |> verify(game_decider)
}
