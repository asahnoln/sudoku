package game

import "core:math/rand"
import "src:types"

generate_field :: proc(
	gen := context.random_generator,
	allocator := context.allocator,
) -> (
	Field,
	Options_Exhausted_Error,
) {
	f := make(Field, NUMBERS_COUNT, allocator)
	for i in 0 ..< NUMBERS_COUNT {
		f[i] = make(Row, NUMBERS_COUNT, allocator)
	}

	for &r, row_i in f {
		for &c, col_i in r {
			set := cell_possible_set(f, row_i, col_i)

			ok: bool
			c, ok = rand.choice_bit_set(set, gen)
			if !ok {
				destroy_field(f, allocator)
				return nil, Options_Exhausted_Error.NoOptionsLeft
			}
		}
	}

	return f, nil
}

generate_field_mask :: proc(
	gen := context.random_generator,
	allocator := context.allocator,
) -> Field_Mask {
	f := make(Field_Mask, NUMBERS_COUNT, allocator)
	for i in 0 ..< NUMBERS_COUNT {
		f[i] = make(Row_Mask, NUMBERS_COUNT, allocator)
	}

	for &r in f {
		for &c in r {
			c = rand.choice([]bool{true, false})
		}
	}

	return f
}

destroy_field :: proc(f: $T/[][]$E, allocator := context.allocator) {
	for r in f {
		delete(r, allocator)
	}
	delete(f, allocator)
}

@(private)
region_set :: proc(
	reg: Field,
	row_i := 0,
	col_i := 0,
	max_rows := NUMBERS_COUNT,
	max_cols := NUMBERS_COUNT,
) -> (
	set: Numbers_Set,
) {
	row_final := min(row_i + max_rows, len(reg))
	for y in row_i ..< row_final {
		col_final := min(col_i + max_cols, len(reg[y]))
		for x in col_i ..< col_final {
			set = set + {reg[y][x]}
		}
	}

	return set
}

square_set :: proc(field: Field, p: types.Pos) -> Numbers_Set {
	return region_set(field, p.y, p.x, max_rows = SQUARE_SIZE, max_cols = SQUARE_SIZE)
}

row_set :: proc(field: Field, i: int) -> Numbers_Set {
	return region_set(field, row_i = i, max_rows = 1)
}

col_set :: proc(field: Field, i: int) -> Numbers_Set {
	return region_set(field, col_i = i, max_cols = 1)
}

cell_possible_set :: proc(field: Field, row_i: int, col_i: int) -> Numbers_Set {
	sq_p := find_square_pos({col_i, row_i})
	s := square_set(field, sq_p)
	r := row_set(field, row_i)
	c := col_set(field, col_i)

	return ALL_NUMBERS - s - r - c
}

find_square_pos :: proc(p: types.Pos) -> (sq_p: types.Pos) {
	sq_p.x = SQUARE_SIZE * (p.x / SQUARE_SIZE)
	sq_p.y = SQUARE_SIZE * (p.y / SQUARE_SIZE)

	return sq_p
}
