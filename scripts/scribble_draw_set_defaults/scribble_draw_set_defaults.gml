function scribble_draw_set_defaults(argument0, argument1, argument2) {
	if (SCRIBBLE_WARNING_DRAW_SET_DEPRECATED)
	{
	    show_error("Scribble:\nscribble_draw_set_defaults() has been deprecated, please use scribble_set_starting_format()\n(Set SCRIBBLE_WARNING_DRAW_SET_DEPRECATED to <false> to hide this message)\n ", false);
	}

	return scribble_set_starting_format(argument0, argument1, argument2);


}
