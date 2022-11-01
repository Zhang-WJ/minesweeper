module R = React

@react.component
let make = (~reset) => {
  <div className="text-center cursor-pointer" onClick={_ => reset()}> {R.string("Reset")} </div>
}
