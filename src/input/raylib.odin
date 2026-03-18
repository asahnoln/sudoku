package input

import "core:c"

pos_from_mouse :: proc(x, y, w: c.int) -> Pos {
	return {cast(int)(x / w), cast(int)(y / w)}
}
