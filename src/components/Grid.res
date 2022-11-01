module R = React
module A = Belt.Array

@react.component
let make = (~data: Game.board, ~onToggle) => {
  let renderTile = R.useCallback0((y, x, cellState: Game.cell) => {
    let key = j`$x-$y`

    <Case cell={cellState} key onToggle={isFlag => onToggle((y, x), isFlag)} />
  })

  let renderRow = R.useCallback0((y, row) =>
    <div className={`flex`} key={y->string_of_int}>
      {row->A.mapWithIndex(renderTile(y))->R.array}
    </div>
  )

  <div className={"flex flex-col mx-auto"}> {data->A.mapWithIndex(renderRow)->R.array} </div>
}
