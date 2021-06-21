var _element = scribble("[sdm,start][fa_center][fa_middle]Words words words\nMore words[sdm,end page 0][/page][sdm,start page 1]There was a manual page break!\nFurther words...\n...and the last words.[sdm,end]")

_element.starting_format("fnt_test_1", c_white).draw(room_width/2, room_height/2, typist);

draw_line(room_width/2, 0, room_width/2, room_height);
draw_line(0, room_height/2, room_width, room_height/2);

if (keyboard_check_pressed(ord("1"))) _element.page(0);
if (keyboard_check_pressed(ord("2")))
{
    __scribble_trace("changed page");
    _element.page(1);
}

draw_text(10, 10, typist.get_position());
draw_text(10, 30, typist.get_state());