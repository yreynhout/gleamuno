import deck.{
  CounterClockWise, Digit, Eight, Green, KickBack, Nine, Red, Skip,
}
import game.{
  CardPlayed, DirectionChanged, GameStarted, PlayCard, PlayerPlayedAtWrongTurn,
  game,
}
import game_id
import player_count
import player_id
import prng/seed
import scenario.{Scenario, verify}

// Test 1: Skip card skips the next player
pub fn skip_skips_next_player_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Skip card skips the next player",
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
    when: PlayCard(game_id, player_id.from_int(3), Skip(Red)),
    then: Ok([
      CardPlayed(game_id, player_id.from_int(3), Skip(Red), player_id.from_int(1)),
    ]),
  )
  |> verify(game_decider)
}

// Test 2: The skipped player cannot play
pub fn skipped_player_cannot_play_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "The skipped player cannot play",
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
      CardPlayed(game_id, player_id.from_int(3), Skip(Red), player_id.from_int(1)),
    ],
    when: PlayCard(game_id, player_id.from_int(4), Digit(Eight, Red)),
    then: Ok([
      PlayerPlayedAtWrongTurn(
        game_id,
        player_id.from_int(4),
        Digit(Eight, Red),
      ),
    ]),
  )
  |> verify(game_decider)
}

// Test 3: The player after the skipped player can play
pub fn player_after_skip_can_play_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "The player after the skipped player can play",
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
      CardPlayed(game_id, player_id.from_int(3), Skip(Red), player_id.from_int(1)),
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

// Test 4: Skip works in counterclockwise direction
pub fn skip_works_counterclockwise_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "Skip works in counterclockwise direction",
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
        KickBack(Green),
        player_id.from_int(2),
      ),
      DirectionChanged(game_id, CounterClockWise),
    ],
    when: PlayCard(game_id, player_id.from_int(2), Skip(Green)),
    then: Ok([
      CardPlayed(game_id, player_id.from_int(2), Skip(Green), player_id.from_int(4)),
    ]),
  )
  |> verify(game_decider)
}
