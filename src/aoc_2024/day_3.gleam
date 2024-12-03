import gleam/int
import gleam/list
import gleam/regexp
import gleam/string

pub fn parse(input: String) -> String {
  string.replace(input, "\n", "")
}

pub fn pt_1(input: String) -> Int {
  let assert Ok(re) = regexp.from_string("mul\\([0-9]{1,3}\\,[0-9]{1,3}\\)")
  regexp.scan(with: re, content: input)
  |> list.map(do_multiplication_from_match)
  |> int.sum
}

pub fn pt_2(input: String) -> Int {
  let assert Ok(replace) = regexp.from_string("don't\\(\\)(.*?)(?=do\\(\\)|$)")
  let assert Ok(re) = regexp.from_string("mul\\([0-9]{1,3}\\,[0-9]{1,3}\\)")
  let filtered_input = regexp.replace(each: replace, in: input, with: "")

  regexp.scan(with: re, content: filtered_input)
  |> list.map(do_multiplication_from_match)
  |> int.sum
}

pub fn do_multiplication_from_match(input: regexp.Match) -> Int {
  do_multiplication(input.content)
}

pub fn do_multiplication(input: String) -> Int {
  let assert Ok(re) = regexp.from_string("[0-9]{1,3}")
  let numbers_match =
    regexp.scan(with: re, content: input)
    |> list.map(fn(match: regexp.Match) -> Int {
      let assert Ok(number) = int.parse(match.content)
      number
    })
  let assert Ok(first) = list.first(numbers_match)
  let assert Ok(last) = list.last(numbers_match)

  int.multiply(first, last)
}
