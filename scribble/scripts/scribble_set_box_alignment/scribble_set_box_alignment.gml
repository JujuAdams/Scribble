/// @description Sets the alignment of a SCRIBBLE JSON
///              Pass in no additional arguments to reset the SCRIBBLE alignment to left+top
/// @param json
/// @param [halign]
/// @param [valign]

var _json   = argument[0];
var _halign = ((argument_count<2) || (argument[1]==undefined))? fa_left : argument[1];
var _valign = ((argument_count<3) || (argument[2]==undefined))? fa_top  : argument[2];

var _width  = _json[? "width"  ];
var _height = _json[? "height" ];
_json[? "halign" ] = _halign;
_json[? "valign" ] = _valign;

//Horizontal justification
if ( _halign == fa_left ) {
    _json[? "left"  ] = 0;
    _json[? "right" ] = _width;
} else if ( _halign == fa_center ) {
    _json[? "left"  ] = -_width div 2;
    _json[? "right" ] =  _width div 2;
} else if ( _halign == fa_right ) {
    _json[? "left"  ] = -_width;
    _json[? "right" ] = 0;
}

//Vertical justification
if ( _valign == fa_top ) {
    _json[? "top"    ] = 0;
    _json[? "bottom" ] = _height;
} else if ( _valign == fa_middle ) {
    _json[? "top"    ] = -_height div 2;
    _json[? "bottom" ] =  _height div 2;
} else if ( _valign == fa_bottom ) {
    _json[? "top"    ] = -_height;
    _json[? "bottom" ] = 0;
}