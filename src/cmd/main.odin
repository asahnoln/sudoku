package main

import "core:fmt"
import "core:sys/posix"
import "src:game"
import "src:input"
import "src:ui"
import "vendor:microui"
import rl "vendor:raylib"

// TODO: Just for testing purposes, need to find new generation algo
temp_loop_create :: proc() -> game.Field {
	f: game.Field
	err: game.Options_Exhausted_Error
	for {
		f, err = game.generate_field()
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
	main_ui()
	// main_terminal()
}

main_ui :: proc() {
	g := game.Game {
		max_mistakes = 3,
	}
	game.prepare(&g)

	rl.InitWindow(500, 500, "SUDOKU")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	for !g.quit {
		rl.BeginDrawing()

		for r in g.field {
			for c in r {

			}
		}
		defer rl.EndDrawing()
	}
}

// main_ui :: proc() {
// 	ctx := &microui.Context{}
// 	microui.init(ctx)
//
// 	ctx.text_width()
// 	if (microui.begin_window(ctx, "My Window", microui.Rect{10, 10, 140, 86})) {
// 		microui.layout_row(ctx, {60, -1}, 0)
//
// 		microui.label(ctx, "First:")
// 		if (microui.button(ctx, "Button1")) {
// 			printf("Button1 pressed\n")
// 		}
//
// 		microui.label(ctx, "Second:")
// 		if (microui.button(ctx, "Button2")) {
// 			microui.open_popup(ctx, "My Popup")
// 		}
//
// 		if (microui.begin_popup(ctx, "My Popup")) {
// 			microui.label(ctx, "Hello world!")
// 			microui.end_popup(ctx)
// 		}
//
// 		microui.end_window(ctx)
// 	}
// }

main_terminal :: proc() {
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
