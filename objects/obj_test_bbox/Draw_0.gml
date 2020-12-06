var _text = "[fa_middle][c_red]Hi world";

var _bbox = scribble(_text).get_bbox(300, 300);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, false);
scribble(_text).draw(300, 300);