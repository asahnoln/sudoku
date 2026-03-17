package main

import "core:fmt"
import "core:sys/posix"
import "src:game"
import "src:input"
import "src:ui"
import rl "vendor:raylib"

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
	game_ui()
	// game_term()
}

game_ui :: proc() {
	// TODO: Why this hack works? Without it err:
	// Internal Compiler Error: Type_Info for 'u16' could not be found
	fmt.print("\x1b[?25l")

	g := game.Game {
		max_mistakes = 3,
	}
	game.prepare(&g)

	r := ui.Raylib {
		width       = 60,
		text_size   = 30,
		draw        = rl.DrawRectangle,
		draw_border = rl.DrawRectangleLines,
		text        = rl.DrawText,
	}
	rl.InitWindow(9 * r.width, 9 * r.width, "SUDOKU")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	for !g.quit {
		rl.BeginDrawing()
		defer rl.EndDrawing()

		if rl.IsMouseButtonPressed(.LEFT) {
			g.pos = input.pos_from_mouse(rl.GetMouseX(), rl.GetMouseY(), r.width)
		}

		ui.output_field_graphical(g.field, g.field_mask, g.pos, &r, ui.draw_raylib)

		c := input.parse(rl.GetKeyPressed())
		game.play(&g, c)
	}
}


game_term :: proc() {
	// Hide cursor
	fmt.print("\x1b[?25l")

	g := game.Game {
		max_mistakes = 3,
	}
	game.prepare(&g)

	main_loop: for !g.quit {
		s := ui.output_field(g.field, g.pos, g.field_mask)
		defer delete(s)

		// Clear terminal
		fmt.print("\x1b[2J\x1b[H")
		fmt.println(s)

		fmt.printfln("\nMistakes: %d", g.mistakes)

		switch g.state {
		case .Won:
			fmt.print("\nGOOD JOB!")
			break main_loop
		case .Lost:
			fmt.print("\nYOU LOST!")
			break main_loop
		case .Playing:
		}

		k, _ := get_immediate_key()
		c := input.parse(k)
		game.play(&g, c)
	}

	fmt.print("\n\nBYE-BYE!\n")
}
