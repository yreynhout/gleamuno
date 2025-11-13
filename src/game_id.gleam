pub opaque type GameId {
  GameId(value: Int)
}

pub fn from_int(value: Int) {
  GameId(value)
}

pub fn to_int(game: GameId) {
  case game {
    GameId(value) -> value
  }
}
