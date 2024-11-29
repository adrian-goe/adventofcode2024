import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import gleam/string

pub fn parse(input: String) -> List(String) {
  io.println(input)
  string.split(input, on: "\n")
}

pub fn pt_1(input: List(String)) -> Int {
  let result: Int =
    input
    |> list.map(strip_chars)
    |> list.map(fn(value) -> Int {
      let assert Ok(i) = int.parse(value)
      i
    })
    |> sum_list(0)

  result
}

pub fn strip_chars(input: String) -> String {
  let assert Ok(re) = regexp.from_string("[a-z]")

  let striped_string =
    regexp.replace(re, input, "")
    |> string.trim()
  let result_first_part = string.slice(striped_string, 0, 1)
  let result =
    string.append(result_first_part, string.slice(striped_string, -1, 1))

  result
}

pub fn sum_list(list: List(Int), total: Int) -> Int {
  case list {
    [] -> total
    [x, ..rest] -> sum_list(rest, x + total)
  }
}

pub fn pt_2(input: List(String)) -> Int {
  1
}
