import gleam/io
import gleam/int

pub fn parse(input: String) -> Int {
  let assert Ok(i) = int.parse(input)
  i
}

pub fn pt_1(input: Int) -> Int {
  input + 1
}

pub fn pt_2(input: Int) -> Int {

  let result = input+2
  result
  |> int.to_string
  |> io.println
  result
}