//FIXME - Seems to have an off-by-one problem with Arabic
//var _string = "[fnt_noto_arabic_sdf][scale,2]هل يمكنك رؤية هذا الذي يعد تنازليًا؟";

var _string = "here's some [wave]cute text[/wave]![spr_large_coin]";

element = scribble_unique(_string)
.typist_ease(SCRIBBLE_EASE_BOUNCE, 0, -40, 1, 1, 0, 0.1);