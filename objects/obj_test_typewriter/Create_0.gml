//FIXME - There appears to be an off-by-one when revealing Arabic text
//var _string = "[fnt_noto_arabic_sdf][scale,2]هل يمكنك رؤية هذا الذي يعد تنازليًا؟";

var _string = "here's some [wave]cute text[/wave]! [spr_large_coin]";

element = scribble_unique(_string)
.typist_options({ speed: 0.2, smoothness: 10 })
.typist_ease(SCRIBBLE_EASE_LINEAR, 0, -40, 1, 1, 0, 0.1)
.typist_start();