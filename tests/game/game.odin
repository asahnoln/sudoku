package game_test

import "core:log"
import "core:math/rand"
import "core:slice"
import "core:testing"
import "src:game"

generate_field :: proc(t: ^testing.T) {
	rand.reset(1)
	f := game.generate_field()
	defer game.destroy_field(f)

	want := game.Field {
		{2, 4, 8, 2, 6, 4, 2, 0, 8},
		{2, 0, 6, 3, 3, 7, 7, 4, 4},
		{2, 4, 4, 4, 6, 2, 7, 8, 0},
		{7, 1, 4, 5, 8, 8, 2, 8, 5},
		{7, 1, 8, 8, 4, 2, 4, 8, 8},
		{8, 4, 1, 5, 6, 8, 8, 8, 8},
		{2, 6, 6, 0, 4, 0, 0, 4, 0},
		{4, 2, 8, 8, 4, 5, 5, 0, 8},
		{8, 2, 8, 0, 6, 0, 0, 2, 0},
	}
	for r, i in f {
		testing.expectf(t, slice.equal(r, want[i]), "got %v, want %v", r, want[i])
	}
}

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
square_set :: proc(t: ^testing.T) {
	set := game.square_set(
	{ 	//
		{9, 1, 2, 3, 9},
		{9, 4, 0, 0, 9},
		{9, 7, 0, 0, 9},
		{9, 9, 9, 9, 9},
	},
	{0, 1},
	)

	testing.expect_value(t, set, game.Numbers_Set{1, 2, 3, 4, 7})
}

@(test)
row_set :: proc(t: ^testing.T) {
	set := game.row_set(
		{ 	//
			{1, 1, 1, 1, 1},
			{1, 2, 0, 3, 0},
			{9, 9, 9, 9, 9},
		},
		1,
	)

	testing.expect_value(t, set, game.Numbers_Set{1, 2, 3})
}

@(test)
col_set :: proc(t: ^testing.T) {
	set := game.col_set(
		{ 	//
			{9, 1, 2},
			{9, 2, 2},
			{9, 0, 0},
			{9, 7, 2},
			{9, 0, 0},
		},
		1,
	)

	testing.expect_value(t, set, game.Numbers_Set{1, 2, 7})
}

@(test)
cell_set :: proc(t: ^testing.T) {
	field := game.Field { 	//
		{1, 2, 3, 4, 5, 6, 7, 8, 9},
		{4, 5, 0, 0, 0, 0, 0, 0, 0},
		{7, 0, 0, 0, 0, 0, 0, 0, 0},
		{2, 1, 0, 3, 0, 0, 0, 0, 0},
		{3, 0, 0, 0, 0, 0, 0, 0, 0},
		{6, 0, 0, 0, 0, 0, 0, 0, 0},
		{5, 3, 0, 0, 0, 0, 0, 0, 0},
		{8, 6, 0, 0, 0, 0, 0, 0, 0},
		{9, 0, 0, 0, 0, 0, 0, 0, 0},
	}

	set := game.cell_set(field, 2, 1)
	testing.expect_value(t, set, game.Numbers_Set{8, 9})

	set = game.cell_set(field, 3, 4)
	testing.expect_value(t, set, game.Numbers_Set{4, 6, 7, 8, 9})
}

@(test)
cell_set_2 :: proc(t: ^testing.T) {
	field := game.Field {
		{3, 5, 9, 2, 6, 7, 4, 1, 8},
		{2, 6, 1, 8, 3, 4, 9, 5, 7},
		{4, 8, 7, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
	}

	set := game.cell_set(field, 2, 3)
	testing.expect_value(t, set, game.Numbers_Set{1, 5, 9})
}

@(test)
cell_set_3 :: proc(t: ^testing.T) {
	field := game.Field {
		{3, 5, 9, 2, 6, 7, 4, 1, 8},
		{2, 6, 1, 3, 5, 4, 9, 7, 1},
		{7, 4, 8, 1, 9, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0},
		// {4, 1, 7, 5, 2, 6, 8, 3, 9},
		// {5, 3, 6, 4, 8, 9, 7, 2, 1},
		// {9, 8, 2, 7, 1, 3, 6, 4, 5},
		// {8, 2, 3, 9, 7, 5, 1, 6, 4},
		// {1, 9, 4, 8, 3, 2, 5, 1, 7},
		// {6, 7, 5, 1, 4, 1, 2, 8, 3},
	}

	set := game.cell_set(field, 2, 5)
	testing.expect_value(t, set, game.Numbers_Set{1, 5, 9})
}

@(test)
find_closest_square_pos :: proc(t: ^testing.T) {
	pos := game.find_square_pos({1, 1})
	testing.expect_value(t, pos, game.Pos{0, 0})

	pos = game.find_square_pos({3, 4})
	testing.expect_value(t, pos, game.Pos{3, 3})

	pos = game.find_square_pos({2, 3})
	testing.expect_value(t, pos, game.Pos{0, 3})

	pos = game.find_square_pos({7, 8})
	testing.expect_value(t, pos, game.Pos{6, 6})
}
