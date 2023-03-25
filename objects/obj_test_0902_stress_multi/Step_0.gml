if (fps_real > 60)
{
    draw_count++;
}
else if (fps < 58)
{
    draw_count -= 0.1;
}