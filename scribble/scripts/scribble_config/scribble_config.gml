/// @description SCRIBBLE configuration

/*
    Fonts are declared in scribble_init(), unless overridden by SCRIBBLE_AUTO_FONT_INIT
*/
#macro DEFAULT_FONT fnt_default
#macro SCRIBBLE_AUTO_FONT_INIT true

#macro SCRIBBLE_FONT_CHAR_MIN 32
#macro SCRIBBLE_FONT_CHAR_MAX 127

#macro SCRIBBLE_CHAR_PADDING 2 //Increase this if characters are overlapping when drawn
#macro SCRIBBLE_SURFACE_SIZE 4096 //Incrase this size if you're adding more fonts/characters
#macro SCRIBBLE_CHARACTER_SURFACE_SIZE 60 //Increase this size if large characters are getting clipped
#macro SCRIBBLE_OUTPUT_MAXIMUM_CHAR_SIZE false
#macro SCRIBBLE_HASH_NEWLINE true