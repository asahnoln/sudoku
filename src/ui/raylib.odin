package ui

import "core:c"
import "vendor:raylib"

Raylib :: struct {
	width: c.int,
	draw:  proc "c" (posX, posY: c.int, width, height: c.int, color: raylib.Color),
	text:  proc "c" (text: cstring, posX, posY: c.int, fontSize: c.int, color: raylib.Color),
}

draw_raylib :: proc(lib: rawptr, cell: Cell) {
	this := cast(^Raylib)lib

	this.draw(
		cast(c.int)cell.x * this.width,
		cast(c.int)cell.y * this.width,
		this.width,
		this.width,
		raylib.GRAY,
	)
}
