pub type Digit {
  Zero
  One
  Two
  Three
  Four
  Five
  Six
  Seven
  Eight
  Nine
}

pub type Color {
  Red
  Green
  Blue
  Yellow
}

pub type Card {
  Digit(value: Digit, color: Color)
  KickBack(color: Color)
  Skip(color: Color)
}

pub fn card_color(card: Card) {
  case card {
    Digit(_, color) -> {
      color
    }
    KickBack(color) -> {
      color
    }
    Skip(color) -> {
      color
    }
  }
}

pub fn are_same_color(left: Card, right: Card) {
  card_color(left) == card_color(right)
}

pub fn are_same_value(left: Card, right: Card) {
  case left, right {
    Digit(d1, _), Digit(d2, _) -> d1 == d2
    KickBack(_), KickBack(_) -> True
    Skip(_), Skip(_) -> True
    _, _ -> False
  }
}

pub type Direction {
  ClockWise
  CounterClockWise
}
