//var _bbox = element.get_bbox(room_width div 2, room_height div 2, 5, 5, 5, 5);
//draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);
//draw_primitive_begin(pr_trianglestrip);
//draw_vertex_color(_bbox.x0, _bbox.y0, c_gray, 1.0);
//draw_vertex_color(_bbox.x1, _bbox.y1, c_gray, 1.0);
//draw_vertex_color(_bbox.x2, _bbox.y2, c_gray, 1.0);
//draw_vertex_color(_bbox.x3, _bbox.y3, c_gray, 1.0);
//draw_primitive_end();
//
//element.transform(1, 1, -15).draw(room_width div 2, room_height div 2, typist);

var _demo_string = "a bcd"; //"Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet...\", comes from a line in section 1.10.32.";
scribble(_demo_string).wrap(mouse_x - 10).draw(10, 10);
draw_line(mouse_x, 0, mouse_x, room_height);