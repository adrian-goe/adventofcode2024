import birl
import birl/duration
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import parallel_map.{MatchSchedulersOnline}

type Grid =
  dict.Dict(Int, dict.Dict(Int, String))

type Directions =
  dict.Dict(Int, #(Int, Int))

pub fn parse(input: String) -> Grid {
  generate_grid(input)
}

pub fn pt_1(input: Grid) {
  let start_time = birl.now()

  let directions: Directions =
    dict.new()
    |> dict.insert(0, #(-1, 0))
    |> dict.insert(1, #(0, 1))
    |> dict.insert(2, #(1, 0))
    |> dict.insert(3, #(0, -1))

  let starting_point = get_starting_point(input)

  let result = travers(input, starting_point, 0, directions)
  birl.now()
  |> birl.difference(start_time)
  |> duration.blur_to(duration.MilliSecond)
  |> io.debug
  result
}

pub fn pt_2(input: Grid) {
  let start_time = birl.now()
  let directions: Directions =
    dict.new()
    |> dict.insert(0, #(-1, 0))
    |> dict.insert(1, #(0, 1))
    |> dict.insert(2, #(1, 0))
    |> dict.insert(3, #(0, -1))

  let starting_point = get_starting_point(input)
  let result =
    generate_grid_with_loop(input)
    |> parallel_map.list_pmap(
      fn(value) { travers_with_loop(value, starting_point, 0, directions, 0) },
      MatchSchedulersOnline,
      100,
    )
    |> list.count(fn(cell) {
      let res = case cell {
        Ok(True) -> True
        _ -> False
      }
      res
    })
    |> io.debug

  birl.now()
  |> birl.difference(start_time)
  |> duration.blur_to(duration.MilliSecond)
  |> io.debug
  result
}

pub fn generate_grid(input: String) -> Grid {
  input
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
}

pub fn get_starting_point(input: Grid) -> #(Int, Int) {
  let assert Ok(res) =
    input
    |> dict.to_list
    |> list.map(fn(row) {
      let result =
        row.1 |> dict.to_list |> list.find(fn(cell) { cell.1 == "^" })
      case result {
        Error(_) -> #(row.0, -1)
        Ok(cell) -> #(row.0, cell.0)
      }
    })
    |> list.find(fn(cell) { cell.1 != -1 })

  res
}

pub fn get_next_point(grid: Grid, pos: #(Int, Int)) -> String {
  case dict.get(grid, pos.0) {
    Error(_) -> "G"
    Ok(row) ->
      case dict.get(row, pos.1) {
        Error(_) -> "G"
        Ok(value) -> value
      }
  }
}

pub fn travers(
  input: Grid,
  current_point: #(Int, Int),
  direction: Int,
  directions: Directions,
) {
  let assert Ok(dir) = dict.get(directions, direction % 4)

  let lookup = #(current_point.0 + dir.0, current_point.1 + dir.1)
  case get_next_point(input, lookup) {
    "G" -> {
      let assert Ok(row) = dict.get(input, current_point.0)
      let new_row = row |> dict.insert(current_point.1, "X")
      let new_grid = input |> dict.insert(current_point.0, new_row)

      dict.values(new_grid)
      |> list.map(fn(row) {
        row |> dict.values |> list.count(fn(cell) { cell == "X" })
      })
      |> int.sum
    }
    "#" -> {
      travers(input, current_point, direction + 1, directions)
    }
    _ -> {
      let assert Ok(row) = dict.get(input, current_point.0)
      let new_row = row |> dict.insert(current_point.1, "X")
      let new_grid = input |> dict.insert(current_point.0, new_row)
      travers(new_grid, lookup, direction, directions)
    }
  }
}

pub fn travers_with_loop(
  input: Grid,
  current_point: #(Int, Int),
  direction: Int,
  directions: Directions,
  current_steps: Int,
) {
  let assert Ok(dir) = dict.get(directions, direction % 4)

  case current_steps == 10_000 {
    True -> True
    False -> {
      let lookup = #(current_point.0 + dir.0, current_point.1 + dir.1)
      case get_next_point(input, lookup) {
        "G" -> False
        "#" | "0" -> {
          travers_with_loop(
            input,
            current_point,
            direction + 1,
            directions,
            current_steps + 1,
          )
        }
        _ -> {
          let assert Ok(row) = dict.get(input, current_point.0)
          let new_row = row |> dict.insert(current_point.1, "X")
          let new_grid = input |> dict.insert(current_point.0, new_row)
          travers_with_loop(
            new_grid,
            lookup,
            direction,
            directions,
            current_steps + 1,
          )
        }
      }
    }
  }
}

pub fn generate_grid_with_loop(input: Grid) -> List(Grid) {
  let height = dict.to_list(input) |> list.length
  let assert Ok(row) = dict.get(input, 0)
  let width = dict.to_list(row) |> list.length
  list.range(0, height - 1)
  |> list.index_map(fn(_, current_row) {
    list.range(0, width - 1)
    |> list.index_map(fn(_, currnet_col) {
      let assert Ok(row) = dict.get(input, current_row)
      let assert Ok(cell) = dict.get(row, currnet_col)
      let new_cell = case cell {
        "X" -> "X"
        "^" -> "^"
        _ -> "0"
      }
      let new_row = row |> dict.insert(currnet_col, new_cell)
      input |> dict.insert(current_row, new_row)
    })
  })
  |> list.flatten
}
