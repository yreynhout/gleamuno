import decider.{type Decider}
import gleam/list

pub type Scenario(command, state, event, error) {
  Scenario(
    name: String,
    given: List(event),
    when: command,
    then: Result(List(event), error),
  )
}

pub fn verify(
  scenario: Scenario(command, state, event, error),
  decider: Decider(command, state, event, error),
) -> Nil {
  let initial_state =
    list.fold(scenario.given, decider.initial_state, decider.evolve)
  let result = decider.decide(scenario.when, initial_state)
  assert result == scenario.then
}
