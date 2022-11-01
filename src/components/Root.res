@react.component
let make = (~children) => {
  <div className="container mx-auto">
    <div className="text-2xl leading-6	py-10 text-gray-600 text-center">
      <span className="animate-bounce inline-flex"> {React.string("Mineswepper")} </span>
    </div>
    {children}
  </div>
}
