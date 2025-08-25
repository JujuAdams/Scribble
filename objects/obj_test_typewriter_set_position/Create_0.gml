//scribble_font_set_default("fnt_noto_arabic_sdf");
//element = scribble("[scale,2]هل يمكنك رؤية هذا الذي يعد تنازليًا؟");

element = scribble_unique("here's some [wave]cute text[/wave]! [spr_large_coin]");
element.in(0.2, 10);
element.ease(SCRIBBLE_EASE_BOUNCE, 0, -40, 1, 1, 0, 0.1);