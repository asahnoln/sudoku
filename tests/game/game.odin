package game_test

import "core:testing"
import "src:game"
import "src:input"

@(test)
play :: proc(t: ^testing.T) {
	tests := []struct {
		cmd:  input.Cmd,
		want: game.Game,
	} {
		{input.Move{.Left}, {pos = {0, 8}}}, //
		{.Quit, {quit = true}},
	}

	for tt in tests {
		g := game.Game{}
		game.play(&g, tt.cmd)

		testing.expectf(t, g == tt.want, "for cmd %v: got %v; want %v", tt.cmd, g, tt.want)
	}
}
