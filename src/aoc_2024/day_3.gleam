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
  |> list.map(do_multiplication)
  |> int.sum
}

pub fn pt_2(input: String) -> Int {
  let assert Ok(replace) = regexp.from_string("don't\\(\\)(.*?)(?=do\\(\\)|$)")
  let assert Ok(re) = regexp.from_string("mul\\([0-9]{1,3}\\,[0-9]{1,3}\\)")
  let filtered_input = regexp.replace(each: replace, in: input, with: "")

  regexp.scan(with: re, content: filtered_input)
  |> list.map(do_multiplication)
  |> int.sum
}

pub fn do_multiplication(input: regexp.Match) -> Int {
  let assert Ok(re) = regexp.from_string("[0-9]{1,3}")
  let assert [first, last] =
    regexp.scan(with: re, content: input.content)
    |> list.map(fn(match: regexp.Match) -> Int {
      let assert Ok(number) = int.parse(match.content)
      number
    })

  int.multiply(first, last)
}
