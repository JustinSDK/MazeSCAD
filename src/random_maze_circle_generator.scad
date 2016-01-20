use <2d.scad>;
use <random_maze_generator.scad>;

radius = 40; 

wall_height = 2;
wall_thickness = 2; 

cblocks = 25; 
rblocks = 5;

bottom = "YES";

module circle_maze(radius, cblocks, rblocks, thickness = 1) {
    full_circle_angle = 360;
    arc_angle = full_circle_angle / cblocks;
	length_rblock = radius / rblocks ;
	rows = rblocks - 2;
	
	maze = go_maze(1, 1, cblocks, rows, replace([rows, cblocks, 0, UP_RIGHT_WALL()], [rows, cblocks, 0, UP_WALL()], init_maze(cblocks, rows)));
	
	// inner circle
	rotate([0, 0, 180]) 
	    arc(length_rblock, [0, full_circle_angle - arc_angle], thickness);		
		
	rotate([0, 0, 315]) 	
	    x_line([length_rblock + thickness / 2, 0], length_rblock, thickness); 
		
	rotate([0, 0, arc_angle]) 
	    arc(length_rblock * 2, [0, full_circle_angle - arc_angle], thickness);
	
	// maze
    for(i = [0:len(maze) - 1]) { 
        cord = maze[i];
		cr = cord[0] + 2; 
		cc = cord[1] - 1;
        v = cord[3];
        
        if(v == 1 || v == 3) {
		    rotate([0, 0, cc * arc_angle])
                x_line([(cr - 1)* length_rblock + thickness / 2, 0], length_rblock, thickness); 
        }
        if(v == 2 || v == 3) {
		    rotate([0, 0, cc * arc_angle])
		        arc(cr * length_rblock, [0, arc_angle + 0.01], thickness);
        } 
		
		if(v == 0 || v == 1) {
		    r1 = length_rblock * 2;
			r2 = cr * length_rblock;
		    rotate([0, 0, cc * arc_angle])
		        arc(cr * length_rblock, [0, arc_angle * (r2 - r1) / r2], thickness);
		}
    }  	
}

if(bottom == "YES") {
	linear_extrude(wall_height + wall_thickness) 
		circle_maze(radius, cblocks, rblocks, wall_thickness);
		
	linear_extrude(wall_thickness) 
		circle(radius, $fn = 96);
} else {
	linear_extrude(wall_height) 
		circle_maze(radius, cblocks, rblocks, wall_thickness);
}
	
	

 
 

