# TODO

- [x] Generate game field according to rules
- [x] Output the field
- [x] Player can choose a cell
- [x] Output chosen cell
- [ ] Revise main code - what can be TDDd?
- [x] Hide some of the numbers
- [x] Player can place a number in a cell
- [x] Game should compare place number against the real one
- [x] Generate open field
- [ ] Signal wrong input
- [ ] Signal winning
- [ ] Refactor separate output function
- [ ] How to TDD terminal input???
- [ ] TUI menu?
- [ ] Enum cells instead of int?
- [ ] Find efficient algo to generate field

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

  // Implemented
 game.new_field(g)

  // TODO:
 ok := game.enter(g, {1, 1}, 5)
 if !ok {
  ok = game.enter(g, {1, 1}, 6)
 }

 switch g.state {
 case .Win:
 case .Playing:
 case .Lost:
 }
}
```
