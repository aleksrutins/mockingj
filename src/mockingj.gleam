import gleam/erlang/process
import gleam/erlang/os
import gleam/int
import gleam/io
import gleam/result.{flatten, lazy_unwrap, map}
import gleam/http/cowboy
import gleam/http/response.{Response}
import gleam/http/request.{Request}
import gleam/bit_builder.{BitBuilder}

// Define a HTTP service
//
pub fn my_service(_request: Request(t)) -> Response(BitBuilder) {
  let body = bit_builder.from_string("Hello, world!")

  response.new(200)
  |> response.prepend_header("made-with", "Gleam")
  |> response.set_body(body)
}

// Start it on port 3000!
//
pub fn main() {
  let port =
    lazy_unwrap(
      map(over: os.get_env("PORT"), with: int.base_parse(_, 10))
      |> flatten,
      fn() { 8080 },
    )

  io.debug(#("Listening on", port))

  let assert Ok(_) = cowboy.start(my_service, on_port: port)
  process.sleep_forever()
}
