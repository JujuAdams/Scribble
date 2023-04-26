element.layout_wrap_split(width, height);
page = clamp(page, 0, element.get_page_count()-1);
element.page(page);
element.draw(x, y);

if (keyboard_check_pressed(ord("1")))
{
    element.scroll_to_page(0, 2);
}
else if (keyboard_check_pressed(ord("2")))
{
    element.scroll_to_page(1, 2);
}

var _bbox = element.get_bbox(x, y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

draw_set_color(c_yellow);
draw_rectangle(x, y, x + width, y + height, true);
draw_set_color(c_white);