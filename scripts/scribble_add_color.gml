/// void scribble_add_color(name, colour, [colourIsGameMakerBGR?]);
// for those of us who don't like excessive and redundant letters

var _name   = argument[0];
var _colour = argument[1];
var _native = false;

switch (argument_count){
    case 3:
        if ( argument[2] != undefined ) _native = argument[2];
        break;
}

scribble_add_colour( _name, _colour, _native );
