pub type Decider(command, state, event, error) {
  Decider(
    decide: fn(command, state) -> Result(List(event), error),
    evolve: fn(state, event) -> state,
    initial_state: state,
  )
}
