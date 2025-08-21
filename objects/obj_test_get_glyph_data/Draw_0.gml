draw_clear(c_black);

if (mouse_check_button(mb_left)) limit_x = mouse_x;
draw_line(limit_x, 0, limit_x, room_height);

var _text = "[scale,2]Hi world[/page]oijwagow\n\ngawoijgawj egonawegh";
var _element = scribble(_text).allow_glyph_data_getter().wrap(limit_x-10);

if (keyboard_check_pressed(vk_up  )) _element.page(_element.get_page()-1);
if (keyboard_check_pressed(vk_down)) _element.page(_element.get_page()+1);

draw_set_colour(c_maroon);
gpu_set_blendmode(bm_add);
var _i = 0;
repeat(_element.get_glyph_count())
{
    var _struct = _element.get_glyph_data(_i);
    draw_rectangle(10 + _struct.left, 10 + _struct.top, 10 + _struct.right, 10 + _struct.bottom, false);
    draw_set_colour((draw_get_colour() == c_maroon)? c_green : c_maroon);
    ++_i;
}

draw_set_colour(c_white);
gpu_set_blendmode(bm_normal);

_element.draw(10, 10);