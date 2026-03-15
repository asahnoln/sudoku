package ui

import "core:strconv"
import "src:game"
import rl "vendor:raylib"

Cell :: struct {
	x, y: int,
	v:    int,
}

output_field_graphical :: proc(
	f: game.Field,
	m: game.Field_Mask,
	p: game.Pos,
	draw: proc(_: Cell),
) {
	for r, y in f {
		for c, x in r {
			v := c if m[y][x] else 0
			draw({x = x, y = y, v = v})
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
