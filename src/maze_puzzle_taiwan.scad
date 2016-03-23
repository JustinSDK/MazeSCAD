use <2d.scad>;
use <random_maze_generator.scad>;
use <puzzle_generator.scad>;
use <polyhedrons.scad>;

width = 100;
// it should be a multiple of 2
puzzle_x_blocks = 4; 
// it should be a multiple of 2
maze_x_blocks = 20; 
ditch_width = 1;
spacing = 0.4;

module taiwan_with_a_square(width) {
    origin_width = 100;
	origin_length = 150;
	
	scale_factor = width / origin_width;
	
	scale([scale_factor, scale_factor, 1]) union() {
		//color("ForestGreen") 
		translate([13, 5, 0]) 
			scale([1, 1, 4]) 
				resize([0, origin_length - 10, 0], auto = true) 
					taiwan(1); //import("Taiwan.stl"); 
		//color("Gold") 
		linear_extrude(6) translate([59, 28 * 5, 0]) rotate(-110) text("TAIWAN", size = 20, font = "Showcard Gothic");
		//color("Aqua") 
		linear_extrude(2) square([origin_width, origin_length]); 
	}
}

module maze_puzzle_taiwan(width, puzzle_x_blocks, maze_x_blocks, ditch_width, spacing) {
    wall_height = 8;
	
	piece_side_length = width / puzzle_x_blocks;
	puzzle_y_blocks = puzzle_x_blocks * 1.5;
	maze_y_blocks = maze_x_blocks * 1.5;
	block_width = width / maze_x_blocks;

	maze_vector = go_maze(1, 1, maze_y_blocks, maze_x_blocks, 
	    replace([maze_x_blocks, maze_y_blocks, 0, UP_RIGHT_WALL()], 
		        [maze_x_blocks, maze_y_blocks, 0, UP_WALL()], 
				init_maze(maze_y_blocks, maze_x_blocks))
	);

	difference() { 
		intersection() {
			taiwan_with_a_square(width);
			linear_extrude(15) 
				 puzzle(puzzle_x_blocks, puzzle_y_blocks, piece_side_length, spacing);    		 
		}

		// maze
		translate([0, 0, ditch_width]) 
			linear_extrude(wall_height) 
				maze(maze_y_blocks, maze_x_blocks, maze_vector, block_width, ditch_width);
	}
}

maze_puzzle_taiwan(width, puzzle_x_blocks, maze_x_blocks, ditch_width, spacing);