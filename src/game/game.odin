package game

import "core:slice"
import "src:input"

Game :: struct {
	field:        Field,
	field_mask:   [][]bool,
	state:        State,
	max_mistakes: int,
	mistakes:     int,
	pos:          Pos,
	quit:         bool,
}

State :: enum {
	Playing,
	Won,
	Lost,
}

Pos :: [2]int

Row :: []int
Field :: []Row

Row_Mask :: []bool
Field_Mask :: []Row_Mask

Numbers_Set :: bit_set[1 ..= 9]

// TODO: This is only to test if force filling works at all
Options_Exhausted_Error :: enum {
	None,
	NoOptionsLeft,
}

SQUARE_SIZE :: 3
NUMBERS_COUNT :: 9
ALL_NUMBERS :: Numbers_Set{1, 2, 3, 4, 5, 6, 7, 8, 9}

prepare :: proc(g: ^Game, gen := context.random_generator, allocator := context.allocator) {
	f: Field
	err: Options_Exhausted_Error
	for {
		f, err = generate_field(gen, allocator)
		if err == nil {
			break
		}
	}

	g.field = f
	g.field_mask = generate_field_mask(gen, allocator)
}

play :: proc(g: ^Game, cmd: input.Cmd) {
	switch c in cmd {
	case input.Enter_Number:
		enter(g, g.pos, c.v)
	case input.Move:
		g.pos = input.new_pos(g.pos, c.dir)
	case input.SimpleCmd:
		switch c {
		case .Quit:
			g.quit = true
		}
	}
}

enter :: proc(g: ^Game, p: Pos, n: int) -> (ok: bool) {
	if g.field[p.x][p.y] == n {
		g.field_mask[p.x][p.y] = true
		ok = true
	} else {
		g.mistakes += 1
	}

	update_state(g)
	return ok
}

update_state :: proc(g: ^Game) {
	switch {
	case losing(g):
		g.state = .Lost
	case winning(g):
		g.state = .Won
	}
}

losing :: proc(g: ^Game) -> bool {
	return g.mistakes >= g.max_mistakes
}

winning :: proc(g: ^Game) -> bool {
	for r in g.field_mask {
		if !slice.all_of(r, true) {
			return false
		}
	}

	return true
}
