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


prepare :: proc(t: ^testing.T) {
	g := game.Game{}

	rand.reset(173) // NOTE: 173 gives 1 cycle
	game.prepare(&g)
	defer game.destroy_field(g.field)
	defer game.destroy_field(g.field_mask)

	testing.expect_value(t, len(g.field), game.NUMBERS_COUNT)
	want := game.Field {
		{4, 7, 9, 3, 6, 1, 8, 2, 5},
		{2, 8, 5, 7, 4, 9, 6, 3, 1},
		{3, 6, 1, 2, 8, 5, 7, 9, 4},
		{6, 9, 7, 8, 1, 3, 5, 4, 2},
		{1, 2, 4, 6, 5, 7, 3, 8, 9},
		{8, 5, 3, 9, 2, 4, 1, 6, 7},
		{9, 1, 2, 5, 3, 8, 4, 7, 6},
		{7, 4, 8, 1, 9, 6, 2, 5, 3},
		{5, 3, 6, 4, 7, 2, 9, 1, 8},
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
		{true, false, false, true, false, true, true, true, true},
		{false, true, false, false, false, false, true, false, false},
		{true, false, true, false, false, false, true, false, false},
		{true, false, false, false, true, true, false, false, true},
		{true, true, true, true, false, true, false, true, false},
		{true, false, false, true, true, false, false, false, true},
		{false, false, true, true, false, false, true, true, true},
		{true, true, false, false, false, false, true, true, false},
		{true, false, true, true, true, false, true, false, true},
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
		field      = {{0, 0, 0}, {0, 5, 0}},
		field_mask = {{false, false, false}, {false, false, false}},
	}

	ok := game.enter(&g, {1, 1}, 4)
	testing.expect_value(t, ok, false)
	testing.expect_value(t, g.field_mask[1][1], false)


	ok = game.enter(&g, {1, 1}, 5)
	testing.expect_value(t, ok, true)
	testing.expect_value(t, g.field_mask[1][1], true)

	ok = game.enter(&g, {1, 1}, 6)
	testing.expect_value(t, ok, false)
	testing.expect_value(t, g.field_mask[1][1], true)
}

@(test)
state_won :: proc(t: ^testing.T) {
	g := game.Game {
		field        = {{1, 0}, {0, 2}},
		field_mask   = {{false, true}, {true, false}},
		max_mistakes = 100,
	}

	testing.expect_value(t, g.state, game.State.Playing)

	_ = game.enter(&g, {0, 0}, 1)
	testing.expect_value(t, g.state, game.State.Playing)

	_ = game.enter(&g, {1, 1}, 9)
	testing.expect_value(t, g.state, game.State.Playing)

	_ = game.enter(&g, {1, 1}, 2)
	testing.expect_value(t, g.state, game.State.Won)
}

@(test)
state_lost :: proc(t: ^testing.T) {
	g := game.Game {
		field        = {{9}},
		field_mask   = {{false}},
		max_mistakes = 3,
		mistakes     = 2,
	}

	_ = game.enter(&g, {0, 0}, 1)
	testing.expect_value(t, g.state, game.State.Lost)
}
