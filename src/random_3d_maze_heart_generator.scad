use <2d.scad>;
use <3d.scad>;
use <random_maze_generator.scad>;
use <random_maze_heart_generator.scad>;

heart_thickness = 15;
heart_height = 30;
heart_layer_factor = 5; // 0 ~ 90
heart_tip_sharp_factor = 5; 
maze_cblocks = 6;
maze_levels = 3;
maze_wall_thickness = 1.5;
ring = "YES";	

module random_3d_maze_heart(heart_thickness, heart_height, heart_layer_factor, heart_tip_sharp_factor, maze_cblocks, maze_levels, maze_wall_thickness) {
	intersection() {
		eclipse_heart(heart_thickness / 2, heart_height / 3.12, heart_layer_factor, heart_tip_sharp_factor);
		translate([0, 0, -heart_height / 2]) 
			heart_maze(eclipse_y(heart_height / 3.12 - maze_wall_thickness, 0) , maze_cblocks, maze_levels, heart_tip_sharp_factor, heart_height, maze_wall_thickness);
	}
}

random_3d_maze_heart(heart_thickness, heart_height, heart_layer_factor, heart_tip_sharp_factor, maze_cblocks, maze_levels, maze_wall_thickness);

if(ring == "YES") {
	translate([0, heart_height / 3.12 - maze_wall_thickness * 1.25, -heart_thickness / 10]) 
	    linear_extrude(heart_thickness / 5) 
			arc(heart_height / 3.12 / 2, [45, 135], maze_wall_thickness);
}



