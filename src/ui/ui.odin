package ui

import "core:strings"
import "src:game"

output_field :: proc(f: game.Field, allocator := context.allocator) -> string {
	b := strings.builder_make(allocator)

	for r, row_i in f {
		if row_i != 0 && row_i % game.SQUARE_SIZE == 0 {
			strings.write_string(&b, "------+-------+------\n")
		}

		for c, col_i in r {
			if col_i != 0 && col_i % game.SQUARE_SIZE == 0 {
				strings.write_string(&b, "|")
				strings.write_string(&b, " ")
			}

			strings.write_int(&b, c)

			if col_i < len(r) - 1 {
				strings.write_string(&b, " ")
			}
		}

		if row_i < len(f) - 1 {
			strings.write_string(&b, "\n")
		}
	}

	return strings.to_string(b)
}
