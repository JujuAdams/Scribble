element.layout_wrap_split(width, height);
element.scroll_to_page(page, 5);
element.draw(x, y);

var _bbox = element.get_bbox(x, y);
draw_set_alpha(0.2);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, false);
draw_set_alpha(1);

draw_set_color(c_yellow);
draw_rectangle(x, y, x + width, y + height, true);
draw_set_color(c_white);

draw_set_colour(c_maroon);
gpu_set_blendmode(bm_add);
var _i = 0;
repeat(element.get_glyph_count())
{
    var _struct = element.get_glyph_data(_i);
    draw_rectangle(x + _struct.left, y + _struct.top, x + _struct.right, y + _struct.bottom, false);
    draw_set_colour((draw_get_colour() == c_maroon)? c_green : c_maroon);
    ++_i;
}

draw_set_colour(c_white);
gpu_set_blendmode(bm_normal);