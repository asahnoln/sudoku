package game

import "core:math/rand"

generate_line :: proc(gen := context.random_generator) -> [9]int {
	base := [9]int{1, 2, 3, 4, 5, 6, 7, 8, 9}
	rand.shuffle(base[:], gen)
	return base
}

generate_lines :: proc(gen := context.random_generator) -> [2][9]int {
	lines := [2][9]int{}
	lines[0] = generate_line(gen)
	for {
		lines[1] = generate_line(gen)
		if valid_cols(lines) {
			break
		}
	}

	return lines
}

valid_cols :: proc(ls: [2][9]int) -> bool {
	for col_i in 0 ..< 9 {
		check: bit_set[0 ..< 9]
		for row_i in 0 ..< 2 {
			n := ls[row_i][col_i]
			if n in check {
				return false
			}
			check = check + {n}
		}
	}

	return true
}
