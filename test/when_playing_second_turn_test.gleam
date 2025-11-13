import deck.{Digit, Eight, Nine, Red, Yellow}
import game.{
  CardPlayed, GameStarted, PlayCard, PlayerPlayedAtWrongTurn,
  PlayerPlayedWrongCard, game,
}
import game_id
import player_count
import player_id
import prng/seed
import scenario.{Scenario, verify}

// Test 1: Playing a card with same color is accepted
pub fn playing_same_color_is_accepted_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Playing a card with same color is accepted",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Nine, Red),
        player_id.from_int(2),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Nine, Red),
        player_id.from_int(3),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(3), Digit(Eight, Red)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(3),
        Digit(Eight, Red),
        player_id.from_int(4),
      ),
    ]),
  )
  |> verify(game_decider)
}

// Test 2: Playing a card with same value is accepted
pub fn playing_same_value_is_accepted_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Playing a card with same value is accepted",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Nine, Red),
        player_id.from_int(2),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Nine, Red),
        player_id.from_int(3),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(3), Digit(Nine, Yellow)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(3),
        Digit(Nine, Yellow),
        player_id.from_int(4),
      ),
    ]),
  )
  |> verify(game_decider)
}

// Test 3: Playing a card with different color and value is rejected
pub fn playing_wrong_card_is_rejected_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Playing a card with different color and value is rejected",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Nine, Red),
        player_id.from_int(2),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Nine, Red),
        player_id.from_int(3),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(3), Digit(Eight, Yellow)),
    then: Ok([
      PlayerPlayedWrongCard(
        game_id,
        player_id.from_int(3),
        Digit(Eight, Yellow),
      ),
    ]),
  )
  |> verify(game_decider)
}

// Test 4: Playing at wrong turn is rejected
pub fn playing_at_wrong_turn_is_rejected_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Playing at wrong turn is rejected",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Nine, Red),
        player_id.from_int(2),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Nine, Red),
        player_id.from_int(3),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(4), Digit(Eight, Red)),
    then: Ok([
      PlayerPlayedAtWrongTurn(game_id, player_id.from_int(4), Digit(Eight, Red)),
    ]),
  )
  |> verify(game_decider)
}

// Test 5: After a full round, turn returns to first player
pub fn after_full_round_turn_returns_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "After a full round, turn returns to first player",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Nine, Red),
        player_id.from_int(2),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Nine, Red),
        player_id.from_int(3),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(3),
        Digit(Nine, Yellow),
        player_id.from_int(4),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(4),
        Digit(Eight, Yellow),
        player_id.from_int(1),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(1), Digit(Eight, Red)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(1),
        Digit(Eight, Red),
        player_id.from_int(2),
      ),
    ]),
  )
  |> verify(game_decider)
}
