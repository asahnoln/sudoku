package ui

import "core:strconv"
import "src:game"
import rl "vendor:raylib"

Cell :: struct {
	x, y: int,
	v:    string,
}

output_field_graphical :: proc(
	f: game.Field,
	m: game.Field_Mask,
	p: game.Pos,
	draw: proc(_: Cell),
) {
	for r, x in f {
		for c, y in r {
			buf: [4]byte
			v := strconv.write_int(buf[:], cast(i64)c, 10)
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
