@react.component
let make = (~cell: Game.cell, ~onToggle) => {
  let url = if !cell.seen {
    %raw("require('../sprites/empty.png')")
  } else if cell.isMine {
    %raw("require('../sprites/bomb.png')")
  } else if cell.nbm == 0 {
    %raw("require('../sprites/empty.png')")
  } else {
    %raw("require(`../sprites/${cell.nbm}.png`)")
  }

  let handleMouseEvent = React.useCallback0((callback, e) =>
    if ReactEvent.Mouse.nativeEvent(e)["which"] === 1 {
      callback()
    }
  )

  <div
    className={`border-1 case-item border-black rounded-sm`} onClick={handleMouseEvent(onToggle)}>
    <img src={url} />
  </div>
}
