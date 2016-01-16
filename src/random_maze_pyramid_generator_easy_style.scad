square_block = 15; 
wall_thickness = 1;
block_width = 2;

use <2d.scad>;
use <random_maze_generator.scad>;

module maze_pyramid(square_block, block_width = 2, wall_thickness = 1) {

	maze_vector = go_maze(1, 1, square_block, square_block, replace([square_block, square_block, 0, UP_RIGHT_WALL()], [square_block, square_block, 0, UP_WALL()], init_maze(square_block, square_block)));

	diameter = square_block * block_width / 1.4142135623730950488016887242097 + wall_thickness * 2;
	
	half_wall_thickness = wall_thickness / 2;
	
	offset = square_block * block_width / 2;
	
	intersection() {
		linear_extrude(diameter) 
			maze(square_block, square_block, maze_vector, block_width, wall_thickness);

		translate([offset, offset, 0])     
			rotate([0, 0, 45]) 
				cylinder(diameter, diameter, 0, $fn=4);
	}

	translate([-half_wall_thickness, -half_wall_thickness, 0])     
	    linear_extrude(wall_thickness) 
		    square(square_block * block_width + wall_thickness);

}
	
maze_pyramid(square_block, block_width, wall_thickness);