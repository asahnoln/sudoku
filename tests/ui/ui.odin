package ui_test

import "core:fmt"
import "core:log"
import "core:math/rand"
import "core:slice"
import "core:testing"
import "src:game"
import "src:ui"
import rl "vendor:raylib"

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

	ui.output_field_graphical(f, o, {0, 0}, proc(c: ui.Cell) {
		append(&got, c)
	})

	want := []ui.Cell {
		{y = 0, x = 0, v = 1},
		{y = 0, x = 1, v = 0},
		{y = 1, x = 0, v = 4},
		{y = 1, x = 1, v = 5},
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
