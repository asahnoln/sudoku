package main

import "core:fmt"
import "core:os/os2"
import "src:game"
import "src:input"
import "src:ui"

// TODO: Just for testing purposes, need to find new generation algo
temp_loop_create :: proc() -> game.Field {
	f: game.Field
	err: game.Options_Exhausted_Error
	i := 0
	for {
		f, err = game.generate_field()
		i += 1
		if err == nil {
			break
		}
	}

	return f
}

main :: proc() {
	f := temp_loop_create()
	defer game.destroy_field(f)

	p := input.Pos{0, 0}

	for {
		s := ui.output_field(f, p)
		defer delete(s)

		fmt.print("\x1b[2J\x1b[H")
		fmt.print(s)

		inp: [4]byte
		_, _ = os2.read(os2.stdin, inp[:])

		p = input.new_pos(p, input.parse_direction(inp[0]))
	}

}
