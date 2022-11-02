open Model
module R = React
@react.component
let make = () => {
  let (state, dispatch) = R.useReducer(Reducers.root, initialState)
  let handleToggleTile = R.useCallback0((cell, isflag) => dispatch(Toggle(cell, isflag)))
  let handleReset = R.useCallback0(() => dispatch(Reset))

  <div>
    <ResetButton reset=handleReset />
    <div className={"container mx-auto app mt-10 flex"}>
      <Grid data={state.board} onToggle=handleToggleTile />
    </div>
  </div>
}
