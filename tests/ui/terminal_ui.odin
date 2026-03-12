package ui_test

import "core:testing"
import "src:game"
import "src:ui"

@(test)
output_field :: proc(t: ^testing.T) {
	f := game.Field {
		{1, 2, 3, 1, 2, 3, 1, 2, 3},
		{4, 5, 6, 4, 5, 6, 4, 5, 6},
		{7, 8, 9, 7, 8, 9, 7, 8, 9},
		{1, 2, 3, 1, 2, 3, 1, 2, 3},
		{4, 5, 6, 4, 5, 6, 4, 5, 6},
		{7, 8, 9, 7, 8, 9, 7, 8, 9},
		{1, 2, 3, 1, 2, 3, 1, 2, 3},
		{4, 5, 6, 4, 5, 6, 4, 5, 6},
		{7, 8, 9, 7, 8, 9, 7, 8, 9},
	}
	o := game.Field_Mask {
		{true, false, true, true, true, true, true, true, true},
		{true, true, true, true, true, true, true, true, true},
		{true, true, true, true, true, true, true, true, true},
		{true, true, true, true, true, true, true, true, true},
		{true, true, true, true, true, true, true, true, true},
		{true, true, true, true, true, true, true, true, true},
		{true, true, true, true, true, true, true, true, true},
		{true, true, true, true, true, true, true, true, true},
		{true, true, true, true, true, true, true, true, true},
	}

	s := ui.output_field(f, {0, 0}, o)
	defer delete(s)

	testing.expect_value(
		t,
		s,
		"\x1b[44;37m1\x1b[0m" +
		` x 3 | 1 2 3 | 1 2 3
4 5 6 | 4 5 6 | 4 5 6
7 8 9 | 7 8 9 | 7 8 9
------+-------+------
1 2 3 | 1 2 3 | 1 2 3
4 5 6 | 4 5 6 | 4 5 6
7 8 9 | 7 8 9 | 7 8 9
------+-------+------
1 2 3 | 1 2 3 | 1 2 3
4 5 6 | 4 5 6 | 4 5 6
7 8 9 | 7 8 9 | 7 8 9`,
	)

}
