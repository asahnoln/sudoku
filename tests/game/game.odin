package game_test

import "core:math/rand"
import "core:slice"
import "core:testing"
import "src:game"
import "src:input"

@(test)
play :: proc(t: ^testing.T) {
	tests := []struct {
		cmd:    input.Cmd,
		assert: proc(t: ^testing.T, g: game.Game),
	} {
		{input.Move{.Up}, proc(t: ^testing.T, g: game.Game) {
				got := g.pos
				want := game.Pos{0, 2}
				testing.expectf(t, got == want, "for move left got pos %v; want %v", got, want)
			}}, //
		{.Quit, proc(t: ^testing.T, g: game.Game) {
				got := g.quit
				want := true
				testing.expectf(t, got == want, "for quit got %v; want %v", got, want)
			}},
		{input.Enter_Number{5}, proc(t: ^testing.T, g: game.Game) {
				got := g.field_mask[1][2]
				want := true
				testing.expectf(t, got == want, "for number 1 at 1,1 got %v; want %v", got, want)
			}},
	}

	for tt in tests {
		g := game.Game {
			field      = {{9, 4, 2}, {3, 1, 5}},
			field_mask = {{false, false, false}, {false, false, false}},
			pos        = {1, 2},
		}
		game.play(&g, tt.cmd)
		tt.assert(t, g)
	}
}

@(test)
check_number :: proc(t: ^testing.T) {
	g := game.Game {
		field      = {{1, 2, 3}, {4, 5, 6}},
		field_mask = {{false, false, false}, {false, false, false}},
	}

	g.pos = {0, 2}
	got := game.check_number(&g, 3)
	testing.expectf(t, got, "for pos %v and num %v: got %v; want %v", g.pos, 3, got, true)
}

@(test)
new_field :: proc(t: ^testing.T) {
	g := game.Game{}

	rand.reset(266) // NOTE: 266 gives 1 cycle
	game.prepare(&g)
	defer game.destroy_field(g.field)
	defer game.destroy_field(g.field_mask)

	testing.expect_value(t, len(g.field), game.NUMBERS_COUNT)
	want := game.Field {
		{5, 4, 9, 6, 8, 3, 2, 7, 1},
		{7, 3, 6, 5, 2, 1, 4, 9, 8},
		{2, 1, 8, 7, 4, 9, 5, 6, 3},
		{4, 6, 7, 9, 3, 8, 1, 2, 5},
		{8, 9, 2, 1, 7, 5, 6, 3, 4},
		{3, 5, 1, 2, 6, 4, 7, 8, 9},
		{1, 2, 3, 4, 9, 6, 8, 5, 7},
		{9, 7, 4, 8, 5, 2, 3, 1, 6},
		{6, 8, 5, 3, 1, 7, 9, 4, 2},
	}
	for _, i in g.field {
		testing.expectf(
			t,
			slice.equal(g.field[i], want[i]),
			"got field row %d %v; want %v",
			i,
			g.field[i],
			want[i],
		)
	}

	testing.expect_value(t, len(g.field_mask), game.NUMBERS_COUNT)
	want_mask := game.Field_Mask {
		{false, false, false, true, true, false, true, true, true},
		{true, false, true, false, false, false, false, false, true},
		{false, false, true, true, true, false, false, false, false},
		{true, true, true, false, true, true, false, false, true},
		{false, true, true, false, false, false, false, true, false},
		{true, false, true, true, true, false, true, true, false},
		{true, true, false, true, true, true, true, false, true},
		{false, true, false, true, false, false, true, false, true},
		{true, false, false, false, true, false, false, true, true},
	}
	for _, i in g.field_mask {
		testing.expectf(
			t,
			slice.equal(g.field_mask[i], want_mask[i]),
			"got field_mask row %d %v; want %v",
			i,
			g.field_mask[i],
			want_mask[i],
		)
	}
}

@(test)
enter :: proc(t: ^testing.T) {
	g := game.Game {
		field      = {{0, 0, 0}},
		field_mask = {{false, false, false}},
	}

	game.enter(&g, {1, 1}, 5)

	testing.expect_value(t, g.field_mask[0][0], true)
}
