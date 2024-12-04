import gleam/dict
import gleam/int
import gleam/list
import gleam/string

type Grid =
  dict.Dict(Int, dict.Dict(Int, String))

pub fn parse(input: String) -> Grid {
  generate_grid(input)
}

pub fn pt_1(input: Grid) -> Int {
  input
  |> dict.map_values(fn(row_index, row) {
    row
    |> dict.map_values(fn(col_index, cell) {
      case cell == "X" {
        True -> {
          [
            check_north(input, row_index, col_index, ["M", "A", "S"]),
            check_north_east(input, row_index, col_index, ["M", "A", "S"]),
            check_east(input, row_index, col_index, ["M", "A", "S"]),
            check_south_east(input, row_index, col_index, ["M", "A", "S"]),
            check_south(input, row_index, col_index, ["M", "A", "S"]),
            check_south_west(input, row_index, col_index, ["M", "A", "S"]),
            check_west(input, row_index, col_index, ["M", "A", "S"]),
            check_north_west(input, row_index, col_index, ["M", "A", "S"]),
          ]
          |> int.sum
        }
        False -> 0
      }
    })
    |> dict.to_list
    |> list.map(fn(cell) { cell.1 })
    |> int.sum
  })
  |> dict.to_list
  |> list.map(fn(cell) { cell.1 })
  |> int.sum
}

pub fn pt_2(input: Grid) {
  input
  |> dict.map_values(fn(row_index, row) {
    row
    |> dict.map_values(fn(col_index, cell) {
      case cell == "A" {
        True -> {
          [
            check_north_east(input, row_index, col_index, ["M"])
              + check_south_west(input, row_index, col_index, ["S"])
              + check_north_west(input, row_index, col_index, ["M"])
              + check_south_east(input, row_index, col_index, ["S"]),
            check_north_east(input, row_index, col_index, ["S"])
              + check_south_west(input, row_index, col_index, ["M"])
              + check_north_west(input, row_index, col_index, ["S"])
              + check_south_east(input, row_index, col_index, ["M"]),
            check_north_east(input, row_index, col_index, ["M"])
              + check_south_west(input, row_index, col_index, ["S"])
              + check_north_west(input, row_index, col_index, ["S"])
              + check_south_east(input, row_index, col_index, ["M"]),
            check_north_east(input, row_index, col_index, ["S"])
              + check_south_west(input, row_index, col_index, ["M"])
              + check_north_west(input, row_index, col_index, ["M"])
              + check_south_east(input, row_index, col_index, ["S"]),
          ]
          |> list.map(fn(cell) {
            case cell == 4 {
              True -> 1
              False -> 0
            }
          })
          |> int.sum
        }
        False -> 0
      }
    })
    |> dict.to_list
    |> list.map(fn(cell) { cell.1 })
    |> int.sum
  })
  |> dict.to_list
  |> list.map(fn(cell) { cell.1 })
  |> int.sum
}

pub fn generate_grid(input: String) -> Grid {
  pad_input(input)
  |> string.split("\n")
  |> list.index_map(fn(row, indexrow) {
    let row_dict =
      row
      |> string.split("")
      |> list.index_map(fn(cell, indexcol) -> #(Int, String) {
        #(indexcol, cell)
      })
      |> dict.from_list

    #(indexrow, row_dict)
  })
  |> dict.from_list
  //|> io.debug
}

pub fn get_line_size(input: String) -> Int {
  let assert Ok(first_line) =
    input
    |> string.split("\n")
    |> list.first

  string.length(first_line)
}

pub fn pad_input(input: String) -> String {
  let line_size = get_line_size(input)
  let line_pad =
    list.repeat(".", line_size)
    |> string.concat

  string.concat([
    line_pad,
    "\n",
    line_pad,
    "\n",
    line_pad,
    "\n",
    input,
    line_pad,
    "\n",
    line_pad,
    "\n",
    line_pad,
    "\n",
  ])
  |> string.split("\n")
  |> list.map(fn(row) -> String { string.concat(["...", row, "...", "\n"]) })
  |> string.concat
}

