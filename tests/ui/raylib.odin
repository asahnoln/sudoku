package ui_test

import "core:c"
import "core:testing"
import "src:ui"
import "vendor:raylib"

@(test)
draw_raylib :: proc(t: ^testing.T) {
	drawData :: struct {
		posX, posY:    c.int,
		width, height: c.int,
		color:         raylib.Color,
	}
	textData :: struct {
		text:       cstring,
		posX, posY: c.int,
		fontSize:   c.int,
		color:      raylib.Color,
	}

	@(static) gotDraw := drawData{}
	@(static) gotText := textData{}

	rl := ui.Raylib {
		width = 20,
		text_size = 10,
		draw = proc "c" (posX, posY: c.int, width, height: c.int, color: raylib.Color) {
			gotDraw.posX = posX
			gotDraw.posY = posY
			gotDraw.width = width
			gotDraw.height = height
			gotDraw.color = color

		},
		text = proc "c" (text: cstring, posX, posY: c.int, fontSize: c.int, color: raylib.Color) {
			gotText.text = text
			gotText.posX = posX
			gotText.posY = posY
			gotText.fontSize = fontSize
			gotText.color = color
		},
	}
	dp: ui.Draw_Proc = ui.draw_raylib

	dp(&rl, {x = 0, y = 0, v = 1})
	testing.expect_value(
		t,
		gotDraw,
		drawData{posX = 0, posY = 0, width = 20, height = 20, color = raylib.GRAY},
	)
	testing.expect_value(
		t,
		gotText,
		textData{text = "1", posX = 5, posY = 5, fontSize = 10, color = raylib.BLACK},
	)

	dp(&rl, {x = 1, y = 1, v = 1})
	testing.expect_value(
		t,
		gotDraw,
		drawData{posX = 20, posY = 20, width = 20, height = 20, color = raylib.GRAY},
	)
	testing.expect_value(
		t,
		gotText,
		textData{text = "1", posX = 25, posY = 25, fontSize = 10, color = raylib.BLACK},
	)


}
