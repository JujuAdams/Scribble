typist = scribble_typist_legacy(true);
typist.TypeIn(0.02, 1);

scribble_typists_add_event("sdm", function(_element, _parameters)
{
    show_debug_message(_parameters);
});