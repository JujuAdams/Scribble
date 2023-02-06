if (keyboard_check_pressed(ord("P")) && audio_is_playing(sound))
{
    if (audio_is_paused(sound))
    {
        audio_resume_sound(sound);
    }
    else
    {
        audio_pause_sound(sound);
    }
}