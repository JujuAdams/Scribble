element = scribble_unique("Here's some text that dynamically repositions as it is typed in!")
.max_size(150)
.layout_wrap()
.align(fa_center)
.typist_options({ speed: 0.1, smoothness: 2, dynamicPositioning: true, dynamicPositioningSmooth: true })
.typist_start();