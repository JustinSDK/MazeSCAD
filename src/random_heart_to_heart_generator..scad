use <2d.scad>;
use <random_maze_generator.scad>;

name_for_you = "Justin";
name_for_me = "Monica";
heart_height = 30;
wall_thickness = 1.5;
wall_height = 2;
cblocks = 7;
levels = 3;
tip_factor = 15;
spacing = 0.4;
ring = "YES";  

module ring_heart_sector(radius, angle, tip_factor, thickness, width) {
	intersection() {
		ring_heart(radius - 0.1, tip_factor, thickness + 0.2);
		rotate([0, 0, angle]) x_line([0, 0], radius * 3, width);
	}
}

module heart_to_heart_wall(radius, length, angle, tip_factor, thickness) {
    intersection() {
        difference() {
            solid_heart(radius + length, tip_factor);
		    solid_heart(radius, tip_factor);
	    }
	    rotate([0, 0, angle]) 
		    x_line([0, 0], (radius + length) * 2, thickness);
	}
}

module heart_to_heart_maze(maze, radius, cblocks, levels, tip_factor, height = 1, thickness = 1, spacing = 0) {
    full_circle_angle = 360;
    arc_angle = full_circle_angle / cblocks;
	r = radius / (levels + 1);
	
	difference() {
		linear_extrude(height) union() {
			for(i = [1 : levels + 1]) {
				ring_heart(r * i - spacing, tip_factor, thickness + spacing * 2);
			}
		  
		  
			for(i = [0:len(maze) - 1]) { 
				cord = maze[i];
				cr = cord[0]; 
				cc = cord[1] - 1;    
				v = cord[3];
				
				angle = cc * arc_angle;
				 
				if(v == 1 || v == 3) { 
					heart_to_heart_wall(r * cr - spacing, r, cc * arc_angle + 90, tip_factor, thickness + spacing * 2);
				} 
			}
	    }
		
		linear_extrude(height) union() {
		    // maze entry
		    ring_heart_sector(r - spacing, 1.5 * arc_angle + 90, tip_factor, thickness + spacing * 2, r - thickness / 2 - spacing * 2);

	        // road to the next level
			for(i = [0:len(maze) - 1]) { 
				cord = maze[i];
				cr = cord[0]; 
				cc = cord[1] - 1;    
				v = cord[3];
				
				if(v == 0 || v == 1) {
					ring_heart_sector(r * (cr + 1) - spacing, (cc + 0.5) * arc_angle + 90, tip_factor, thickness + spacing * 2, r - thickness / 2 - spacing * 2);
				}  
			}
		}
	}
}

module heart_to_heart_maze_you(maze, radius, cblocks, levels, tip_factor, height = 1, thickness = 1) {
	translate([0, 0, wall_height]) 
		heart_to_heart_maze(maze, radius, cblocks, levels, tip_factor, wall_height, wall_thickness, 0);
	linear_extrude(wall_height) 
		offset(delta = wall_thickness) 
			solid_heart(radius, tip_factor, wall_thickness);
}

module heart_to_heart_maze_me(maze, radius, cblocks, levels, tip_factor, height = 1, thickness = 1, spacing = 0.6) {
	translate([0, 0, wall_height]) mirror([1, 0, 0]) union() {
		difference() {
			linear_extrude(wall_height) solid_heart(radius, tip_factor, wall_thickness);
			heart_to_heart_maze(maze, radius, cblocks, levels, tip_factor, wall_height, wall_thickness, spacing);
		}
	}
	linear_extrude(wall_height) 
		offset(delta = wall_thickness) 
			solid_heart(radius, tip_factor, wall_thickness);
}

maze = go_maze(1, 1, cblocks, levels, replace([levels, cblocks - 1, 0, UP_RIGHT_WALL()], [levels, cblocks - 1, 0, UP_WALL()], init_maze(cblocks, levels)));

difference() {	
    heart_to_heart_maze_you(maze, heart_height / 3.12,
	cblocks, levels, tip_factor, wall_height, wall_thickness);
    
    linear_extrude(wall_height / 2) 
	    mirror([1, 0, 0]) 
		    text(name_for_you, font = "Courier New:style=Bold", valign = "center", halign = "center", size = heart_height / (len(name_for_you) + 1) + 1);	
}

translate([1.5 * heart_height, 0, 0]) difference() {
	heart_to_heart_maze_me(maze, heart_height / 3.12, cblocks, levels, tip_factor, wall_height, wall_thickness, spacing);
	
    linear_extrude(wall_height / 2) 
	    mirror([1, 0, 0]) 
		    text(name_for_me, font = "Courier New:style=Bold", valign = "center", halign = "center", size = heart_height / (len(name_for_me) + 1) + 1);	
}

if(ring == "YES") {
	translate([0, heart_height / 3.12 + wall_thickness / 2, 0]) 
		linear_extrude(wall_height) 
			arc(heart_height / 3.12 / 2, [45, 135], wall_thickness);
			
	translate([1.5 * heart_height, heart_height / 3.12 + wall_thickness / 2, 0]) 
		linear_extrude(wall_height) 
			arc(heart_height / 3.12 / 2, [45, 135], wall_thickness);			
}

