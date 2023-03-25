var _element = scribble("[fa_center][fa_middle]Words words words\nMore words[/page]There was a manual page break!\nFurther words...\n...and the last words.");
_element.font("fnt_test_1").draw(room_width/2, room_height/2);

draw_line(room_width/2, 0, room_width/2, room_height);
draw_line(0, room_height/2, room_width, room_height/2);

if (keyboard_check_pressed(ord("1"))) _element.page(0);
if (keyboard_check_pressed(ord("2"))) _element.page(1);