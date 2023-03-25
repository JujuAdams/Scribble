var _element = scribble("a[/page]b[/page]c[/page]")
_element.draw(10, 10);

if (keyboard_check_pressed(ord("1"))) _element.page(0);
if (keyboard_check_pressed(ord("2"))) _element.page(1);
if (keyboard_check_pressed(ord("3"))) _element.page(2);
if (keyboard_check_pressed(ord("4"))) _element.page(3);