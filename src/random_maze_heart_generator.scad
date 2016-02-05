use <2d.scad>;
use <random_maze_generator.scad>;

heart_height = 30;
wall_thickness = 1.4;
wall_height = 1;
cblocks = 10;
levels = 3;
bottom = "YES";
ring = "YES"; 

module ring_heart_sector(radius, angle, thickness) {
	intersection() {
		ring_heart(radius - 0.1, thickness + 0.2);
		rotate([0, 0, angle]) x_line([0, 0], radius * 3, thickness);
	}
}

module heart_to_heart_wall(radius, length, angle, thickness) {
    intersection() {
        difference() {
            solid_heart(radius + length);
		    solid_heart(radius);
	    }
	    rotate([0, 0, angle]) 
		    x_line([0, 0], (radius + length) * 2, thickness);
	}
}

module heart_maze(radius, cblocks, levels, height = 1, thickness = 1) {
    full_circle_angle = 360;
    arc_angle = full_circle_angle / cblocks;
	r = radius / (levels + 1);
	
	maze = go_maze(1, 1, cblocks, levels, replace([levels, cblocks - 1, 0, UP_RIGHT_WALL()], [levels, cblocks - 1, 0, UP_WALL()], init_maze(cblocks, levels)));
	
	
	difference() {
		linear_extrude(height) union() {
			for(i = [1 : levels + 1]) {
				ring_heart(r * i, thickness);
			}
		  
		  
			for(i = [0:len(maze) - 1]) { 
				cord = maze[i];
				cr = cord[0]; 
				cc = cord[1] - 1;    
				v = cord[3];
				
				angle = cc * arc_angle;
				 
				if(v == 1 || v == 3) { 
					heart_to_heart_wall(r * cr, r, cc * arc_angle + 90, thickness);
				} 
			}
	    }
		
		
		linear_extrude(height) union() {
		    // maze entry
		    #ring_heart_sector(r, 1.5 * arc_angle + 90, thickness);

	        // road to the next level
			for(i = [0:len(maze) - 1]) { 
				cord = maze[i];
				cr = cord[0]; 
				cc = cord[1] - 1;    
				v = cord[3];
				
				if(v == 0 || v == 1) {
					ring_heart_sector(r * (cr + 1), (cc + 0.5) * arc_angle + 90, thickness);
				}  
			}
		}
	}
}

heart_maze(heart_height / 3.12, cblocks, levels, wall_height, wall_thickness);

if(bottom == "YES") {
    translate([0, 0, -wall_thickness]) 
	    linear_extrude(wall_thickness) 
		    offset(delta = wall_thickness) 
			    solid_heart(heart_height / 3.12);
}

if(ring == "YES") {
    if(bottom == "YES")  {
	    translate([0, heart_height / 3.12 +  wall_thickness / 2, -wall_thickness / 2]) 
			linear_extrude(wall_height) 
				arc(heart_height / 3.12 / 2, [45, 135], wall_thickness);
	} else {
	    translate([0, heart_height / 3.12 + wall_thickness / 2, 0]) 
			linear_extrude(wall_height) 
				arc(heart_height / 3.12 / 2, [45, 135], wall_thickness);
	}
}