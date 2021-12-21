var _x = room_width/2;
var _y = room_height/2;

var _element = scribble("[fa_center][fa_middle]Here is a [region,region 1]region\nto test[/region] this [region,region 2]feature.");
_element.transform(2, 2, 45);
_element.draw(_x, _y);

var _region = _element.region_detect(_x, _y, mouse_x, mouse_y);
_element.region_set_active(_region, c_red, 0.5);
draw_text(10, 10, _region);