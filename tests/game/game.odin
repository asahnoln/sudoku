package game_test

import "core:math/rand"
import "core:testing"
import "src:game"

@(test)
generate_line :: proc(t: ^testing.T) {
	rand.reset(1)
	l := game.generate_line()

	check: bit_set[0 ..= 9]
	for row_n in l {
		testing.expectf(t, row_n not_in check, "%d is met more than once in the line %v", row_n, l)
		check = check + {row_n}
	}
}

@(test)
generate_lines :: proc(t: ^testing.T) {
	rand.reset(1)
	ls := game.generate_lines()

	for col_i in 0 ..< 9 {
		check: bit_set[0 ..< 9]
		for row_i in 0 ..< 9 {
			n := ls[row_i][col_i]
			testing.expectf(
				t,
				n not_in check,
				"%d is met more than once in the column %d %w",
				n,
				col_i,
				check,
			)
			check = check + {n}
		}
	}
}

@(test)
valid_square :: proc(t: ^testing.T) {
	rand.reset(1)
	err := game.valid_square(
	[][]int { 	//
		{1, 2, 3},
		{4, 5, 6},
		{7, 8, 9},
	},
	)

	testing.expect(t, err == nil)
}

@(test)
invalid_square :: proc(t: ^testing.T) {
	rand.reset(1)
	err := game.valid_square(
	[][]int { 	//
		{1, 2, 3},
		{4, 5, 2},
		{7, 8, 9},
	},
	)

	testing.expect_value(t, err, game.Square_Error{n = 2, pos1 = {0, 1}, pos2 = {1, 2}})
}

// Sudoku field
// 1 2 3 | 4 5 6 | 7 8 9
// 4 5 6 | 7 8 9 | 1 2 3
// 7 8 9 | 1 2 3 | 4 5 6
// - - - | - - - | - - -
// 1 2 3 | 4 5 6 | 7 8 9
// 4 5 6 | 7 8 9 | 1 2 3
// 7 8 9 | 1 2 3 | 4 5 6
// - - - | - - - | - - -
// 1 2 3 | 4 5 6 | 7 8 9
// 4 5 6 | 7 8 9 | 1 2 3
// 7 8 9 | 1 2 3 | 4 5 6
//
