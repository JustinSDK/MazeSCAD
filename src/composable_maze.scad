use <random_maze_generator.scad>;
use <puzzle_generator.scad>;

piece_side_length = 25;
piece_height = 2;
xs = 3;
ys = 3;
spacing = 0.4;

// Create a puzzle piece with a 7x7 maze.
//
// Parameters: 
//     side_length - the length of the piece.
module maze_for_puzzle(side_length) {
    circle_radius = side_length / 10;
	
	rows = 7; 
	columns = 7; 
	wall_thickness = side_length / 20;
	maze_length = side_length - circle_radius * 3;
	block_width = (maze_length - wall_thickness) / rows; 
	
	entry = [1, 4]; 
	exit = [7, 4];

	// maze
	maze_vector = go_maze(entry[0], entry[1], rows, columns, replace([exit[0], exit[1], 0, UP_RIGHT_WALL()], [exit[0], exit[1], 0, UP_WALL()], init_maze(rows, columns)));
	
	difference() {
		maze(rows, columns, maze_vector, block_width, wall_thickness);
		translate([-wall_thickness / 2, wall_thickness / 2 + 3 * block_width, 0]) 
		    square([wall_thickness, block_width - wall_thickness]);
	}
	
	translate([0, wall_thickness, 0]) 
	    square(wall_thickness, center = true);
}

// a sub module for  maze_in_puzzle_piece
module roads_to_next_piece(side_length) {
	maze_rows = 7;
	circle_radius = side_length / 10;
	maze_wall_thickness = side_length / 20;
	maze_length = side_length - circle_radius * 3;
	block_width = (maze_length - maze_wall_thickness) / maze_rows; 
	
	road_offset = circle_radius * 1.5 + block_width * 3 + maze_wall_thickness;
	
	translate([0, road_offset, 0]) 
	    square([circle_radius * 1.5, block_width - maze_wall_thickness]);
		
	translate([block_width * 9, road_offset, 0]) 
	    square([circle_radius * 1.5, block_width - maze_wall_thickness]);
		
	translate([road_offset, 0, 0]) 
	    square([block_width - maze_wall_thickness, circle_radius * 1.5 + maze_wall_thickness]);	
		
	translate([road_offset, block_width * 7 + circle_radius * 1.5, 0]) 
	    square([block_width - maze_wall_thickness, circle_radius * 1.5 + maze_wall_thickness]);			
}


// Create a piece of composable maze.
//
// Parameters: 
//     side_length - the length of the piece.
//     piece_height - total height of the piece	
//     spacing - a small space between pieces to avoid overlaping while printing.	
module composable_maze_piece(side_length, piece_height, spacing) {
    circle_radius = side_length / 10;
    road_width = side_length / 20;
	
	maze_wall_thickness = side_length / 20;
	
	color("white") linear_extrude(piece_height) difference() {
		union() {
			difference() {
				puzzle_piece(side_length, spacing);
				translate([circle_radius * 1.5, circle_radius * 1.5, 0]) square(side_length - circle_radius * 3);
			}
			
			translate([maze_wall_thickness * 0.5 + circle_radius * 1.5, maze_wall_thickness * 0.5 + circle_radius * 1.5, 0])  
				maze_for_puzzle(side_length);
		}
		
		roads_to_next_piece(side_length);
	}
	 
	color("black") linear_extrude(piece_height / 2) puzzle_piece(side_length, spacing);
}	


// Create a composable maze.
//
// Parameters: 
//     xs - the amount of pieces in x direction.
//     ys - the amount of pieces in y direction.
//     piece_side_length - the length of a piece.
//     spacing - a small space between pieces to avoid overlaping while printing.
module composable_maze(xs, ys, piece_side_length, spacing) {
	for(x = [0 : xs - 1]) {
		for(y = [0 : ys - 1]) {
				translate([piece_side_length * x, piece_side_length * y, 0]) 
					composable_maze_piece(piece_side_length, piece_height, spacing);
			}
	}
}

composable_maze(xs, ys, piece_side_length, spacing);
	