element = scribble_unique("123456789")
.typist_options({
    speed: 0.01,
    smoothness: 1,
    methodPerReveal: function(_element, _position)
        {
            //Example function to manually control text sound playback behaviour
            
            show_debug_message(_position);
            
            //Don't play any sound if the typist is set to skip typing
            //if (not _element.typist_get_skip())
            {
                //Modulate our pitch on a sine curve
                var _pitch = lerp(0.8, 1.2, 0.5 + 0.5*dsin(36*_position));
                
                //Play a sound and then modify its pitch
                audio_play_sound(snd_switch, 1, false, 1, 0, _pitch);
            }
        },
})
.typist_start();

scribble_typists_add_event("sdm", function(_element, _parameters)
{
    show_debug_message(_parameters);
});