open Config

type point = (int, int)

type cell = {
  id: point,
  mutable mined: bool,
  mutable seen: bool,
  mutable flag: bool,
  mutable nbm: int,
  mutable isMine: bool,
}

type board = array<array<cell>>

module A = Belt.Array
module S = Belt.HashSet.Int
module L = Belt.List

module IntCmp = Belt.Id.MakeComparable({
  type t = int
  let cmp = Pervasives.compare
})

let safeIndex = x =>
  switch x {
  | (i, j) if i >= 0 && i < nbcols && j >= 0 && j < nbrows => true
  | _ => false
  }

let iterGrid = (f, board) => {
  A.forEachWithIndex(board, (i, row) =>
    row->A.forEachWithIndex((j, case) => f((i, j), case, board))
  )
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
  let borad = makeBlankGrid(width', height')
  let random_mines =
    random_list_mines(nbcols * nbrows, nbmins)->A.map(num => (num / nbrows, mod(num, nbrows)))

  random_mines->A.forEach(((i', j')) => {
    borad[i'][j'].isMine = true
  })

  borad |> iterGrid(((i, j), _, _) => borad[i][j].nbm = getNearMines(borad, (i, j)))
  borad
}

let rec toggleTile = (board: board, (i', j')) => {
  if board[i'][j'].nbm == 0 && !board[i'][j'].seen {
    board[i'][j'].seen = true
    let mines = getNeighbours(board, (i', j'))
    L.forEach(mines, point => toggleTile(board, point.id))
  } else {
    board[i'][j'].seen = true
  }
  board
}
