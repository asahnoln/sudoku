package input

import "core:strconv"
import rl "vendor:raylib"

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

parse :: proc {
	parse_byte,
	parse_raylib,
}

parse_byte :: proc(c: byte) -> Cmd {
	switch c {
	case 'l':
		return Move{.Right}
	case 'h':
		return Move{.Left}
	case 'k':
		return Move{.Up}
	case 'j':
		return Move{.Down}
	case 'q', 27:
		return .Quit
	case '1' ..= '9':
		v, _ := strconv.digit_to_int(cast(rune)c)
		return Enter_Number{v}
	}

	return nil
}

parse_raylib :: proc(c: rl.KeyboardKey) -> Cmd {
	#partial switch c {
	case .L:
		return Move{.Right}
	case .H:
		return Move{.Left}
	case .K:
		return Move{.Up}
	case .J:
		return Move{.Down}
	case .Q, .ESCAPE:
		return .Quit
	case .ONE ..= .NINE:
		v, _ := strconv.digit_to_int(cast(rune)c)
		return Enter_Number{v}
	}

	return nil
}
