import gleam/int
import gleam/list
import gleam/string

type HistorianList =
  #(List(Int), List(Int))

pub fn parse(input: String) -> HistorianList {
  get_historian_list(input)
}

pub fn pt_1(input: HistorianList) -> Int {
  let side_one: List(Int) = list.sort(input.0, fn(a, b) { int.compare(a, b) })
  let side_two: List(Int) = list.sort(input.1, fn(a, b) { int.compare(a, b) })

  list.map2(side_one, side_two, fn(a, b) -> Int { int.absolute_value(a - b) })
  |> int.sum
}

pub fn pt_2(input: HistorianList) -> Int {
  let #(side_one, side_two) = input

  list.map(side_one, fn(row) -> Int {
    let count = list.count(side_two, fn(value) { value == row })
    row * count
  })
  |> int.sum
}

pub fn get_historian_list(input: String) -> HistorianList {
  let #(list1, list2) = {
    use #(list1, list2), line <- list.fold(string.split(input, "\n"), #([], []))

    let assert [term1, term2] = string.split(line, "   ")
    let assert Ok(value1) = int.parse(term1)
    let assert Ok(value2) = int.parse(term2)
    let new_list1 = list.append(list1, [value1])
    let new_list2 = list.append(list2, [value2])
    #(new_list1, new_list2)
  }
  #(list1, list2)
}
