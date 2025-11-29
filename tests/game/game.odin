package game_test

import "core:crypto/_fiat/field_curve25519"
import "core:log"
import "core:math/rand"
import "core:testing"
import "src:game"

@(test)
valid_square :: proc(t: ^testing.T) {
	err := game.valid_square(
	{ 	//
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
	{ 	//
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
	{ 	//
		{1, 2},
		{4, 5},
	},
	)

	testing.expect_value(t, err, nil)
}

@(test)
valid_row :: proc(t: ^testing.T) {
	err := game.valid_row({1, 2, 3})

	testing.expect_value(t, err, nil)
}

@(test)
valid_col :: proc(t: ^testing.T) {
	err := game.valid_col(
	{ 	//
		{1, 2},
		{2, 2},
		{7, 2},
	},
	)

	testing.expect_value(t, err, nil)
}

@(test)
left_set :: proc(t: ^testing.T) {
	nums :: bit_set[1 ..= 9]
	full: nums = {1, 2, 3, 4, 5, 6, 7, 8, 9}

	// 1 2 3 4 5 6 7 8 9
	// 4 5 - - - - - - -
	// 7 ? - - - - - - -
	// 2 1
	// 3 -
	// 6 -
	// 5 3
	// 8 6
	// 9 -

	log.infof("left %v", full - {7} - {1, 2, 3, 4, 5, 7} - {2, 5, 1, 3, 6})

}

@(test)
square_set :: proc(t: ^testing.T) {
	set := game.square_set(
	{ 	//
		{1, 2, 3, 1},
		{4, 0, 0, 1},
		{7, 0, 0, 1},
		{1, 1, 1, 1},
	},
	)

	testing.expect_value(t, set, game.Numbers_Set{1, 2, 3, 4, 7})
}

@(test)
row_set :: proc(t: ^testing.T) {
	set := game.row_set({1, 2, 0, 3, 0})

	testing.expect_value(t, set, game.Numbers_Set{1, 2, 3})
}

@(test)
col_set :: proc(t: ^testing.T) {
	set := game.col_set(
	{ 	//
		{1, 2},
		{2, 2},
		{0, 0},
		{7, 2},
		{0, 0},
	},
	)

	testing.expect_value(t, set, game.Numbers_Set{1, 2, 7})
}
