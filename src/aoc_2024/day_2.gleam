import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn parse(input: String) -> List(List(Int)) {
  get_rows(input)
}

pub fn pt_1(input: List(List(Int))) -> Int {
  input
  |> list.map(fn(row) -> Int {
    let result =
      list.window_by_2(row)
      |> list.map(fn(a) -> Int {
        let num = a.1 - a.0
        case num {
          -1 -> -1
          -2 -> -1
          -3 -> -1
          1 -> 1
          2 -> 1
          3 -> 1
          _ -> 0
        }
      })
      |> int.sum
    let abs_result = int.absolute_value(result)
    let length = list.length(row) - 1

    case abs_result == length {
      True -> 1
      _ -> 0
    }
  })
  |> int.sum
}

pub fn pt_2(input: List(List(Int))) {
  todo as "part 2 not implemented"
}

pub fn get_rows(input: String) -> List(List(Int)) {
  use row <- list.map(string.split(input, "\n"))
  list.map(string.split(row, " "), fn(value) {
    let assert Ok(int) = int.parse(value)
    int
  })
}
