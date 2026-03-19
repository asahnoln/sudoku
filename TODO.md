# TODO

## Order of implementation

1. [x] API (play in code)
2. [x] Terminal
3. [ ] Window

- [x] Generate game field according to rules
- [x] Output the field
- [x] Player can choose a cell
- [x] Output chosen cell
- [x] Hide some of the numbers
- [x] Player can place a number in a cell
- [x] Game should compare place number against the real one
- [x] Generate open field
- [x] Signal wrong input
- [x] Signal winning
- [ ] Continue looking at code to refactor from enter_input proc
- [ ] Rewrite x and y (right now used x vertically and y horizontally)
- [ ] Draw big borders for big squares
- [ ] Write button system?
- [ ] Refactor input parse
- [ ] Parse map instead of switch case
- [ ] When lost - open all fields
- [ ] Emphasize by color opened fields in the end
- [ ] Revise main code - what can be TDDd?
- [ ] Refactor separate output function
- [ ] How to TDD terminal input???
- [ ] TUI menu?
- [ ] Enum cells instead of int?
- [ ] Find efficient algo to generate field
- [ ] Process and return allocation errors

## TODO UI

- [ ]

## Input

- Position
- Number

## Generation algo

Randomize first row 1-9

Separate by 3s. 3s randomiz in first squares. Then shift the row by 1 and repeat process for the second row of squares etc

## API

```odin
main :: proc() {
 g := game.Game{}

 game.new_field(g)

 ok := game.enter(g, {1, 1}, 5)
 if !ok {
  ok = game.enter(g, {1, 1}, 6)
 }

 switch g.state {
 case .Won:
 case .Playing:
 case .Lost:
 }
}
```
