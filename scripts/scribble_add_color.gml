/// void scribble_add_color(name, colour, [colourIsGameMakerBGR]);
// for those of us who don't like excessive and redundant letters

var _name   = argument[0];
var _colour = argument[1];
var _native = ternary((argument_count > 2) && (argument[2] != undefined), argument[2], false);

scribble_add_colour( _name, _colour, _native );
