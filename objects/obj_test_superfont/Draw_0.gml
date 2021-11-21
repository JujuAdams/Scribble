var _x = 10;
var _y = 10;

var _string = "[fnt_test_0]This should be in Arial";
var _element = scribble(_string);
_element.draw(10, _y);
_y += _element.get_height() + 10;

var _string = "[fnt_test_1]This should be in Antipasto Pro";
var _element = scribble(_string);
_element.draw(10, _y);
_y += _element.get_height() + 10;

var _string = "[fnt_overwrite_test]This should be in Antipasto Pro too";
var _element = scribble(_string);
_element.draw(10, _y);
_y += _element.get_height() + 10;

_y += 50;

var _string = "[fnt_noto_latin]Mixed text / 混合文本 / 混合テキスト";
var _element = scribble(_string);
_element.draw(10, _y);
_y += _element.get_height() + 10;

var _string = "[fnt_noto_chinese]Mixed text / 混合文本 / 混合テキスト";
var _element = scribble(_string);
_element.draw(10, _y);
_y += _element.get_height() + 10;

var _string = "[fnt_noto_japanese]Mixed text / 混合文本 / 混合テキスト";
var _element = scribble(_string);
_element.draw(10, _y);
_y += _element.get_height() + 10;

var _string = "[fnt_mixed_languages_test]Mixed text / 混合文本 / 混合テキスト";
var _element = scribble(_string);
_element.draw(10, _y);
_y += _element.get_height() + 10;