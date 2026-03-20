package ui_test

import "core:slice"
import "core:testing"
import "src:game"
import "src:ui"

@(test)
convert_feild_to_cells :: proc(t: ^testing.T) {
	f := game.Field {
		{1, 2}, //
		{4, 5},
	}
	o := game.Field_Mask{{true, false}, {true, true}}

	got := ui.convert_field_to_cells(f, o, {0, 1})
	defer delete(got)

	want := []ui.Cell {
		{x = 0, y = 0, v = 1, s = false},
		{x = 1, y = 0, v = 0, s = false},
		{x = 0, y = 1, v = 4, s = true},
		{x = 1, y = 1, v = 5, s = false},
	}
	testing.expectf(t, slice.equal(got[:], want), "got %v; want %v", got, want)
}
