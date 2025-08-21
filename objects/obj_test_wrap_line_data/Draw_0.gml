element.allow_line_data_getter().wrap(width, height);
page = clamp(page, 0, element.get_page_count()-1);
element.page(page);
element.draw(x, y);

var _i = 0;
repeat(element.get_line_count(page))
{
    var _data = element.get_line_data(_i, page);
    if (_data.forced_break && (_data.glyph_count > 1))
    {
        draw_sprite(spr_white_coin, 0, x-10, y + _data.y + (_data.height div 2));
    }
    
    draw_set_alpha(0.5);
    draw_line(x, y + _data.y + (_data.height div 2), x + width, y + _data.y + (_data.height div 2));
    draw_set_alpha(1);
    
    ++_i;
}

var _bbox = element.get_bbox(x, y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

draw_set_color(c_yellow);
draw_rectangle(x, y, x + width, y + height, true);
draw_set_color(c_white);