import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import parallel_map.{MatchSchedulersOnline, WorkerAmount}

pub fn parse(input: String) -> List(String) {
  string.split(input, "\n\n")
}

pub fn pt_1(input: List(String)) {
  let assert [first, last] = input
  let parsed_first = pasre_first(first)
  let parsed_second = parse_second(last)

  let filtered =
    parsed_second
    |> list.filter(fn(row) {
      let row_filtered =
        row
        |> list.map(fn(cell) {
          let numbers =
            parsed_first
            |> find_page_requirements(cell)

          filter_test(row, cell, numbers)
        })
      io.debug(row_filtered)
      !list.contains(row_filtered, False)
    })

  find_middle_number(filtered)
  |> int.sum
}

pub fn pt_2(input: List(String)) -> Int {
  let assert [first, last] = input
  let parsed_first = pasre_first(first)
  let parsed_second = parse_second(last)

  let filtered =
    parsed_second
    |> list.filter(fn(row) {
      let row_filtered =
        row
        |> list.map(fn(cell) {
          let numbers =
            parsed_first
            |> find_page_requirements(cell)

          filter_test(row, cell, numbers)
        })
      list.contains(row_filtered, False)
    })

  io.debug("filtered")
  filtered
  |> io.debug
  |> list.map(fn(row) {
    row
    |> list.sort(int.compare)
    |> io.debug
    |> list.fold(row, fn(acc, cell) {
      let numbers =
        parsed_first
        |> find_page_requirements(cell)

      shift(acc, cell, numbers)
      //|> io.debug
    })
  })
  |> io.debug

  find_middle_number(filtered)
  |> int.sum
  //  let correct_list =
  //    filtered
  //    |> list.map(do_work(_, parsed_first))
  //    |> parallel_map.list_pmap(
  //      do_work(_, parsed_first),
  //      MatchSchedulersOnline,
  //      100,
  //    )
  //    |> io.debug
  //    |> list.filter(fn(es) {
  //      case es {
  //        Error(_) -> False
  //        Ok(_) -> True
  //      }
  //    })
  //    |> io.debug
  //    |> list.map(fn(es) {
  //      case es {
  //        Error(_) -> []
  //        Ok(e) -> e
  //      }
  //    })

  //find_middle_number(correct_list)
  //|> int.sum
}

pub fn pasre_first(input: String) -> List(#(Int, Int)) {
  input
  |> string.split("\n")
  |> list.map(fn(row) -> #(Int, Int) {
    let assert [first, last] =
      row
      |> string.split("|")
    let assert Ok(first_int) = int.parse(first)
    let assert Ok(last_int) = int.parse(last)
    #(first_int, last_int)
  })
}

pub fn parse_second(input: String) -> List(List(Int)) {
  input
  |> string.split("\n")
  |> list.map(fn(row) -> List(Int) {
    row
    |> string.split(",")
    |> list.map(fn(cell) -> Int {
      let assert Ok(num) = int.parse(cell)
      num
    })
  })
}

pub fn find_page_requirements(
  input_list: List(#(Int, Int)),
  search_number: Int,
) -> List(Int) {
  input_list
  |> list.filter(fn(value) { value.0 == search_number })
  |> list.map(fn(value) { value.1 })
}

pub fn filter_test(
  row: List(Int),
  cell: Int,
  not_allowed_before: List(Int),
) -> Bool {
  row
  |> list.take_while(fn(x: Int) -> Bool { x != cell })
  |> list.filter(fn(x: Int) -> Bool { not_allowed_before |> list.contains(x) })
  |> list.is_empty
}

pub fn find_middle_number(input: List(List(Int))) -> List(Int) {
  use row <- list.map(input)
  let row_length = list.length(row)
  let resu = row_length / 2
  let a = list.drop(row, resu)
  let assert Ok(first_elm) = list.first(a)
  first_elm
}

pub fn do_work(row: List(Int), parsed_first: List(#(Int, Int))) {
  let assert Ok(perms) =
    list.permutations(row)
    |> io.debug
    |> list.find(fn(permutated_row) {
      let row_filtered =
        permutated_row
        |> list.map(fn(cell) {
          let numbers =
            parsed_first
            |> find_page_requirements(cell)

          filter_test(permutated_row, cell, numbers)
        })
      !list.contains(row_filtered, False)
    })

  perms
}

pub fn swap_with_next(list: List(Int), cell: Int) -> List(Int) {
  let index =
    list.take_while(list, fn(value) { value != cell })
    |> list.length
  //  io.debug("aaaaa")
  let a =
    list.take(list, index)
    |> list.last
  //    |> io.debug
  let b =
    list.take(list, index + 1)
    |> list.last
  //    |> io.debug

  //  io.debug("bbbb")

  case a, b {
    Ok(e1), Ok(e2) -> {
      let prefix = list.take(list, int.clamp(index - 1, 0, index))
      let suffix = list.drop(list, index + 2)
      //        |> io.debug

      //io.debug("suffix")
      //io.debug(prefix)
      list.flatten([prefix, [e2, e1], suffix])
      //      |> io.debug
    }
    _, _ -> list
  }
}

pub fn shift(list: List(Int), cell: Int, not_allowed_before: List(Int)) {
  swap_with_next(list, cell)
  case filter_test(list, cell, not_allowed_before) {
    False -> {
      swap_with_next(list, cell) |> shift(cell, not_allowed_before)
    }
    True -> list
  }
}
