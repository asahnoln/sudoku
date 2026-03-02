package input

MAX :: 9

Cmd :: union {
	SimpleCmd,
	Move,
}

SimpleCmd :: enum {
	Quit,
}

Move :: struct {
	dir: Direction,
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

parse :: proc(c: byte) -> Cmd {
	switch c {
	case 'l':
		return Move{.Right}
	case 'h':
		return Move{.Left}
	case 'k':
		return Move{.Up}
	case 'j':
		return Move{.Down}
	case 'q':
		return .Quit
	}

	return nil
}
