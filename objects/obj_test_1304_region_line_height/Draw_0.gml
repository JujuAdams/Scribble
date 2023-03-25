var _element = scribble("[fnt_teko]Here is a [region,region 1]region\nto test[/region] this [region,region 2]feature.");
_element.line_height(32, 32);
_element.draw(10, 10);

var _region = _element.region_detect(10, 10, mouse_x, mouse_y);
_element.region_set_active(_region, c_red, 0.5);

draw_set_font(scribble_fallback_font);
draw_text(10, 200, string(_region));