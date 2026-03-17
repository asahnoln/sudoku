package input_test

import "core:testing"
import "src:input"
import rl "vendor:raylib"

@(test)
// TODO: Parse raylib keyboard keys to bytes?
parse_raylib :: proc(t: ^testing.T) {
	tests := []struct {
		k:    rl.KeyboardKey,
		want: input.Cmd,
	} {
		{.A, nil}, //
		{.L, input.Move{.Right}},
		{.H, input.Move{.Left}},
		{.K, input.Move{.Up}},
		{.J, input.Move{.Down}},
		{.Q, .Quit},
		{.ESCAPE, .Quit},
		{.ONE, input.Enter_Number{1}},
		{.TWO, input.Enter_Number{2}},
		{.THREE, input.Enter_Number{3}},
		{.FOUR, input.Enter_Number{4}},
		{.FIVE, input.Enter_Number{5}},
		{.SIX, input.Enter_Number{6}},
		{.SEVEN, input.Enter_Number{7}},
		{.EIGHT, input.Enter_Number{8}},
		{.NINE, input.Enter_Number{9}},
	}

	for tt in tests {
		got := input.parse(tt.k)
		testing.expectf(t, got == tt.want, "for %v: got %v; want %v", tt.k, got, tt.want)
	}
}

@(test)
mouse :: proc(t: ^testing.T) {
	p := input.pos_from_mouse(25, 1, 20)

	testing.expect_value(t, p, input.Pos{0, 1})
}
