if (keyboard_check_pressed(ord("I"))) typist.in(1, 10);
if (keyboard_check_pressed(ord("O"))) typist.out(1, 10);
if (keyboard_check_pressed(ord("1"))) { element.page(0); typist.in(1, 10); }
if (keyboard_check_pressed(ord("2"))) { element.page(1); typist.in(1, 10); }