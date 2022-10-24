@react.component
let make = (~cell: Game.cell, ~onToggle) => {
  let url = switch (cell.seen, cell.flag, cell.isMine, cell.nbm) {
  | (false, _, _, _) => %raw("require('../sprites/normal.png')")
  | (true, true, _, _) => %raw("require('../sprites/flag.png')")
  | (true, false, true, _) => %raw("require('../sprites/bomb.png')")
  | (true, false, false, n) =>
    if n == 0 {
      %raw("require('../sprites/empty.png')")
    } else {
      %raw("require(`../sprites/${cell.nbm}.png`)")
    }
  }

  let handleMouseEvent = React.useCallback0((callback, e) => {
    if ReactEvent.Mouse.nativeEvent(e)["which"] === 1 {
      callback(false)
    }
  })

  let handleContextMenu = React.useCallback0((callback, e) => {
    if ReactEvent.Mouse.nativeEvent(e)["which"] === 3 {
      callback(true)
    }
  })

  <div
    className={`border-1 case-item border-black rounded-sm`}
    onClick={handleMouseEvent(onToggle)}
    onContextMenu={handleContextMenu(onToggle)}>
    <img src={url} />
  </div>
}
