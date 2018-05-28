/// @description text_do_outro( json )
///
/// @param json

var _json = argument0;

if ( _json < 0 ) exit;

if ( _json[? "transition state" ] == E_SCRIBBLE_STATE.INTRO ) || ( _json[? "transition state" ] == E_SCRIBBLE_STATE.VISIBLE ) {
    _json[? "transition timer" ] = _json[? "outro max" ];
    _json[? "transition state" ] = E_SCRIBBLE_STATE.OUTRO;
}
