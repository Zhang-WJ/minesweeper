open Model
module R = React
@react.component
let make = () => {
  let (state, dispatch) = R.useReducer(Reducers.root, initialState)
  let handleToggleTile = R.useCallback0(((y, x), isflag) => dispatch(Toggle((y, x), isflag)))
  <div className={"container mx-auto app mt-10"}>
    <Grid data={state.board} onToggle=handleToggleTile />
  </div>
}
