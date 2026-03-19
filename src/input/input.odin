package input

import "src:types"

MIN :: 0
MAX :: 9

Cmd :: union {
	SimpleCmd,
	Move,
	Enter_Number,
}

SimpleCmd :: enum {
	Quit,
}

Move :: struct {
	dir: Direction,
}

Enter_Number :: struct {
	v: int,
}

Direction :: enum {
	Right,
	Left,
	Up,
	Down,
}

new_pos :: proc(p: types.Pos, d: Direction) -> (n: types.Pos) {
	dir := [Direction]types.Pos {
		.Down  = {0, +1},
		.Up    = {0, -1},
		.Left  = {-1, 0},
		.Right = {+1, 0},
	}

	n = p + dir[d]

	n.x = wrap(n.x, MIN, MAX)
	n.y = wrap(n.y, MIN, MAX)

	return n
}

wrap :: proc(x, min, max: int) -> int {
	return min + ((x - min) %% (max - min))
}
