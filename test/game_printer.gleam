import deck.{
  type Card, type Color, type Digit, type Direction, Blue, ClockWise,
  CounterClockWise, Digit, Eight, Five, Four, Green, KickBack, Nine, One, Red,
  Seven, Six, Skip, Three, Two, Yellow, Zero,
}
import game.{
  type Command, type Error, type Event, type State, CardPlayed, DirectionChanged,
  GameAlreadyStarted, GameHasNotStarted, GameStarted, PlayCard,
  PlayerPlayedAtWrongTurn, PlayerPlayedWrongCard, StartGame,
}
import game_id
import gleam/int
import player_count
import player_id
import scenario.{type Scenario}
import scenario_printer

fn print_color(color: Color) {
  case color {
    Red -> "red"
    Green -> "green"
    Blue -> "blue"
    Yellow -> "yellow"
  }
}

fn print_digit(digit: Digit) {
  case digit {
    Zero -> "0"
    One -> "1"
    Two -> "2"
    Three -> "3"
    Four -> "4"
    Five -> "5"
    Six -> "6"
    Seven -> "7"
    Eight -> "8"
    Nine -> "9"
  }
}

fn print_direction(direction: Direction) {
  case direction {
    ClockWise -> "clock wise"
    CounterClockWise -> "counter clock wise"
  }
}

fn print_card(card: Card) {
  case card {
    Digit(digit, color) -> print_color(color) <> " " <> print_digit(digit)
    KickBack(color) -> print_color(color) <> " Kickback"
    Skip(color) -> print_color(color) <> " Skip"
  }
}

pub fn print_scenario(scenario: Scenario(Command, State, Event, Error)) {
  scenario_printer.print(
    scenario,
    fn(command) {
      case command {
        StartGame(game, player_count, first_card) -> {
          "Start game "
          <> game_id.to_int(game) |> int.to_string
          <> " with "
          <> player_count.to_int(player_count) |> int.to_string
          <> " players. Top card "
          <> print_card(first_card)
        }
        PlayCard(_, player, card) -> {
          "Player "
          <> player_id.to_int(player) |> int.to_string
          <> " plays "
          <> print_card(card)
        }
      }
    },
    fn(event) {
      case event {
        GameStarted(game, player_count, first_card, first_player) ->
          "Game "
          <> game_id.to_int(game) |> int.to_string
          <> " started with "
          <> player_count.to_int(player_count) |> int.to_string
          <> " players. Top Card is "
          <> print_card(first_card)
          <> ". Player "
          <> player_id.to_int(first_player) |> int.to_string
          <> " is up."
        CardPlayed(_, player, card, next_player) ->
          "Player "
          <> player_id.to_int(player) |> int.to_string
          <> " played "
          <> print_card(card)
          <> ". Player "
          <> player_id.to_int(next_player) |> int.to_string
          <> " is up."
        PlayerPlayedAtWrongTurn(_, player, card) ->
          "Player "
          <> player_id.to_int(player) |> int.to_string
          <> " played at the wrong turn. Attempted card was "
          <> print_card(card)
          <> "."
        PlayerPlayedWrongCard(_, player, card) ->
          "Player "
          <> player_id.to_int(player) |> int.to_string
          <> " tried to play "
          <> print_card(card)
          <> " but either the color or value where wrong."
        DirectionChanged(_, direction) ->
          "Game direction changed to " <> print_direction(direction)
      }
    },
    fn(error) {
      case error {
        GameAlreadyStarted -> "The game has already started"
        GameHasNotStarted -> "The game has not been started yet"
      }
    },
  )
}
