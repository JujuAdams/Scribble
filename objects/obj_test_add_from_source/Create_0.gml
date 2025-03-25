sprite = sprite_add("fnt_font_awesome.png", 1, false, false, 0, 0);

var _buffer = buffer_load("fnt_font_awesome.yy");
var _json_string = buffer_read(_buffer, buffer_text);
var _yy_json = json_parse(_json_string);
buffer_delete(_buffer);

font_name = scribble_font_add_from_source(sprite, 0, _yy_json);
scribble_font_set_default(font_name);