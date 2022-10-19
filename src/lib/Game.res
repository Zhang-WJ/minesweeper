type cell = {
  mutable mined: bool,
  mutable seen: bool,
  mutable flag: bool,
  mutable nbm: int,
}

type board = array<array<cell>>
