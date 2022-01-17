var _x = 10;
var _y = 10;

var _string = "[fnt_test_1]Mixed text / 混合テキスト";
var _element = scribble(_string);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _string = "[fnt_noto_japanese]Mixed text / 混合テキスト";
var _element = scribble(_string);
_element.draw(_x, _y);
_y += _element.get_height() + 10;

var _string = "[fnt_mixed_test]Mixed text / 混合テキスト";
var _element = scribble(_string);
_element.draw(_x, _y);
_y += _element.get_height() + 10;