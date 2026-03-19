package ui

import "src:game"
import "src:types"
import rl "vendor:raylib"

Cell :: struct {
	x, y: int,
	v:    int,
	s:    bool,
}

convert_field_to_cells :: proc(
	f: game.Field,
	m: game.Field_Mask,
	p: types.Pos,
	allocator := context.allocator,
) -> []Cell {
	// TODO: Count field length and use slice
	cs := make([dynamic]Cell, allocator)
	i := 0
	for r, y in f {
		for c, x in r {
			v := c if m[y][x] else 0
			s := x == p.x && y == p.y
			append(&cs, Cell{x = x, y = y, v = v, s = s})
		}
	}

	return cs[:]
}
