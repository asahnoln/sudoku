package input

MAX :: 9

Pos :: [2]int

Direction :: enum {
	Right,
	Left,
	Up,
	Down,
}


new_pos :: proc(p: Pos, d: Direction) -> (n: Pos) {
	dir := [Direction]Pos {
		.Right = {0, +1},
		.Left  = {0, -1},
		.Up    = {-1, 0},
		.Down  = {+1, 0},
	}

	n = p + dir[d]

	switch {
	case n.y == MAX:
		n.y = 0
	case n.x == MAX:
		n.x = 0
	case n.y == -1:
		n.y = MAX - 1
	case n.x == -1:
		n.x = MAX - 1
	}

	return n
}

parse_direction :: proc(c: byte) -> Direction {
	switch c {
	case 'l':
		return .Right
	case 'h':
		return .Left
	case 'k':
		return .Up
	case 'j':
		return .Down
	}

	return .Right
}
