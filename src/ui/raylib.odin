package ui

import "core:c"
import "core:strconv"
import "core:strings"
import "vendor:raylib"

Raylib :: struct {
	width:     c.int,
	text_size: c.int,
	draw:      proc "c" (posX, posY: c.int, width, height: c.int, color: raylib.Color),
	text:      proc "c" (text: cstring, posX, posY: c.int, fontSize: c.int, color: raylib.Color),
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

	buf: [4]byte
	text := strconv.write_int(buf[:], cast(i64)cell.v, 10)
	ctext := strings.clone_to_cstring(text)
	defer delete(ctext)

	this.text(
		ctext,
		cast(c.int)cell.x * this.width + (this.width / 2) - (this.text_size / 2),
		cast(c.int)cell.y * this.width + (this.width / 2) - (this.text_size / 2),
		this.text_size,
		raylib.BLACK,
	)
}
