package ui

import "core:strings"
import "src:game"
import "src:input"

SELECTED :: "\x1b[44;37m"
RESET :: "\x1b[0m"

output_field :: proc(f: game.Field, p: input.Pos, allocator := context.allocator) -> string {
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

			if p == ({row_i, col_i}) {
				strings.write_string(&b, SELECTED)
			}

			strings.write_int(&b, c)

			if p == ({row_i, col_i}) {
				strings.write_string(&b, RESET)

			}

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
