/// @description text_do_outro( json )
/// @function text_do_outro
/// @param json 
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _json = argument0;

if ( _json < 0 ) exit;

if ( _json[? "transition state" ] == E_SCRIBBLE_STATE.INTRO ) || ( _json[? "transition state" ] == E_SCRIBBLE_STATE.VISIBLE ) {
    _json[? "transition timer" ] = _json[? "outro max" ];
    _json[? "transition state" ] = E_SCRIBBLE_STATE.OUTRO;
}
