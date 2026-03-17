package input

import "core:c"

pos_from_mouse :: proc(x, y, w: c.int) -> Pos {
	return {cast(int)(y / w), cast(int)(x / w)}
}
