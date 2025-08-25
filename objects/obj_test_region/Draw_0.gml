var _element = scribble("Here is a [region,region 1]region\nto test[/region] this [region,region 2]feature.");
var _region = _element.region_detect(10, 10, mouse_x, mouse_y);
_element.region_set_active(_region, c_red, 0.5);
_element.region_draw(10, 10, _region, 4, spr_highlight_test, undefined, c_lime, 0.2);
_element.draw(10, 10);

draw_set_font(scribble_fallback_font);
draw_text(10, 50, _region);