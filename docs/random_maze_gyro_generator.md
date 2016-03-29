# random_maze_gyro_generator.scad

[](https://www.youtube.com/watch?v=7Y0FvOO9MaM)

This is based on [Random maze circle generator](https://www.thingiverse.com/thing:1255574). You may change the following parameters to generate a maze gyro, different every time:

- `radius`
- `spacing`
- `wall_height`
- `wall_thickness`
- `cblocks`
- `rblocks`
- `ring`

You may roll it on 720 degrees. This may resemble new mazes on both sides. It always makes me think of a movie "Maze Runner".

To avoid overlapping between rings, you may try different values of the `spacing` parameter. The 0.6 mm `spacing` is suitable for my printer with 0.2 mm layer height and 0.6 mm Bottom/Top thickness. Although 0.6 mm `spacing` seems suitable for most situations, I think it's different for different 3DP, filaments and settings. That's why I makes  the `spacing` parameter changeable. 

![Random Maze Gyro Generator](http://thingiverse-production-new.s3.amazonaws.com/renders/b7/2f/f3/9a/52/ac43984895ec9ed930c645dc19fdeb55_preview_featured.jpg)