package game

Pos :: [2]int
Field :: [][]int
Numbers_Set :: bit_set[1 ..= 9]

Error :: union {
	Duplication_Error,
}

Duplication_Error :: struct {
	n:    int,
	pos1: Pos,
	pos2: Pos,
}

SQUARE_SIZE :: 3
NUMBERS_COUNT :: 9
ALL_NUMBERS :: Numbers_Set{1, 2, 3, 4, 5, 6, 7, 8, 9}

@(private)
valid_region :: proc(reg: Field, max_rows: int, max_cols: int) -> Error {
	check := make(map[int]Pos)
	defer delete(check)

	row_final := min(max_rows, len(reg))
	for row_i in 0 ..< row_final {
		col_final := min(max_cols, len(reg[row_i]))
		for col_i in 0 ..< col_final {
			n := reg[row_i][col_i]
			if n in check {
				return Duplication_Error{n, check[n], {row_i, col_i}}
			}

			check[n] = {row_i, col_i}
		}
	}

	return nil
}

valid_square :: proc(sq: Field) -> Error {
	return valid_region(sq, SQUARE_SIZE, SQUARE_SIZE)
}

valid_row :: proc(l: []int) -> Error {
	return valid_region({l}, 1, len(l))
}

valid_col :: proc(l: Field) -> Error {
	return valid_region(l, len(l), 1)
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
	row_final := min(max_rows, len(reg))
	for y in row_i ..< row_final {
		col_final := min(max_cols, len(reg[y]))
		for x in col_i ..< col_final {
			set = set + {reg[y][x]}
		}
	}

	return set
}

square_set :: proc(field: Field, p: Pos) -> Numbers_Set {
	return region_set(field, p.x, p.y, max_rows = SQUARE_SIZE, max_cols = SQUARE_SIZE)
}

row_set :: proc(field: Field, i: int) -> Numbers_Set {
	return region_set(field, row_i = i, max_rows = i + 1)
}

col_set :: proc(field: Field, i: int) -> Numbers_Set {
	return region_set(field, col_i = i, max_cols = i + 1)
}

cell_set :: proc(field: Field, row_i: int, col_i: int) -> Numbers_Set {
	sq_p := find_square_pos({row_i, col_i})
	s := square_set(field, sq_p)
	r := row_set(field, row_i)
	c := col_set(field, col_i)

	return ALL_NUMBERS - s - r - c
}

find_square_pos :: proc(p: Pos) -> (sq_p: Pos) {
	if p.x >= SQUARE_SIZE {
		sq_p.x = SQUARE_SIZE
	}
	if p.y >= SQUARE_SIZE {
		sq_p.y = SQUARE_SIZE
	}

	if p.x >= SQUARE_SIZE * 2 {
		sq_p.x = SQUARE_SIZE * 2
	}
	if p.y >= SQUARE_SIZE * 2 {
		sq_p.y = SQUARE_SIZE * 2
	}

	return sq_p
}
