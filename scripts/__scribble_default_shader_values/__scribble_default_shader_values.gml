/// @param json

var _json = argument0;

_json[? "shader master" ] = true; //Feature reduced in "light" version

//Text colour mixing
//_json[? "mix colour" ] = c_white; //Feature removed in "light" version, now inherits draw_get_colour()
//_json[? "mix weight" ] = 0;

//Text alpha
//_json[? "alpha" ] = 1; //Feature reduced in "light" version, now inherits draw_get_alpha()

//Dynamic effects
_json[? "wave size"      ] = 1; //Feature reduced in "light" version
_json[? "shake size"     ] = 1; //Feature reduced in "light" version
_json[? "rainbow weight" ] = 1; //Feature reduced in "light" version

//Character fade
_json[? "char fade t"          ] = 1;
_json[? "char fade smoothness" ] = 0;

//Line fade
_json[? "line fade t"          ] = 1;
_json[? "line fade smoothness" ] = 0;

//Hyperlinks
//_json[? "hyperlink colour"        ] = c_blue; //Feature removed in "light" version
//_json[? "hyperlink fade in rate"  ] = 0.2;
//_json[? "hyperlink fade out rate" ] = 0.2;