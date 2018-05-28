if ( SCRIBBLE_USE_INTERNAL_TIMER ) {
    global.__scribble_internal_time = current_time/1000;
    global.__scribble_time = global.__scribble_internal_time;
}