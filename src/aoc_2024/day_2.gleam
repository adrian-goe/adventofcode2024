import gleam/int
import gleam/list
import gleam/string

pub fn parse(input: String) -> List(List(Int)) {
  get_rows(input)
}

pub fn pt_1(input: List(List(Int))) -> Int {
  input
  |> list.map(check_row)
  |> int.sum
}

pub fn pt_2(input: List(List(Int))) {
  input
  |> list.map(fn(row) -> Bool {
    list.combinations(row, list.length(row) - 1)
    |> list.map(check_row)
    |> list.any(fn(x) { x == 1 })
  })
  |> list.count(fn(value) { value == True })
}

pub fn get_rows(input: String) -> List(List(Int)) {
  use row <- list.map(string.split(input, "\n"))
  list.map(string.split(row, " "), fn(value) {
    let assert Ok(int) = int.parse(value)
    int
  })
}

pub fn check_pair(numbers: #(Int, Int)) -> Int {
  let calculation_result = numbers.1 - numbers.0
  case calculation_result {
    -1 | -2 | -3 -> -1
    1 | 2 | 3 -> 1
    _ -> 0
  }
}

pub fn check_row(row_input: List(Int)) -> Int {
  let abs_result =
    list.window_by_2(row_input)
    |> list.map(check_pair)
    |> int.sum
    |> int.absolute_value

  case abs_result == list.length(row_input) - 1 {
    True -> 1
    _ -> 0
  }
}
