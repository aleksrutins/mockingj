import gleam/bit_builder
import gleam/erlang/process
import gleam/http/response
import gleam/erlang/os
import gleam/int
import gleam/io
import gleam/result.{flatten, lazy_unwrap, map}
import mist

pub fn main() {
  let port =
    lazy_unwrap(
      map(over: os.get_env("PORT"), with: int.base_parse(_, 10))
      |> flatten,
      fn() { 8080 },
    )

  io.debug(#("Listening on", port))

  let assert Ok(_) =
    mist.run_service(
      port,
      fn(_req) {
        response.new(200)
        |> response.set_body(bit_builder.from_string("hello, world!"))
      },
      max_body_limit: 4_000_000,
    )
  process.sleep_forever()
}
