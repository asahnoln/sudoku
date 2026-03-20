# TODO

## Order of implementation

1. [x] API (play in code)
2. [x] Terminal
3. [ ] Window

- [ ] Center text now a little off to the right
- [ ] Figure out font loading
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

## TODO

- [ ] Menu (New game, key config, quit)
- [ ] Key config (save and load)
- [ ] Game screen with mistakes and other info and buttons (reset, back to menu)
- [ ] Export to win, mac, lin, android

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
