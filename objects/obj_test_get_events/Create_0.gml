scribble_typewriter_add_event("sdm", function(_element, _parameters)
{
    show_debug_message(_parameters);
});

element = scribble("[sdm,first]abc[sdm,end]");
show_debug_message(element.get_events(0));
show_debug_message(element.get_events(1));
show_debug_message(element.get_events(2));
show_debug_message(element.get_events(3));