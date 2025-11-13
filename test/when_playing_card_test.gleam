import deck.{
  CounterClockWise, Digit, Eight, KickBack, Nine, Red, Skip, Three, Yellow,
}
import game.{
  CardPlayed, DirectionChanged, GameStarted, PlayCard, PlayerPlayedAtWrongTurn,
  PlayerPlayedWrongCard, game,
}
import game_id
import player_count
import player_id
import prng/seed
import scenario.{Scenario, verify}

// Test 1: Playing a card with same color is accepted
pub fn same_color_is_accepted_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Playing a card with same color is accepted",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Three, Red),
        player_id.from_int(2),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(2), Digit(Eight, Red)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Eight, Red),
        player_id.from_int(3),
      ),
    ]),
  )
  |> verify(game_decider)
}

// Test 2: Playing a card with same value is accepted
pub fn same_value_is_accepted_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Playing a card with same value is accepted",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Three, Red),
        player_id.from_int(2),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(2), Digit(Three, Yellow)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Three, Yellow),
        player_id.from_int(3),
      ),
    ]),
  )
  |> verify(game_decider)
}

// Test 3: Playing a wrong card is rejected
pub fn wrong_card_is_rejected_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Playing a wrong card is rejected",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Three, Red),
        player_id.from_int(2),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(2), Digit(Eight, Yellow)),
    then: Ok([
      PlayerPlayedWrongCard(
        game_id,
        player_id.from_int(2),
        Digit(Eight, Yellow),
      ),
    ]),
  )
  |> verify(game_decider)
}

// Test 4: Playing at wrong turn is rejected
pub fn wrong_turn_is_rejected_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Playing at wrong turn is rejected",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Three, Red),
        player_id.from_int(2),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(3), Digit(Eight, Red)),
    then: Ok([
      PlayerPlayedAtWrongTurn(game_id, player_id.from_int(3), Digit(Eight, Red)),
    ]),
  )
  |> verify(game_decider)
}

// Test 5: When starting with kickback, next player is in reverse direction
pub fn kickback_reverses_direction_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "When starting with kickback, next player is in reverse direction",
    given: [
      GameStarted(game_id, player_count, KickBack(Red), player_id.from_int(2)),
      DirectionChanged(game_id, CounterClockWise),
    ],
    when: PlayCard(game_id, player_id.from_int(2), Digit(Nine, Red)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Nine, Red),
        player_id.from_int(1),
      ),
    ]),
  )
  |> verify(game_decider)
}

// Test 6: When starting with skip, next player is skipped
pub fn skip_skips_player_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "When starting with skip, next player is skipped",
    given: [
      GameStarted(game_id, player_count, Skip(Red), player_id.from_int(3)),
    ],
    when: PlayCard(game_id, player_id.from_int(3), Digit(Nine, Red)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(3),
        Digit(Nine, Red),
        player_id.from_int(4),
      ),
    ]),
  )
  |> verify(game_decider)
}
