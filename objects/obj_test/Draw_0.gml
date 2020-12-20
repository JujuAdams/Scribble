var _bbox = element.get_bbox(room_width div 2, room_height div 2, 5, 5, 5, 5);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);
draw_primitive_begin(pr_trianglestrip);
draw_vertex_color(_bbox.x0, _bbox.y0, c_gray, 1.0);
draw_vertex_color(_bbox.x1, _bbox.y1, c_gray, 1.0);
draw_vertex_color(_bbox.x2, _bbox.y2, c_gray, 1.0);
draw_vertex_color(_bbox.x3, _bbox.y3, c_gray, 1.0);
draw_primitive_end();

element.transform(1, 1, -15).typewriter_in(skip? 9999 : 1, 0).draw(room_width div 2, room_height div 2);