package input

import "core:c"
import "src:types"

pos_from_mouse :: proc(x, y, w: c.int) -> types.Pos {
	return {cast(int)(x / w), cast(int)(y / w)}
}
