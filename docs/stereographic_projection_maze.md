# Stereographic projection maze

When I first saw the amazing [Stereographic projection](http://www.thingiverse.com/thing:202774), one of the challenges I setup is doing the stereographic projection with a self-generating maze. From then on, a year has passed and it's finally completed. 

The customizer will generate a different maze every time you run it. You may input different values for the `maze_rows` parameter. The sphere radius would be `block_width * maze_rows / 6`. What the `block_width` parameter means is each block's width in the maze shadow, so is `wall_width`. The `line_steps` parameter determines the smoothness of the sphere surface. A higher value would get a more smooth surface, however, more time for rendering a model.

If you want to print it, I recommend using a slicing software that you can add support structures manually because some overhangs can't be detected when generating automatic supports. Trying a maze with a smaller `maze_rows` would be a good start. Once it's printed successfully, you may challenge a bigger one. :)

Find all my mazes in the collection "[maze generators](http://www.thingiverse.com/JustinSDK/collections/maze-generator)".

![Stereographic projection maze](http://thingiverse-production-new.s3.amazonaws.com/renders/25/90/91/4f/48/02ff466eb0d40e37c2d21272ce2288c8_preview_featured.JPG)