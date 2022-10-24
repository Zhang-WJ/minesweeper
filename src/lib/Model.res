open Config

type state = {
  board: Game.board,
  isWin: bool,
}

type mode =
  | Flag
  | Boom

type action =
  | Reset
  | Toggle(Game.point, bool)

let initialState = {board: Game.makeRandomGrid(nbrows, nbcols), isWin: false}

module Reducers = {
  // Module contents
  let board = (self, action, _state) =>
    switch action {
    | Toggle(pos, isflag) => self->Game.toggleTile(pos, ~isFlag=isflag)
    | Reset => Game.makeRandomGrid(nbrows, nbcols)
    }

  let root = (state, action) => {
    board: board(state.board, action, state),
    isWin: false,
  }
}
