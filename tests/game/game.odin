package game_test

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
				got := g.opened[1][2]
				want := true
				testing.expectf(t, got == want, "for number 1 at 1,1 got %v; want %v", got, want)
			}},
	}

	for tt in tests {
		g := game.Game {
			field  = {{9, 4, 2}, {3, 1, 5}},
			opened = {{false, false, false}, {false, false, false}},
			pos    = {1, 2},
		}
		game.play(&g, tt.cmd)
		tt.assert(t, g)
	}
}

@(test)
check_number :: proc(t: ^testing.T) {
	g := game.Game {
		field  = {{1, 2, 3}, {4, 5, 6}},
		opened = {{false, false, false}, {false, false, false}},
	}

	g.pos = {0, 2}
	got := game.check_number(&g, 3)
	testing.expectf(t, got, "for pos %v and num %v: got %v; want %v", g.pos, 3, got, true)

}
