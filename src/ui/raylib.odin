package ui

import "core:c"
import "core:strconv"
import "core:strings"
import "src:types"
import rl "vendor:raylib"

Raylib :: struct {
	width:       c.int,
	font_size:   c.int,
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

draw_raylib :: proc(lib: Raylib, cell: Cell) {
	lib.draw(
		cast(c.int)cell.x * lib.width,
		cast(c.int)cell.y * lib.width,
		lib.width,
		lib.width,
		cell.s ? lib.colors.bg_active : lib.colors.bg_default,
	)
	lib.draw_border(
		cast(c.int)cell.x * lib.width,
		cast(c.int)cell.y * lib.width,
		lib.width,
		lib.width,
		lib.colors.border,
	)

	if cell.v == 0 {
		return
	}

	buf: [4]byte
	text := strconv.write_int(buf[:], cast(i64)cell.v, 10)
	ctext := strings.clone_to_cstring(text)
	defer delete(ctext)

	// text_size := rl.MeasureTextEx(rl.GetFontDefault(), ctext, cast(f32)lib.font_size, 0)
	text_size := rl.MeasureText(ctext, lib.font_size)
	text_pos := center_text_coords(
		{
			cast(int)(cast(c.int)cell.x * lib.width),
			cast(int)(cast(c.int)cell.y * lib.width),
			cast(int)(lib.width),
			cast(int)(lib.width),
		},
		{cast(int)(text_size), cast(int)(text_size)},
	)
	lib.text(
		ctext,
		cast(c.int)text_pos.x,
		cast(c.int)cell.y * lib.width + (lib.width / 2) - (lib.font_size / 2),
		lib.font_size,
		lib.colors.text,
	)
}

center_text_coords :: proc(c: struct {
		x, y, w, h: int,
	}, t: struct {
		w, h: int,
	}) -> types.Pos {
	return {c.x + c.w / 2 - t.w / 2, c.y + c.h / 2 - t.h / 2}
}
