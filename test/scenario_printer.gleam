import gleam/io
import gleam/list
import scenario.{type Scenario}

pub fn print(
  scenario: Scenario(command, state, event, error),
  command_printer: fn(command) -> String,
  event_printer: fn(event) -> String,
  error_printer: fn(error) -> String,
) {
  io.println("Given")
  scenario.given
  |> list.each(fn(e) { io.println("  " <> event_printer(e)) })
  io.println("When")
  io.println("  " <> command_printer(scenario.when))
  io.println("Then")
  case scenario.then {
    Ok(thens) -> {
      thens
      |> list.each(fn(e) { io.println("  " <> event_printer(e)) })
    }
    Error(err) -> {
      io.println("  " <> error_printer(err))
    }
  }
}
