package input

import "core:math"
import "core:strconv"
import rl "vendor:raylib"

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

Pos :: [2]int

Direction :: enum {
	Right,
	Left,
	Up,
	Down,
}


new_pos :: proc(p: Pos, d: Direction) -> (n: Pos) {
	dir := [Direction]Pos {
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
