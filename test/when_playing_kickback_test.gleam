import deck.{
  Blue, ClockWise, CounterClockWise, Digit, Eight, Green, KickBack, Red,
}
import game.{CardPlayed, DirectionChanged, GameStarted, PlayCard, game}
import game_id
import player_count
import player_id
import prng/seed
import scenario.{Scenario, verify}

// Test 1: Playing a kickback reverses direction from ClockWise to CounterClockWise
pub fn playing_kickback_reverses_direction_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Playing a kickback reverses direction to CounterClockWise",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Eight, Red),
        player_id.from_int(2),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Eight, Green),
        player_id.from_int(3),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(3), KickBack(Green)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(3),
        KickBack(Green),
        player_id.from_int(2),
      ),
      DirectionChanged(game_id, CounterClockWise),
    ]),
  )
  |> verify(game_decider)
}

// Test 2: Playing another kickback reverses direction back to ClockWise
pub fn playing_second_kickback_reverses_back_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Playing a second kickback reverses direction back to ClockWise",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Eight, Red),
        player_id.from_int(2),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Eight, Green),
        player_id.from_int(1),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(2),
        KickBack(Green),
        player_id.from_int(1),
      ),
      DirectionChanged(game_id, CounterClockWise),
    ],
    when: PlayCard(game_id, player_id.from_int(1), KickBack(Blue)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(1),
        KickBack(Blue),
        player_id.from_int(2),
      ),
      DirectionChanged(game_id, ClockWise),
    ]),
  )
  |> verify(game_decider)
}
