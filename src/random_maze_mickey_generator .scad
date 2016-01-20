use <2d.scad>;
use <random_maze_generator.scad>;
use <random_maze_circle_generator.scad>;

radius = 20; 

wall_height = 2;
wall_thickness = 1; 

cblocks = 15; 
rblocks = 5;

face_bottom = "YES";
ears_bottom = "YES";
   
module mickey_maze(radius, cblocks, rblocks, thickness = 1) {
    // face 
	difference() {   
		circle_maze(radius, cblocks, rblocks, wall_thickness);

		union() {
		    rotate([0, 0, 91])
				arc(radius - wall_thickness / 2, [0, 360 / cblocks], wall_thickness * 2);
			rotate([0, 0, -360 / cblocks - 2])
				arc(radius - wall_thickness / 2, [0, 360 / cblocks], wall_thickness * 2);
		}
	}
	
	ear_cblocks = 2 * (cblocks - cblocks % 3) / 3;
	
	// ear1
	translate([radius * 1.68, -radius * 0.275, 0])  
	    rotate([0, 0, 181.5]) 
		    circle_maze(radius / 1.5, ear_cblocks, rblocks, wall_thickness);
		
	// ear2
	translate([-radius * 0.275, radius * 1.68, 0])  
		rotate([0, 0, -67])  
			circle_maze(radius / 1.5, ear_cblocks, rblocks, wall_thickness);		
}

module mickey_maze_bottom(radius, cblocks, rblocks, thickness = 1, face_bottom = "YES", ears_bottom = "YES") {
    linear_extrude(wall_thickness) union() {
		if(face_bottom == "YES") {
			circle(radius + wall_thickness, $fn = 96);
		}
		
		// ears
		if(ears_bottom == "YES") {	
			translate([radius * 1.68, -radius * 0.275, 0])  
				circle(radius / 1.5 + wall_thickness, $fn = 96);
							
			translate([-radius * 0.275, radius * 1.68, 0])  
				circle(radius / 1.5 + wall_thickness, $fn = 96);									
		}
	}
}

if(face_bottom == "YES" || ears_bottom == "YES") {
	mickey_maze_bottom(radius, cblocks, rblocks, wall_thickness, face_bottom, ears_bottom);

	linear_extrude(wall_height + wall_thickness)
		mickey_maze(radius, cblocks, rblocks, wall_thickness);
} else {
	linear_extrude(wall_height)
		mickey_maze(radius, cblocks, rblocks, wall_thickness);
}