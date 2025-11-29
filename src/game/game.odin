package game

import "core:math/rand"

Line :: [9]int
Lines :: [2]Line

generate_line :: proc(gen := context.random_generator) -> Line {
	base := Line{1, 2, 3, 4, 5, 6, 7, 8, 9}
	rand.shuffle(base[:], gen)
	return base
}

generate_lines :: proc(gen := context.random_generator) -> Lines {
	lines := Lines{}
	lines[0] = generate_line(gen)

	for {
		lines[1] = generate_line(gen)
		if valid_cols(lines) {
			break
		}
	}

	return lines
}

valid_cols :: proc(ls: Lines) -> bool {
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
