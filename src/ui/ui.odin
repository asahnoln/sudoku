package ui

import "src:game"
import rl "vendor:raylib"

Cell :: struct {
	x, y: int,
	v:    int,
	s:    bool,
}

Draw_Proc :: proc(lib: rawptr, c: Cell)

output_field_graphical :: proc(
	f: game.Field,
	m: game.Field_Mask,
	p: game.Pos,
	lib: rawptr,
	draw: Draw_Proc,
) {
	for r, y in f {
		for c, x in r {
			v := c if m[y][x] else 0
			draw(lib, {x = x, y = y, v = v, s = y == p.x && x == p.y})
		}
	}
}

is_pos_in_area :: proc(pos: rl.Vector2, area: rl.Rectangle) -> bool {
	return(
		pos.x >= area.x &&
		pos.x < area.x + area.width &&
		pos.y >= area.y &&
		pos.y < area.y + area.height \
	)
}
