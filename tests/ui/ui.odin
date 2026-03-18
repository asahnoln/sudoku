package ui_test

import "core:slice"
import "core:testing"
import "src:game"
import "src:ui"

@(test)
output_field_graphical :: proc(t: ^testing.T) {
	f := game.Field {
		{1, 2}, //
		{4, 5},
	}
	o := game.Field_Mask{{true, false}, {true, true}}

	@(static) got: [dynamic]ui.Cell
	got = make([dynamic]ui.Cell)
	defer delete(got)

	ui.output_field_graphical(f, o, {0, 1}, nil, proc(lib: rawptr, c: ui.Cell) {
		append(&got, c)
	})

	want := []ui.Cell {
		{x = 0, y = 0, v = 1, s = false},
		{x = 1, y = 0, v = 0, s = false},
		{x = 0, y = 1, v = 4, s = true},
		{x = 1, y = 1, v = 5, s = false},
	}
	testing.expectf(t, slice.equal(got[:], want), "got %v; want %v", got, want)
}

@(test)
is_pos_in_area :: proc(t: ^testing.T) {
	ok := ui.is_pos_in_area({1, 1}, {0, 0, 10, 10})
	testing.expect(t, ok)

	ok = ui.is_pos_in_area({15, 15}, {0, 0, 10, 10})
	testing.expect(t, !ok)
}
