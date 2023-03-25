var _string = "the quick brown fox jumped over the lazy dog. the quick brown fox jumped over the lazy dog\nSPHINX OF BLACK QUARTZ, JUDGE MY VOW";

var _standard = scribble("[scale,2][fnt_industrydemi]" + _string);
var _sdf      = scribble("[scale,2][spr_msdf_industrydemi]" + _string);

_standard.layout_wrap(500).msdf_feather(1.5).draw(10, 10);
_sdf.layout_wrap(500).msdf_feather(1.5).draw(10, _standard.get_bbox(10, 10).bottom + 10);

var _bbox = _standard.get_bbox(10, 10);
draw_rectangle(_bbox.x0, _bbox.y0, _bbox.x3, _bbox.y3, true);

var _bbox = _sdf.get_bbox(10, _standard.get_bbox(10, 10).bottom + 10);
draw_rectangle(_bbox.x0, _bbox.y0, _bbox.x3, _bbox.y3, true);