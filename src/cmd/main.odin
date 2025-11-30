package main

import "core:fmt"
import "src:game"
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

	s := ui.output_field(f)
	defer delete(s)

	fmt.print(s)
}
