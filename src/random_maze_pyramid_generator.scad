use <2d.scad>;
use <random_maze_generator.scad>;
use <random_maze_triangle_generator.scad>;

side_length = 50; 
wall_thickness = 1;
wall_height = 2; 

cblocks = 9;  
levels = 5; 

ring = "YES";

// a maze triangle, but with two doors near two vertices 
module triangle_maze_for_pyramid(side_length, cblocks, levels, wall_thickness = 1) {
	arc_angle = 360 / cblocks;
	divided_side_length = side_length / levels;

	offset_angle = arc_angle - arc_angle * (side_length - divided_side_length + 1) / (side_length - levels + 2);
	
	difference() {		
		triangle_maze(side_length, cblocks, levels, wall_thickness);
		holly_equilateral_triangle_sector(side_length, [120, 120 + offset_angle + 0.5], wall_thickness);
		holly_equilateral_triangle_sector(side_length, [360 - offset_angle, 360], wall_thickness);
	}
}

// a maze triangle with two doors and tilted 54.5 degrees, for matching one side of a pyramid
module tilted_triangle_maze_for_pyramid(side_length, cblocks, levels, wall_height, wall_thickness = 1) {
	incenter_to_vertex_length = triangle_incenter_to_vertex_length(side_length);
	offset = incenter_to_vertex_length / 2 + wall_thickness;
	offset_angle = 54.5;
	
	translate([0, - side_length / 2 - wall_thickness * 1.6, 0]) 
	    rotate([offset_angle, 0, 0]) 
		    translate([0, offset , 0]) 
			    rotate([0, 0, 210]) 
				    linear_extrude(wall_height) 
		                triangle_maze_for_pyramid(side_length, cblocks, levels, wall_thickness);
}

// tilted triangle mazes facing each other
module two_rotated_triangle_mazes_for_pyramid(side_length, cblocks, levels, wall_height, wall_thickness = 1) {
	tilted_triangle_maze_for_pyramid(side_length, cblocks, levels, wall_height, wall_thickness);
	mirror([0, 1, 0]) 
	    tilted_triangle_maze_for_pyramid(side_length, cblocks, levels, wall_height, wall_thickness);
}

module maze_pyramid(side_length, cblocks, levels, wall_height, wall_thickness = 1) {
	incenter_to_vertex_length = triangle_incenter_to_vertex_length(side_length);

	l = 0.78 * side_length;

	rotate([0, 0, 45]) 
	    cylinder(r1 = l, r2 = 0, h = l, $fn = 4);

	two_rotated_triangle_mazes_for_pyramid(side_length, cblocks, levels, wall_height, wall_thickness);

	rotate([0, 0, 90]) 
	    two_rotated_triangle_mazes_for_pyramid(side_length, cblocks, levels, wall_height, wall_thickness);
}


maze_pyramid(side_length, cblocks, levels, wall_height, wall_thickness);

if(ring == "YES") {
	translate([0, 0, 0]) rotate([90, 0, 0]) rotate_extrude(convexity = 10, $fn = 48)
		translate([side_length / 8, 0, 0])
			circle(r = side_length / 22, $fn = 48);
}