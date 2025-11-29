package game_test

import "core:math/rand"
import "core:testing"
import "src:game"

@(test)
valid_square :: proc(t: ^testing.T) {
	err := game.valid_square(
	[][]int { 	//
		{1, 2, 3, 1},
		{4, 5, 6, 1},
		{7, 8, 9, 1},
		{1, 1, 1, 1},
	},
	)

	testing.expect(t, err == nil)
}

@(test)
invalid_square :: proc(t: ^testing.T) {
	err := game.valid_square(
	[][]int { 	//
		{1, 2, 3},
		{4, 5, 2},
		{7, 8, 9},
	},
	)

	testing.expect_value(t, err, game.Duplication_Error{n = 2, pos1 = {0, 1}, pos2 = {1, 2}})
}

@(test)
valid_not_full_square :: proc(t: ^testing.T) {
	err := game.valid_square(
	[][]int { 	//
		{1, 2},
		{4, 5},
	},
	)

	testing.expect_value(t, err, nil)
}

@(test)
valid_row :: proc(t: ^testing.T) {
	err := game.valid_row([]int{1, 2, 3})

	testing.expect_value(t, err, nil)
}

@(test)
valid_col :: proc(t: ^testing.T) {
	err := game.valid_col(
	[][]int { 	//
		{1, 2},
		{2, 2},
		{7, 2},
	},
	)

	testing.expect_value(t, err, nil)
}
