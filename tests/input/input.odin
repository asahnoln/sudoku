package input_test

import "core:testing"
import "src:input"
import "src:types"

@(test)
position :: proc(t: ^testing.T) {
	tests := []struct {
		start: types.Pos,
		dir:   input.Direction,
		want:  types.Pos,
	} {
		{{0, 0}, .Right, {1, 0}}, //
		{{4, 0}, .Left, {3, 0}},
		{{0, 2}, .Up, {0, 1}},
		{{0, 3}, .Down, {0, 4}},

		// Wrap pos
		{{8, 1}, .Right, {0, 1}},
		{{2, 8}, .Down, {2, 0}},
		{{0, 3}, .Left, {8, 3}},
		{{4, 0}, .Up, {4, 8}},
	}

	for i in tests {
		got := input.new_pos(i.start, i.dir)

		testing.expectf(
			t,
			got == i.want,
			"from %v to %v: got %v; want %v",
			i.start,
			i.dir,
			got,
			i.want,
		)
	}
}
