function scribble_draw_set_wrap() {
	if (SCRIBBLE_WARNING_DRAW_SET_DEPRECATED)
	{
	    show_error("Scribble:\scribble_draw_set_wrap() has been deprecated, please use scribble_set_wrap()\n(Set SCRIBBLE_WARNING_DRAW_SET_DEPRECATED to <false> to hide this message)\n ", false);
	}

	scribble_set_line_height(argument[0], -1);

	switch(argument_count)
	{
	    case 2: return scribble_set_wrap(argument[1], -1);
	    case 3: return scribble_set_wrap(argument[1], argument[2]);
	    default: return scribble_set_wrap(argument[1], argument[2], argument[3]);
	}


}
