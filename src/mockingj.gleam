import mist
import gleam/erlang/process
import gleam/erlang/os
import gleam/int
import gleam/io
import gleam/result.{flatten, lazy_unwrap, map}
import gleam/bit_builder
import gleam/http/response.{Response}

pub fn main() {
  let port =
    lazy_unwrap(
      map(over: os.get_env("PORT"), with: int.base_parse(_, 10))
      |> flatten,
      fn() { 8080 },
    )

  io.debug(#("Listening on", port))

  assert Ok(_) = mist.run_service(port, web_service, 5_000_000)
  process.sleep_forever()
}

fn web_service(_request) {
  let body = bit_builder.from_string("Hello, Joe!")
  Response(200, [], body)
}
