element = scribble_unique("[delay,2000][sdm,first]abc[sdm,end]");
element.in(0.01, 0);

scribble_typists_add_event("sdm", function(_element, _parameters)
{
    show_debug_message(_parameters);
});