element = scribble_unique("[pause]abc[pause]defghijklmnop")
.typist_options({ speed: 0.06, smoothness: 10 })
.typist_ease(SCRIBBLE_EASE_LINEAR, 0, -10, 1, 1, 0, 0)
.typist_start();