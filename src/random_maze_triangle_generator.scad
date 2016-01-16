use <2d.scad>;
use <random_maze_generator.scad>;

side_length = 50; 

wall_thickness = 1;
wall_height = 2;

cblocks = 10;  
levels = 5; 

// Given a side length of a equilateral triangle, return the length of incenter to vertex.
function triangle_incenter_to_vertex_length(triangle_side_length) = 0.57735026918962576450914878050196 * triangle_side_length;

// used by `sector_cutter` module. Accepted angle is from 0 to 90 degree.
module a_quarter_sector_cutter(radius, angle) {
    outer = radius;
    polygon([[0, 0], [outer, 0], [outer, outer * sin(angle)], [outer * cos(angle), outer * sin(angle)]]);
}

// userd by `holly_equilateral_triangle_sector` for difference
module sector_cutter(radius, angles) {
    angle_from = angles[0];
    angle_to = angles[1];
    angle_difference = angle_to - angle_from;
    
    rotate(angle_from)
        if(angle_difference <= 90) {
            a_quarter_sector_cutter(radius, angle_difference);
        } else if(angle_difference > 90 && angle_difference <= 180) {
            sector_cutter(radius, [0, 90]);
            rotate(90) a_quarter_sector_cutter(radius, angle_difference - 90);
        } else if(angle_difference > 180 && angle_difference <= 270) {
            sector_cutter(radius, [0, 180]);
            rotate(180) a_quarter_sector_cutter(radius, angle_difference - 180);
        } else if(angle_difference > 270 && angle_difference <= 360) {
            sector_cutter(radius, [0, 270]);
            rotate(270) a_quarter_sector_cutter(radius, angle_difference - 270);
       }
}

// For a triangle, a different angle has a different length from incenter to its side.
function triangle_incenter_to_side_length(incenter_to_vertex_length, angle) = 
    (angle >= 0 && angle <= 60) ? 0.5 * incenter_to_vertex_length / cos(angle) : (
	    (angle > 60 && angle <= 120) ? triangle_incenter_to_side_length(incenter_to_vertex_length, 120 - angle) : triangle_incenter_to_side_length(incenter_to_vertex_length, angle - 120)
	);

// draw a line from incenter to side for a equilateral triangle
module triangle_incenter_to_side_line(side_length, angle, incenter_to_side_blocks, level, thickness = 1) {
    block_length = triangle_incenter_to_side_length(triangle_incenter_to_vertex_length(side_length), angle + 60) / incenter_to_side_blocks ;
	
	rotate([0, 0, angle]) 
	    translate([block_length * (level - 1) + thickness, 0, 0])
		    x_line([0, 0], block_length - thickness / 2, thickness);
}

// draw a side between `angles[0]` and `angles[1]`
module holly_equilateral_triangle_sector(side_length, angles, thickness = 1) {
	intersection() {
        holly_equilateral_triangle(side_length, thickness);
	    sector_cutter(triangle_incenter_to_vertex_length(side_length) + thickness * 2, [angles[0], angles[1]]);
	}
}

module triangle_maze(side_length, cblocks, levels, thickness = 1) {
    full_circle_angle = 360;
    arc_angle = full_circle_angle / cblocks;
	incenter_to_side_blocks = levels - 2;
	
	divided_side_length = side_length / levels;
	
	maze = go_maze(1, 1, cblocks, incenter_to_side_blocks, replace([incenter_to_side_blocks, cblocks, 0, UP_RIGHT_WALL()], [incenter_to_side_blocks, cblocks, 0, UP_WALL()], init_maze(cblocks, incenter_to_side_blocks)));
	  
	// maze
    for(i = [0:len(maze) - 1]) { 
        cord = maze[i];
		cr = cord[0]; 
		cc = cord[1] - 1;    
        v = cord[3];
        
		angle = cc * arc_angle;
		
        if(v == 1 || v == 3) {
			triangle_incenter_to_side_line(side_length, angle, levels, cr + 2, thickness);
        } 
		
        if(v == 2 || v == 3) {
		    sl = divided_side_length * (cr + 2);
			offset_angle = angle - arc_angle / 18;
			
			holly_equilateral_triangle_sector(sl, [offset_angle,  offset_angle + arc_angle], thickness);   
        } 
		
		if(v == 0 || v == 1) {
		    sl = divided_side_length * (cr + 2);		
			factor = abs((arc_angle * (cc + 1)) % 120 - 60) / 60; 
			offset_angle = angle - arc_angle / 18;
			
			holly_equilateral_triangle_sector(sl, [offset_angle, offset_angle + arc_angle * (sl - divided_side_length + factor) / (sl - factor * (cr + 2))], thickness);    
		}		
	}
	
	// inner triangle
	rotate([0, 0, 240]) 
		holly_equilateral_triangle_sector(divided_side_length, [-45, 315 - arc_angle], thickness);
	
	triangle_incenter_to_side_line(side_length, 300, levels, 2, thickness = 1);

	holly_equilateral_triangle_sector(divided_side_length * 2, [arc_angle / 4, 360], thickness);
}

linear_extrude(wall_height) 
    triangle_maze(side_length, cblocks, levels, wall_thickness);




