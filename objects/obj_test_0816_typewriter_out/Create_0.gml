typist = scribble_typist_legacy();
typist.TypeIn(1, 10);

element = scribble("When text is fading out but still visible the function GetTypeState() returns value 2.0,[/page]which should be smaller than 2.0 according to Scribble Docs?")
          .layout_wrap(400)
          .align(fa_center, fa_middle);