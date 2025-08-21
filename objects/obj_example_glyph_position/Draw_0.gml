draw_clear(c_black);

var _x = 10;
var _y = 10;

var _text = "[scale,2]Hi world[/page]oijwagow\n\ngawoijgawj egonawegh";
var _element = scribble(_text).allow_glyph_data_getter();
if (keyboard_check_pressed(vk_up  )) _element.page(_element.get_page()-1);
if (keyboard_check_pressed(vk_down)) _element.page(_element.get_page()+1);
_element.draw(_x, _y, typist);

if (typist.get_state() == 1)
{
    var _last_glyph_data = _element.get_glyph_data(_element.get_glyph_count()-1);
    if (is_struct(_last_glyph_data))
    {
        var _tri_x = _x + _last_glyph_data.right;
        var _tri_y = _y + 0.5*(_last_glyph_data.top + _last_glyph_data.bottom);
        
        draw_triangle(_tri_x, _tri_y, _tri_x+20, _tri_y-10, _tri_x+20, _tri_y+10, true);
    }
}