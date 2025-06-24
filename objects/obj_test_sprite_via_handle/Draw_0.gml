var _coin = spr_coin;
var _white_coin = spr_white_coin;
var _vertical_sprite = spr_vertical_spacing;

var _string = string_join("\n",
$"{object_get_name(object_index)}",
$"[{_coin}] <-- basic animation",
$"[d#{c_red}][{_white_coin}] <-- red coin![/]",
$"[rainbow][{_white_coin}] <-- rainbow coin![/]",
$"[cycle, 60, 100, 0, 200][{_white_coin}] <-- colour cycle coin!",
$"[scale,2][{_vertical_sprite}][/scale] <-- vertically spaced sprite");
scribble(_string).draw(10, 10);