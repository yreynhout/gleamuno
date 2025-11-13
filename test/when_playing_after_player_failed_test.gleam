import deck.{Digit, Green, Nine, Red, Seven, Three}
import game.{
  CardPlayed, GameStarted, PlayCard, PlayerPlayedAtWrongTurn,
  PlayerPlayedWrongCard, game,
}
import game_id
import player_count
import player_id
import prng/seed
import scenario.{Scenario, verify}

// Test 1: After playing wrong card, it should still be player's turn
pub fn after_wrong_card_still_players_turn_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "After wrong card it should still be player's turn",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Three, Red),
        player_id.from_int(2),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Nine, Red),
        player_id.from_int(3),
      ),
      PlayerPlayedWrongCard(game_id, player_id.from_int(3), Digit(Seven, Green)),
    ],
    when: PlayCard(game_id, player_id.from_int(3), Digit(Nine, Green)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(3),
        Digit(Nine, Green),
        player_id.from_int(4),
      ),
    ]),
  )
  |> verify(game_decider)
}

// Test 2: After playing at wrong turn, it should still be expected player's turn
pub fn after_wrong_turn_still_expected_players_turn_test() {
  let game_decider = game(seed.new(0))
  let game_id = game_id.from_int(1)
  let player_count = player_count.Four

  Scenario(
    name: "After wrong turn it should still be expected player's turn",
    given: [
      GameStarted(
        game_id,
        player_count,
        Digit(Three, Red),
        player_id.from_int(2),
      ),
      CardPlayed(
        game_id,
        player_id.from_int(2),
        Digit(Nine, Red),
        player_id.from_int(3),
      ),
      PlayerPlayedAtWrongTurn(
        game_id,
        player_id.from_int(1),
        Digit(Seven, Green),
      ),
    ],
    when: PlayCard(game_id, player_id.from_int(3), Digit(Nine, Green)),
    then: Ok([
      CardPlayed(
        game_id,
        player_id.from_int(3),
        Digit(Nine, Green),
        player_id.from_int(4),
      ),
    ]),
  )
  |> verify(game_decider)
}
