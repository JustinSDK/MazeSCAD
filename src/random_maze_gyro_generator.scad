use <2d.scad>;
use <3d.scad>;
use <random_maze_generator.scad>;
use <random_maze_circle_generator.scad>;

radius = 20; 

spacing = 0.6;

wall_height = 1;
wall_thickness = 1.5;
cblocks = 25; 
rblocks = 4;

ring = "YES";

// a gyro base. Its height is equals to `radius`.
module gyro_base(radius) {
    double_radius = radius * 2;
	half_height = radius / 3;
	difference() {
		sphere(radius, $fn = 96);
		translate([0, 0, -radius - half_height]) 
		    cube(double_radius, center = true);
		translate([0, 0, radius + half_height]) 
		    cube(double_radius, center = true);
	}
}

// create mazes on two sides of the gyro base
module gyro_base_with_mazes(radius, cblocks, rblocks, wall_height = 1, wall_thickness = 1) {
    height = radius * 2 / 3;  

    r = sqrt(pow(radius, 2) - pow(height / 2, 2));
	

	difference() {
	    gyro_base(radius);
		
		translate([0, 0, height / 2 - wall_height])     
		    linear_extrude(wall_height) 
		         circle(r, $fn = 96);
				 
	    translate([0, 0, -height / 2])     
		    linear_extrude(wall_height) 
		         circle(r, $fn = 96);
	}
	
    translate([0, 0, height / 2 - wall_height]) 
        linear_extrude(wall_height) 
            circle_maze(r - wall_thickness, cblocks, rblocks, wall_thickness); 

    translate([0, 0, -height / 2 - wall_thickness / 2 + wall_height]) 
        linear_extrude(wall_height) 
            circle_maze(r - wall_thickness, cblocks, rblocks, wall_thickness); 
}

// use hollow spheres to cut out a space between each gyro circle
module maze_gyro(radius, cblocks, rblocks, ring = "YES", spacing = 0.6, wall_height = 1, wall_thickness = 1) {
    height = radius * 2 / 3;
    r = sqrt(pow(radius, 2) - pow(wall_height, 2));
	one_half_wall_thickness = 1.5 * wall_thickness;
    length_rblock = (r - one_half_wall_thickness) / rblocks;
	
	difference() {
		gyro_base_with_mazes(radius, cblocks, rblocks, wall_height, wall_thickness);
		
		for(i = [2 : rblocks]) { 
			r_hollow_sphere = sqrt(pow(length_rblock * (i - 1) + spacing * (rblocks - i + 3), 2) + pow(height / 2, 2));
			hollow_sphere(r_hollow_sphere, spacing);
		}
	}
	
	// ring
	if(ring == "YES") {
	    difference() {
	        translate([radius, 0, -height / 8]) rotate([0, 0, -90]) 
	            linear_extrude(height / 4) arc(length_rblock, [0, 360], height / 8);
			gyro_base(radius);
	    }
	}
}

maze_gyro(radius, cblocks, rblocks, ring, spacing, wall_height, wall_thickness);





