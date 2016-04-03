use <2d.scad>;
use <puzzle_generator.scad>;
use <image_to_puzzle.scad>;
use <random_maze_generator.scad>;

// png: 100x100 pixels
filename = "caterpillar.png";  // [image_surface:100x100]
width = 100;
puzzle_x_blocks = 4; 
maze_x_blocks = 10;  
ditch_width = 1;
spacing = 0.4;

module image_to_maze_puzzle(filename, width, puzzle_x_blocks, maze_x_blocks, ditch_width, spacing) {
    wall_height = 8;
	       
	piece_side_length = width / puzzle_x_blocks;
	puzzle_y_blocks = puzzle_x_blocks;
	maze_y_blocks = maze_x_blocks;
	block_width = width / maze_x_blocks;

	maze_vector = go_maze(1, 1, maze_y_blocks, maze_x_blocks, 
	    replace([maze_x_blocks, maze_y_blocks, 0, UP_RIGHT_WALL()], 
		        [maze_x_blocks, maze_y_blocks, 0, UP_WALL()], 
				init_maze(maze_y_blocks, maze_x_blocks))
	);

	difference() { 
		intersection() {
			image_to_surface(filename, width);
			linear_extrude(15) 
				 puzzle(puzzle_x_blocks, puzzle_y_blocks, piece_side_length, spacing);    		 
		}
 
		// maze
		translate([0, 0, ditch_width]) 
			linear_extrude(wall_height) 
				maze(maze_y_blocks, maze_x_blocks, maze_vector, block_width, ditch_width);
	}
}
 
image_to_maze_puzzle(filename, width, puzzle_x_blocks, maze_x_blocks, ditch_width, spacing);
