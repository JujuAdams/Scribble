function scribble_draw_set_state(argument0) {
	if (SCRIBBLE_WARNING_DRAW_SET_DEPRECATED)
	{
	    show_error("Scribble:\scribble_draw_set_state() has been deprecated, please use scribble_set_state()\n(Set SCRIBBLE_WARNING_DRAW_SET_DEPRECATED to <false> to hide this message)\n ", false);
	}

	return scribble_set_state(argument0);


}
