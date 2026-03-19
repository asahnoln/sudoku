package ui_test

import "core:c"
import "core:testing"
import "src:ui"
import rl "vendor:raylib"

@(test)
draw_raylib :: proc(t: ^testing.T) {
	drawData :: struct {
		posX, posY:    c.int,
		width, height: c.int,
		color:         rl.Color,
	}
	textData :: struct {
		text:         cstring,
		posX, posY:   c.int,
		fontSize:     c.int,
		color:        rl.Color,
		times_called: int,
	}

	@(static) gotDraw := drawData{}
	@(static) gotDrawLines := drawData{}
	@(static) gotText := textData{}

	lib := ui.Raylib {
		width = 20,
		text_size = 10,
		draw = proc "c" (posX, posY: c.int, width, height: c.int, color: rl.Color) {
			gotDraw.posX = posX
			gotDraw.posY = posY
			gotDraw.width = width
			gotDraw.height = height
			gotDraw.color = color

		},
		draw_border = proc "c" (posX, posY: c.int, width, height: c.int, color: rl.Color) {
			gotDrawLines.posX = posX
			gotDrawLines.posY = posY
			gotDrawLines.width = width
			gotDrawLines.height = height
			gotDrawLines.color = color
		},
		text = proc "c" (text: cstring, posX, posY: c.int, fontSize: c.int, color: rl.Color) {
			gotText.text = text
			gotText.posX = posX
			gotText.posY = posY
			gotText.fontSize = fontSize
			gotText.color = color
			gotText.times_called += 1
		},
		colors = {bg_active = rl.BLUE, bg_default = rl.GRAY, border = rl.WHITE, text = rl.BLACK},
	}

	ui.draw_raylib(lib, {x = 0, y = 0, v = 1})
	testing.expect_value(
		t,
		gotDraw,
		drawData{posX = 0, posY = 0, width = 20, height = 20, color = rl.GRAY},
	)
	testing.expect_value(
		t,
		gotDrawLines,
		drawData{posX = 0, posY = 0, width = 20, height = 20, color = rl.WHITE},
	)
	testing.expect_value(
		t,
		gotText,
		textData {
			text = "1",
			posX = 5,
			posY = 5,
			fontSize = 10,
			color = rl.BLACK,
			times_called = 1,
		},
	)

	ui.draw_raylib(lib, {x = 1, y = 1, v = 2, s = true})
	testing.expect_value(
		t,
		gotDraw,
		drawData{posX = 20, posY = 20, width = 20, height = 20, color = rl.BLUE},
	)
	testing.expect_value(
		t,
		gotDrawLines,
		drawData{posX = 20, posY = 20, width = 20, height = 20, color = rl.WHITE},
	)
	testing.expect_value(
		t,
		gotText,
		textData {
			text = "2",
			posX = 25,
			posY = 25,
			fontSize = 10,
			color = rl.BLACK,
			times_called = 2,
		},
	)

	ui.draw_raylib(lib, {x = 1, y = 1, v = 0, s = true})
	testing.expect_value(t, gotText.times_called, 2)
}
