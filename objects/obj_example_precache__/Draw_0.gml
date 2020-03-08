scribble_draw_set_box_align(fa_center, fa_middle);
scribble_draw(x, y, element);

var _bbox = scribble_get_bbox(element,   x, y,   5, 5,   5, 5);
draw_rectangle(_bbox[SCRIBBLE_BBOX.L], _bbox[SCRIBBLE_BBOX.T],
               _bbox[SCRIBBLE_BBOX.R], _bbox[SCRIBBLE_BBOX.B], true);

scribble_draw_reset();