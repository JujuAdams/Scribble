element.layout_wrap_split(width, height);
element.scroll_to_page(page, 5);
element.draw(x, y);

var _bbox = element.get_bbox(x, y);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);

draw_set_color(c_yellow);
draw_rectangle(x, y, x + width, y + height, true);
draw_set_color(c_white);