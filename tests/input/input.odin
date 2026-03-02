package input_test

import "core:testing"
import "src:input"

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
		// TODO: Implement other commands
		// {27, .Quit},
		// {'1', input.Enter_Number{1}},
		//   {'2', .Enter_Symbol},
		//   {'3', .Enter_Symbol},
		//   {'4', .Enter_Symbol},
		//   {'5', .Enter_Symbol},
		//   {'6', .Enter_Symbol},
		//   {'7', .Enter_Symbol},
		//   {'8', .Enter_Symbol},
		//   {'9', .Enter_Symbol},
	}

	for tt in tests {
		got := input.parse(tt.k)
		testing.expectf(t, got == tt.want, "for %v: got %v; want %v", tt.k, got, tt.want)
	}
}
