use <2d.scad>;
use <3d.scad>;
use <random_maze_generator.scad>;
use <random_maze_cylinder_generator.scad>;

radius = 25; 
vertical_blocks = 10;
horizontal_blocks = 15;
wall_height = 1;
wall_thickness = 2;

arm_and_base = "YES";
simple_support_on_the_top = "YES";

module maze_sphere(radius, vertical_blocks, horizontal_blocks, wall_height = 1, wall_thickness = 1) {
    maze_vector = go_maze(1, 1, vertical_blocks, horizontal_blocks, replace([horizontal_blocks, 1, 0, UP_RIGHT_WALL()], [horizontal_blocks, 1, 0, UP_WALL()], init_maze(vertical_blocks, horizontal_blocks)));
	
    translate([0, 0, -radius]) sphere(radius, $fn = 96);

    intersection() {
        maze_cylinder([radius / 2.5, radius * 2 + wall_thickness], [vertical_blocks, horizontal_blocks], maze_vector, wall_thickness, radius);
	
        translate([0, 0, -radius])
    	    hollow_sphere(radius - wall_height, wall_height * 2);
    } 
} 

module maze_globe(radius, vertical_blocks, horizontal_blocks, wall_height = 1, wall_thickness = 2) {
    radius_x_2 = radius * 2;
	radius_div_6 = radius / 6;
	wall_thickness_x_2 = wall_thickness * 2;
	wall_thickness_x_9 = wall_thickness * 9;

	maze_sphere(radius, vertical_blocks, horizontal_blocks, wall_height, wall_thickness);

	// axis
	
	translate([0, 0, -wall_thickness])  
		cylinder(r = radius / 8, h = wall_thickness * 4, $fn = 96);
		
    translate([0, 0, -radius_x_2 - wall_thickness_x_9]) 
		cylinder(r = radius / 8, h = wall_thickness_x_9, $fn = 96);
		

	// arm
	
	translate([0, 0, wall_thickness]) 
		linear_extrude(wall_thickness_x_2) 
			arc(radius_div_6, [0, 360], wall_thickness);
		
	translate([0, 0, -radius_x_2 - wall_thickness * 6]) 
		linear_extrude(wall_thickness * 5) 
			arc(radius_div_6, [0, 360], wall_thickness);
			
	translate([-wall_thickness / 2, radius / 5, -radius]) 
	    rotate([0, 90, 0])
		    linear_extrude(wall_thickness) 
			    arc(radius + wall_thickness, [0, 180], wall_thickness_x_2);

    // base
    
	difference() {
	    union() {
	        translate([0, 0, -radius_x_2 - wall_thickness * 7]) 
	    	    cylinder(r = radius / 2, h = wall_thickness_x_2, $fn = 96);

	        translate([0, 0, -radius_x_2 - wall_thickness_x_9]) 
		        cylinder(r = radius, h = wall_thickness_x_2, $fn = 96);	
		}
		translate([0, 0, -radius_x_2 - wall_thickness * 10]) 
		cylinder(r = radius_div_6, h = wall_thickness * 5, $fn = 96);
	}
		
    
}

module support_for_maze_globe(radius, wall_thickness = 2) {
    radius_div_6 = radius / 6;
	wall_thickness_div_2 = wall_thickness / 2;
	offset = radius_div_6 + wall_thickness_div_2;
	
	translate([offset, 0, 0]) 
    linear_extrude(2) square([wall_thickness, wall_thickness_div_2], center = true);

    translate([-offset, 0, 0]) 
        linear_extrude(2) square([wall_thickness, wall_thickness / 2], center = true);

    translate([0, -offset, 0]) 
        linear_extrude(2) square([wall_thickness_div_2, wall_thickness], center = true);

    translate([0, offset, 0]) 
        linear_extrude(2) square([wall_thickness_div_2, wall_thickness], center = true);
}

if(arm_and_base == "YES") {
    maze_globe(radius, vertical_blocks, horizontal_blocks, wall_height, wall_thickness);
	
	if(simple_support_on_the_top == "YES") {
	    support_for_maze_globe(radius, wall_thickness);
        rotate(45) support_for_maze_globe(radius, wall_thickness); 
	}
} else {
    maze_sphere(radius, vertical_blocks, horizontal_blocks, wall_height, wall_thickness);
}


