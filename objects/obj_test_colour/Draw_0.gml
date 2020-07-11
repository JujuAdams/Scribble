scribble_draw(x, y, "[test colour]Test[/c] 1");

scribble_set_blend("test colour", 1.0);
scribble_draw(x, y + 30, "Test 2");
scribble_reset();

scribble_set_starting_format(undefined, "test colour", undefined);
scribble_draw(x, y + 60, "Test 3");
scribble_reset();