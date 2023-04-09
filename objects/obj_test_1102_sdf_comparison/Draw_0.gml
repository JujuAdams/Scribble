var _string = "the quick brown fox jumped over the lazy dog. the quick brown fox jumped over the lazy dog\nSPHINX OF BLACK QUARTZ, JUDGE MY VOW";

var _standard = scribble_unique(0, _string);
var _sdf      = scribble_unique(1, _string);

_standard.scale(0.85).font("fnt_noto_latin").layout_wrap(900).draw(10, 10);
_sdf.scale(0.85).font("NotoSansSDF").layout_wrap(900).draw(10, _standard.get_bbox(10, 10).bottom + 10);

var _bbox = _standard.get_bbox(10, 10);
draw_rectangle(_bbox.x0, _bbox.y0, _bbox.x3, _bbox.y3, true);

var _bbox = _sdf.get_bbox(10, _standard.get_bbox(10, 10).bottom + 10);
draw_rectangle(_bbox.x0, _bbox.y0, _bbox.x3, _bbox.y3, true);