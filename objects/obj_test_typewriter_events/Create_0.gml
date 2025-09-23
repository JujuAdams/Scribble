scribble_typists_add_event("sdm", function(_element, _parameters)
{
    show_debug_message(_parameters);
});

element = scribble_unique("[delay,2000][sdm,first]123[sdm,mid]456[sdm,end]")
.typist_options({ speed: 0.1, smoothness: 0 })
.typist_start();