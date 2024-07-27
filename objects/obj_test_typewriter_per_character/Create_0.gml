typist = scribble_typist();
typist.in(0.1, 0);
typist.function_per_char(function(_element, _position, _typist)
{
    //Example function to manually control text sound playback behaviour
    
    show_debug_message(_position);
    
    //Don't play any sound if the typist is set to skip typing
    if (!_typist.get_skip())
    {
        //Modulate our pitch on a sine curve
        var _pitch = lerp(0.8, 1.2, 0.5 + 0.5*dsin(36*_position));
        
        //Play a sound and then modify its pitch
        audio_play_sound(snd_switch, 1, false, 1, 0, _pitch);
    }
});

scribble_typists_add_event("sdm", function(_element, _parameters)
{
    show_debug_message(_parameters);
});