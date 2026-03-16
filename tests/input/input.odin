package input_test

import "core:testing"
import "src:input"
import rl "vendor:raylib"

@(test)
position :: proc(t: ^testing.T) {
	tests := []struct {
		start: input.Pos,
		dir:   input.Direction,
		want:  input.Pos,
	} {
		{{0, 0}, .Right, {0, 1}}, //
		{{0, 4}, .Left, {0, 3}},
		{{2, 0}, .Up, {1, 0}},
		{{3, 0}, .Down, {4, 0}},

		// Wrap pos
		{{1, 8}, .Right, {1, 0}},
		{{8, 2}, .Down, {0, 2}},
		{{3, 0}, .Left, {3, 8}},
		{{0, 4}, .Up, {8, 4}},
	}

	for i in tests {
		got := input.new_pos(i.start, i.dir)

		testing.expectf(
			t,
			got == i.want,
			"from %v to %v: got %v; want %v",
			i.start,
			i.dir,
			got,
			i.want,
		)
	}
}

// TODO:: Map instead of proc
@(test)
parse :: proc(t: ^testing.T) {
	tests := []struct {
		k:    byte,
		want: input.Cmd,
	} {
		{'a', nil}, //
		{'l', input.Move{.Right}},
		{'h', input.Move{.Left}},
		{'k', input.Move{.Up}},
		{'j', input.Move{.Down}},
		{'q', .Quit},
		{27, .Quit},
		{'1', input.Enter_Number{1}},
		{'2', input.Enter_Number{2}},
		{'3', input.Enter_Number{3}},
		{'4', input.Enter_Number{4}},
		{'5', input.Enter_Number{5}},
		{'6', input.Enter_Number{6}},
		{'7', input.Enter_Number{7}},
		{'8', input.Enter_Number{8}},
		{'9', input.Enter_Number{9}},
	}

	for tt in tests {
		got := input.parse(tt.k)
		testing.expectf(t, got == tt.want, "for %v: got %v; want %v", tt.k, got, tt.want)
	}
}

@(test)
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

// TODO: Parse raylib keyboard keys to bytes?
