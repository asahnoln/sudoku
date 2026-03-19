package input_test

import "core:testing"
import "src:input"
import "src:types"

// TODO: Parse raylib keyboard keys to bytes?

@(test)
mouse :: proc(t: ^testing.T) {
	p := input.pos_from_mouse(25, 1, 20)

	testing.expect_value(t, p, types.Pos{1, 0})
}
