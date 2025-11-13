pub type PlayerId {
  PlayerId(value: Int)
}

pub fn from_int(value: Int) {
  PlayerId(value)
}

pub fn to_int(player: PlayerId) {
  case player {
    PlayerId(value) -> value
  }
}
