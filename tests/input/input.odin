package input_test

import "core:testing"
import "src:input"

@(test)
position :: proc(t: ^testing.T) {
	tests := []struct {
		start: input.Pos,
		dir:   input.Direction,
		want:  input.Pos,
	} {
		{{0, 0}, .Right, {0, 1}}, //
		{{0, 4}, .Left, {0, 3}},
		{{2, 0}, .Up, {1, 0}},
		{{3, 0}, .Down, {4, 0}},

		// Wrap pos
		{{1, 8}, .Right, {1, 0}},
		{{8, 2}, .Down, {0, 2}},
		{{3, 0}, .Left, {3, 8}},
		{{0, 4}, .Up, {8, 4}},
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

@(test)
parse :: proc(t: ^testing.T) {
	// TODO: Changet to table tests and more keys and errors
	testing.expect(t, input.parse_direction('l') == .Right)
	testing.expect(t, input.parse_direction('h') == .Left)
	testing.expect(t, input.parse_direction('k') == .Up)
	testing.expect(t, input.parse_direction('j') == .Down)
}
