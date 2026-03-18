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
	game.create_field(&g)

	keys := keys_map()

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

		ui.output_field_graphical(g.field, g.field_mask, g.pos, &r, ui.draw_raylib)

		if rl.IsMouseButtonPressed(.LEFT) {
			g.pos = input.pos_from_mouse(rl.GetMouseX(), rl.GetMouseY(), r.width)
		}

		game.play(&g, keys[rl.GetKeyPressed()])
	}
}

keys_map :: proc() -> (keys: map[rl.KeyboardKey]input.Cmd) {
	keys[.ESCAPE] = .Quit
	keys[.Q] = .Quit
	keys[.ONE] = input.Enter_Number{1}
	keys[.TWO] = input.Enter_Number{2}
	keys[.THREE] = input.Enter_Number{3}
	keys[.FOUR] = input.Enter_Number{4}
	keys[.FIVE] = input.Enter_Number{5}
	keys[.SIX] = input.Enter_Number{6}
	keys[.SEVEN] = input.Enter_Number{7}
	keys[.EIGHT] = input.Enter_Number{8}
	keys[.NINE] = input.Enter_Number{9}
	keys[.L] = input.Move{.Right}
	keys[.H] = input.Move{.Left}
	keys[.K] = input.Move{.Up}
	keys[.J] = input.Move{.Down}

	return
}

keys_tmap :: proc() -> (keys: map[byte]input.Cmd) {
	keys[27] = .Quit
	keys['q'] = .Quit
	keys['1'] = input.Enter_Number{1}
	keys['2'] = input.Enter_Number{2}
	keys['3'] = input.Enter_Number{3}
	keys['4'] = input.Enter_Number{4}
	keys['5'] = input.Enter_Number{5}
	keys['6'] = input.Enter_Number{6}
	keys['7'] = input.Enter_Number{7}
	keys['8'] = input.Enter_Number{8}
	keys['9'] = input.Enter_Number{9}
	keys['l'] = input.Move{.Right}
	keys['h'] = input.Move{.Left}
	keys['k'] = input.Move{.Up}
	keys['j'] = input.Move{.Down}

	return
}


game_term :: proc() {
	// Hide cursor
	fmt.print("\x1b[?25l")

	g := game.Game {
		max_mistakes = 3,
	}
	game.create_field(&g)

	keys := keys_tmap()

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
		game.play(&g, keys[k])
	}

	fmt.print("\n\nBYE-BYE!\n")
}
