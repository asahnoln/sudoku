package game

Error :: union {
	Duplication_Error,
}

Duplication_Error :: struct {
	n:    int,
	pos1: [2]int,
	pos2: [2]int,
}

SQUARE_SIZE :: 3

@(private)
valid_region :: proc(reg: [][]int, max_rows := SQUARE_SIZE, max_cols := SQUARE_SIZE) -> Error {
	check := make(map[int][2]int)
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

valid_square :: proc(sq: [][]int) -> Error {
	return valid_region(sq, SQUARE_SIZE, SQUARE_SIZE)
}

valid_row :: proc(l: []int) -> Error {
	return valid_region({l}, 1, len(l))
}

valid_col :: proc(l: [][]int) -> Error {
	return valid_region(l, len(l), 1)
}
