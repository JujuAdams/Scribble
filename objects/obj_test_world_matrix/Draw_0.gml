matrix_set(matrix_world, matrix_build(80, 30, 0,   0,0,-20,  1.5, 1.5, 0));
scribble("World matrix test!\nWorld matrix test!\nWorld matrix test!\nWorld matrix test!").draw(100, 100);
draw_circle(100, 100, 5, false);
draw_circle(0, 0, 5, false);
matrix_set(matrix_world, matrix_build_identity());

draw_circle(80, 30, 12, true);
scribble("World matrix test!\nWorld matrix test!\nWorld matrix test!\nWorld matrix test!").draw(80, 30);