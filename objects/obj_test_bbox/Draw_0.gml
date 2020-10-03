var _text = "[fa_middle][c_red]Hi world";

var bbox = scribble_get_bbox(300, 300, _text);
draw_rectangle(bbox[0], bbox[1], bbox[2], bbox[3], false);
scribble_draw(300, 300, _text);