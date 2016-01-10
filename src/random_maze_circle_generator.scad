use <random_maze_generator.scad>;

radius = 40; 

wall_height = 2;
wall_thickness = 2; 

cblocks = 25; 
rblocks = 5;

bottom = "YES";

/* 
 * modules for creating a maze
 *
 */

function PI() = 3.14159;

module a_quarter_arc(radius, angle, width = 1) {
    outer = radius + width;
    intersection() {
        difference() {
            offset(r = width) circle(radius, $fn=96); 
            circle(radius, $fn=96);
        }
        polygon([[0, 0], [outer, 0], [outer, outer * sin(angle)], [outer * cos(angle), outer * sin(angle)]]);
    }
}

module arc(radius, angles, width = 1) {
    angle_from = angles[0];
    angle_to = angles[1];
    angle_difference = angle_to - angle_from;
    outer = radius + width;
    rotate(angle_from)
        if(angle_difference <= 90) {
            a_quarter_arc(radius, angle_difference, width);
        } else if(angle_difference > 90 && angle_difference <= 180) {
            arc(radius, [0, 90], width);
            rotate(90) a_quarter_arc(radius, angle_difference - 90, width);
        } else if(angle_difference > 180 && angle_difference <= 270) {
            arc(radius, [0, 180], width);
            rotate(180) a_quarter_arc(radius, angle_difference - 180, width);
        } else if(angle_difference > 270 && angle_difference <= 360) {
            arc(radius, [0, 270], width);
            rotate(270) a_quarter_arc(radius, angle_difference - 270, width);
       }
}

module x_line(point, length, thickness = 1) {
    offset = thickness / 2;
    translate([point[0] - offset, point[1] - offset, 0]) 
        square([length + thickness, thickness]);
}

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
	

 
 

