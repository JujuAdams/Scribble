function example_autotype_callback(argument0, argument1) {
	var _element = argument0;
	var _pos     = argument1;

	//Only call this code if we're creating the character array
	if (SCRIBBLE_CREATE_CHARACTER_ARRAY)
	{
	    //Find the character array for this text element
	    var _character_array = _element[SCRIBBLE.CHARACTER_ARRAY];
    
	    //Read what character was displayed
	    var _char = _character_array[_pos];
    
	    //Characters are mostly stored as Unicode integer character codes
	    //However, sprites counts as "characters" in Scribble and they are stored as strings
	    if (!is_string(_char))
	    {
	        if (_char > 32) //For any character that's not a space
	        {
	            //Output the character itself into the debug log
	            show_debug_message(chr(_char));
            
	            //Play the correct vowel sound!
	            if ((_char == ord("a")) || (_char == ord("A"))) audio_play_sound(snd_vowel_0, 0, false);
	            if ((_char == ord("e")) || (_char == ord("E"))) audio_play_sound(snd_vowel_1, 0, false);
	            if ((_char == ord("i")) || (_char == ord("I"))) audio_play_sound(snd_vowel_2, 0, false);
	            if ((_char == ord("o")) || (_char == ord("O"))) audio_play_sound(snd_vowel_3, 0, false);
	            if ((_char == ord("u")) || (_char == ord("U"))) audio_play_sound(snd_vowel_4, 0, false);
	        }
	    }
	}


}