pub fn check_west(
  input: Grid,
  row_index: Int,
  col_index: Int,
  chars: List(String),
) -> Int {
  let assert Ok(row) = dict.get(input, row_index)
  let assert Ok(cell) = dict.get(row, col_index - 1)
  let assert Ok(char) = list.first(chars)
  let remainingchars = list.drop(chars, 1)

  case char == cell {
    True ->
      case remainingchars {
        [] -> 1
        _ -> check_west(input, row_index, col_index - 1, remainingchars)
      }
    False -> 0
  }
}

pub fn check_east(
  input: Grid,
  row_index: Int,
  col_index: Int,
  chars: List(String),
) -> Int {
  let assert Ok(row) = dict.get(input, row_index)
  let assert Ok(cell) = dict.get(row, col_index + 1)
  let assert Ok(char) = list.first(chars)
  let remainingchars = list.drop(chars, 1)

  case char == cell {
    True ->
      case remainingchars {
        [] -> 1
        _ -> check_east(input, row_index, col_index + 1, remainingchars)
      }
    False -> 0
  }
}

pub fn check_north(
  input: Grid,
  row_index: Int,
  col_index: Int,
  chars: List(String),
) -> Int {
  let assert Ok(row) = dict.get(input, row_index - 1)
  let assert Ok(cell) = dict.get(row, col_index)
  let assert Ok(char) = list.first(chars)
  let remainingchars = list.drop(chars, 1)

  case char == cell {
    True ->
      case remainingchars {
        [] -> 1
        _ -> check_north(input, row_index - 1, col_index, remainingchars)
      }
    False -> 0
  }
}

pub fn check_south(
  input: Grid,
  row_index: Int,
  col_index: Int,
  chars: List(String),
) -> Int {
  let assert Ok(row) = dict.get(input, row_index + 1)
  let assert Ok(cell) = dict.get(row, col_index)
  let assert Ok(char) = list.first(chars)
  let remainingchars = list.drop(chars, 1)

  case char == cell {
    True ->
      case remainingchars {
        [] -> 1
        _ -> check_south(input, row_index + 1, col_index, remainingchars)
      }
    False -> 0
  }
}

pub fn check_north_west(
  input: Grid,
  row_index: Int,
  col_index: Int,
  chars: List(String),
) -> Int {
  let assert Ok(row) = dict.get(input, row_index - 1)
  let assert Ok(cell) = dict.get(row, col_index - 1)
  let assert Ok(char) = list.first(chars)
  let remainingchars = list.drop(chars, 1)

  case char == cell {
    True ->
      case remainingchars {
        [] -> 1
        _ ->
          check_north_west(input, row_index - 1, col_index - 1, remainingchars)
      }
    False -> 0
  }
}

pub fn check_north_east(
  input: Grid,
  row_index: Int,
  col_index: Int,
  chars: List(String),
) -> Int {
  let assert Ok(row) = dict.get(input, row_index - 1)
  let assert Ok(cell) = dict.get(row, col_index + 1)
  let assert Ok(char) = list.first(chars)
  let remainingchars = list.drop(chars, 1)

  case char == cell {
    True ->
      case remainingchars {
        [] -> 1
        _ ->
          check_north_east(input, row_index - 1, col_index + 1, remainingchars)
      }
    False -> 0
  }
}

pub fn check_south_east(
  input: Grid,
  row_index: Int,
  col_index: Int,
  chars: List(String),
) -> Int {
  let assert Ok(row) = dict.get(input, row_index + 1)
  let assert Ok(cell) = dict.get(row, col_index + 1)
  let assert Ok(char) = list.first(chars)
  let remainingchars = list.drop(chars, 1)

  case char == cell {
    True ->
      case remainingchars {
        [] -> 1
        _ ->
          check_south_east(input, row_index + 1, col_index + 1, remainingchars)
      }
    False -> 0
  }
}

pub fn check_south_west(
  input: Grid,
  row_index: Int,
  col_index: Int,
  chars: List(String),
) -> Int {
  let assert Ok(row) = dict.get(input, row_index + 1)
  let assert Ok(cell) = dict.get(row, col_index - 1)
  let assert Ok(char) = list.first(chars)
  let remainingchars = list.drop(chars, 1)

  case char == cell {
    True ->
      case remainingchars {
        [] -> 1
        _ ->
          check_south_west(input, row_index + 1, col_index - 1, remainingchars)
      }
    False -> 0
  }
}
