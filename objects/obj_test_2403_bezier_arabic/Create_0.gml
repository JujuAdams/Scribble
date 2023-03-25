x0 = 200;
y0 = 300;
x1 = x0 + 100;
y1 = y0 + 200;
x2 = x0 + 400;
y2 = y0 - 200;
x3 = x0 + 600;
y3 = y0;

// Force bilinear filtering on for this test case
gpu_set_tex_filter(true);

scribble_font_set_default("spr_msdf_notoarabic");
test_string = "هل يمكنك رؤية هذا الذي يعد تنازليا؟";