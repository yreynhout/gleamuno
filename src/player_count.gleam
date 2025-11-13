import player_id.{type PlayerId}
import prng/random.{type Generator}

pub type PlayerCount {
  Two
  Three
  Four
  Five
  Six
  Seven
  Eight
  Nine
  Ten
}

pub fn random_player_generator(count: PlayerCount) -> Generator(PlayerId) {
  random.int(1, to_int(count))
  |> random.map(fn(id) { player_id.from_int(id) })
}

pub fn to_int(count: PlayerCount) {
  case count {
    Two -> 2
    Three -> 3
    Four -> 4
    Five -> 5
    Six -> 6
    Seven -> 7
    Eight -> 8
    Nine -> 9
    Ten -> 10
  }
}
