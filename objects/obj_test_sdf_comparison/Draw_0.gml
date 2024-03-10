var _string = "the quick brown fox jumped over the lazy dog.\nSPHINX OF BLACK QUARTZ, JUDGE MY VOW";

var _standard = scribble("[scale,2][fnt_industrydemi_control]" + _string);
var _sdf      = scribble("[scale,2][fnt_industrydemi_sdf]" + _string);

_standard.wrap(330).draw(10, 10);
_sdf.wrap(330).draw(10, _standard.get_bbox(10, 10).bottom + 10);

var _bbox = _standard.get_bbox(10, 10);
draw_rectangle(_bbox.x0, _bbox.y0, _bbox.x3, _bbox.y3, true);

var _bbox = _sdf.get_bbox(10, _standard.get_bbox(10, 10).bottom + 10);
draw_rectangle(_bbox.x0, _bbox.y0, _bbox.x3, _bbox.y3, true);

draw_set_font(fnt_industrydemi_control);
draw_text_ext_transformed(360, 10, _string, -1, 330/2, 2, 2, 0);
draw_set_font(fnt_industrydemi_sdf);
draw_text_ext_transformed(360, _standard.get_bbox(10, 10).bottom + 10, _string, -1, 330/2, 2, 2, 0);
draw_set_font(-1);