demo_string = "Contrary to popular belief, Lorem Ipsum is not simply random text.\n\nIt has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.\n\nRichard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet...\", comes from a line in section 1.10.32.";

width  = 450;
height = 150;

page = 0;
element = scribble(demo_string).wrap(width, height).page(page);