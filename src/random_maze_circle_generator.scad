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
	length_rblock = radius / (rblocks + 2);
	
	maze = go_maze(1, 1, cblocks, rblocks, replace([rblocks, cblocks, 0, UP_RIGHT_WALL()], [rblocks, cblocks, 0, UP_WALL()], init_maze(cblocks, rblocks)));
	
	// inner circle
	rotate([0, 0, 180]) 
	    arc(length_rblock, [0, full_circle_angle - arc_angle * 2], thickness);		
		
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
		        arc(cr * length_rblock, [0, arc_angle], thickness);
        }
    }  	
}

if(bottom == "YES")	{
	linear_extrude(wall_thickness)
	    circle(radius + wall_thickness, $fn = 96);		
}

linear_extrude(wall_height + wall_thickness) 
    circle_maze(radius, cblocks, rblocks, wall_thickness);
	

 
 

