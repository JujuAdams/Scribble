typist = scribble_typist_legacy();
typist.TypeIn(0.01, 0);

scribble_typists_add_event("sdm", function(_element, _parameters)
{
    show_debug_message(_parameters);
});