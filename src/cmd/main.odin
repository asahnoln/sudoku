package main

import "core:fmt"
import "core:sys/posix"
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

get_immediate_key :: proc() -> (key: u8, ok: bool) {
	old_term, new_term: posix.termios

	// Get current terminal settings
	if posix.tcgetattr(posix.STDIN_FILENO, &old_term) != .OK {
		return 0, false
	}

	new_term = old_term

	// Disable canonical mode and echo
	new_term.c_lflag -= {.ICANON, .ECHO}

	// Apply settings immediately
	posix.tcsetattr(posix.STDIN_FILENO, .TCSANOW, &new_term)

	// Read single character
	buffer: [1]u8
	bytes_read := posix.read(posix.STDIN_FILENO, raw_data(buffer[:]), 1)

	// Restore original settings
	posix.tcsetattr(posix.STDIN_FILENO, .TCSANOW, &old_term)

	if bytes_read > 0 {
		return buffer[0], true
	}
	return 0, false
}

main :: proc() {
	// Hide cursor
	fmt.print("\x1b[?25l")

	f := temp_loop_create()
	defer game.destroy_field(f)

	p := input.Pos{0, 0}

	for {
		s := ui.output_field(f, p)
		defer delete(s)

		// Clear terminal
		fmt.print("\x1b[2J\x1b[H")

		fmt.print(s)

		// inp: [2]byte
		// _, _ = os2.read(os2.stdin, inp[:])
		//
		// p = input.new_pos(p, input.parse_direction(inp[0]))

		k, _ := get_immediate_key()
		p = input.new_pos(p, input.parse_direction(k))
	}

}
