open Config

type point = (int, int)

type cell = {
  id: point,
  mined: bool,
  seen: bool,
  flag: bool,
  nbm: int,
  isMine: bool,
}

type board = array<array<cell>>

module A = Belt.Array
module S = Belt.HashSet.Int
module L = Belt.List

module PointCmp = Belt.Id.MakeComparable({
  type t = (int, int)
  let cmp = Pervasives.compare
})

let safeIndex = x =>
  switch x {
  | (i, j) if i >= 0 && i < nbcols && j >= 0 && j < nbrows => true
  | _ => false
  }

let mapGrid = (f, board) => {
  A.mapWithIndex(board, (i, row) => row->A.mapWithIndex((j, case) => f((i, j), case, board)))
}

let makeBlankGrid = (width': int, height': int): board => {
  A.makeBy(width', i =>
    A.makeBy(height', j => {
      mined: false,
      seen: false,
      flag: false,
      nbm: 0,
      isMine: false,
      id: (i, j),
    })
  )
}

let generate_seed = () => {
  let t = Js.Date.now()
  let n = Belt.Int.fromFloat(t *. 10000.)
  Random.init(mod(n, 100000))
}

let random_list_mines = (lc, m) => {
  let cell_list = S.make(~hintSize=m)

  while S.size(cell_list) < m {
    cell_list->S.add(Random.int(lc))
  }

  cell_list->S.toArray
}

let offset = list{-1, 0, 1}

let getNeighbours = (board, (i, j): point) => {
  offset
  ->L.map(i' => offset->L.map(j' => (i + i', j + j')))
  ->L.flatten
  ->L.keep(p => p != (i, j) && p->safeIndex)
  ->L.map(((x, y)) => board[x][y])
}

let getNearMines = (board, (i, j)) => {
  board->getNeighbours((i, j))->L.keep(({isMine}) => isMine)->L.size
}

let makeRandomGrid = (width': int, height': int): board => {
  generate_seed()
  let random_mines =
    random_list_mines(nbcols * nbrows, nbmins)->A.map(num => (num / nbrows, mod(num, nbrows)))

  makeBlankGrid(width', height')
  |> mapGrid(((x, y), case, _) => {
    {...case, isMine: random_mines->A.some(((x', y')) => x == x' && y == y')}
  })
  |> mapGrid(((i, j), case', board) => {...case', nbm: getNearMines(board, (i, j))})
}

let toggleAll = board => {
  board |> mapGrid((_, case, _) => {...case, seen: true})
}

// TODO need optimize here
let rec getUnMinePoints = (board, point, acc) => {
  let neighbours =
    getNeighbours(board, point.id)->L.keep(point =>
      L.every(acc, pos => pos != point.id && !point.isMine)
    )

  let a = point.nbm > 0 ? acc : L.concat(acc, neighbours->L.map(point => point.id))

  switch neighbours->L.size > 0 && point.nbm == 0 {
  | true => neighbours->L.map(point => getUnMinePoints(board, point, a))->L.flatten
  | false => a
  }
}

let toggleTile = (board: board, ~isFlag=false, cell) => {
  switch (cell.seen, cell.isMine, isFlag) {
  | (true, _, _) => board
  | (false, true, false) => board |> toggleAll
  | (false, false, false) =>
    let needShow =
      getUnMinePoints(board, cell, list{cell.id})
      ->L.toArray
      ->Belt.Set.fromArray(~id=module(PointCmp))
      ->Belt.Set.toList
    board |> mapGrid((_, case, _) => {
      switch needShow->L.some(point => case.id == point) {
      | true => {...case, seen: true}
      | false => case
      }
    })
  | (false, false, true) | (false, true, true) =>
    board |> mapGrid((_, case, _) =>
      switch case.id == cell.id {
      | true => {...case, seen: true, flag: true}
      | false => case
      }
    )
  }
}
