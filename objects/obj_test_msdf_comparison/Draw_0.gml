var _standard = scribble("[scale,2][fnt_industrydemi]the quick brown fox jumped over the lazy dog\n\nSPHINX OF BLACK QUARTZ, JUDGE MY VOW");
var _msdf     = scribble("[scale,2][Industry-Demi]the quick brown fox jumped over the lazy dog\n\nSPHINX OF BLACK QUARTZ, JUDGE MY VOW");

_standard.wrap(500).msdf_feather(1.5).draw(10, 10);
_msdf.wrap(500).msdf_feather(1.5).draw(10, _standard.get_bbox(10, 10).bottom + 10);

var _bbox = _standard.get_bbox(10, 10);
draw_rectangle(_bbox.x0, _bbox.y0, _bbox.x3, _bbox.y3, true);

var _bbox = _msdf.get_bbox(10, _standard.get_bbox(10, 10).bottom + 10);
draw_rectangle(_bbox.x0, _bbox.y0, _bbox.x3, _bbox.y3, true);