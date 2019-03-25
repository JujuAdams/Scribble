/// array_equals_safe( a, b )

var _a = argument0;
var _b = argument1;

if (!is_array(_a) || !is_array(_b)) return false;
return array_equals(_a, _b);
