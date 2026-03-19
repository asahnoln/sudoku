package ui

import "core:c"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

Raylib :: struct {
	width:       c.int,
	text_size:   c.int,
	draw:        proc "c" (posX, posY: c.int, width, height: c.int, color: rl.Color),
	draw_border: proc "c" (posX, posY: c.int, width, height: c.int, color: rl.Color),
	text:        proc "c" (text: cstring, posX, posY: c.int, fontSize: c.int, color: rl.Color),
	colors:      struct {
		bg_active:  rl.Color,
		bg_default: rl.Color,
		border:     rl.Color,
		text:       rl.Color,
	},
}

draw_raylib :: proc(lib: rawptr, cell: Cell) {
	this := cast(^Raylib)lib

	this.draw(
		cast(c.int)cell.x * this.width,
		cast(c.int)cell.y * this.width,
		this.width,
		this.width,
		cell.s ? this.colors.bg_active : this.colors.bg_default,
	)
	this.draw_border(
		cast(c.int)cell.x * this.width,
		cast(c.int)cell.y * this.width,
		this.width,
		this.width,
		this.colors.border,
	)

	if cell.v == 0 {
		return
	}

	buf: [4]byte
	text := strconv.write_int(buf[:], cast(i64)cell.v, 10)
	ctext := strings.clone_to_cstring(text)
	defer delete(ctext)

	this.text(
		ctext,
		// TODO: Write center proc
		cast(c.int)cell.x * this.width + (this.width / 2) - (this.text_size / 2),
		cast(c.int)cell.y * this.width + (this.width / 2) - (this.text_size / 2),
		this.text_size,
		this.colors.text,
	)
}
