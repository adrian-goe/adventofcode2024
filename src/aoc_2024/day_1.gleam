import gleam/int
import gleam/list
import gleam/string

pub fn parse(input: String) -> List(List(Int)) {
  string.split(input, on: "\n")
  |> list.map(fn(row) -> List(Int) {
    string.split(row, on: "   ")
    |> list.map(fn(value) -> Int {
      let assert Ok(i) = int.parse(value)
      i
    })
  })
}

pub fn pt_1(input: List(List(Int))) -> Int {
  let side_one: List(Int) =
    list.map(input, fn(row) -> Int {
      case row {
        [elm, ..] -> elm
        _ -> 0
      }
    })
    |> list.sort(fn(a, b) { int.compare(a, b) })
  let side_two =
    list.map(input, fn(row) -> Int {
      case row {
        [_, elm, ..] -> elm
        _ -> 0
      }
    })
    |> list.sort(fn(a, b) { int.compare(a, b) })

  list.map2(side_one, side_two, fn(a, b) -> Int { int.absolute_value(a - b) })
  |> int.sum
}

pub fn pt_2(input: List(List(Int))) -> Int {
  let side_one: List(Int) =
    list.map(input, fn(row) -> Int {
      case row {
        [elm, ..] -> elm
        _ -> 0
      }
    })
  let side_two =
    list.map(input, fn(row) -> Int {
      case row {
        [_, elm, ..] -> elm
        _ -> 0
      }
    })

  list.map(side_one, fn(row) -> Int {
    let count = list.count(side_two, fn(value) { value == row })
    row * count
  })
  |> int.sum
}
