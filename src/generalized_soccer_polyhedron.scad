height = 50; 
spacing = 0.5;

// create a generalized pentagon by length.
// Parameters:
//     length : the side length
//     spacing : the gap between a pentagon or a hexagon
module generalized_pentagon(length, spacing = 0.5) {
    r = 0.5 * length / sin(36);
	s = (r - spacing / 2) / r;

    color("black") 
	    rotate(18) 		     
		     linear_extrude(length, scale = 1.42215)
		        scale([s, s, s])
			        children(); 
}

// create a generalized hexagon by length.
// Parameters:
//     length : the side length
//     spacing : the gap between a pentagon or a hexagon
module generalized_hexagon(length, spacing = 0.5) {
    r = 0.5 * length / sin(30);
	s = (r - spacing / 2) / r;

    color("white") 
	     linear_extrude(length - length * 0.02125, scale = 1.42215) 
		    scale([s, s, s])			
		        children();
}

// a placeholder pentagon, one generalized pentagon and two generalized hexagons.
// Parameters:
//     length : the side length
//     spacing : the gap between the pentagon and hexagon
module generalized_pentagon_based_sub_comp(length, spacing = 0.5) {
	pentagon_circle_r = 0.5 * length / sin(36);
	
	a = 37.325;
	
	offset_y = 0.5 * length * tan(54) + pentagon_circle_r * cos(a);
	offset_z = 0.5 * length * tan(60) * sin(a);
	
	translate([0, -offset_y, -offset_z]) 
	    rotate([a, 0, 0]) 
		    generalized_hexagon_based_sub_comp(length, spacing) {
			    children(0); 
				children(1); 
			}
}

// two generalized hexagons and one generalized pentagon.
// Parameters:
//     length : the side length
//     spacing : the gap between the pentagon and hexagon
module generalized_hexagon_based_sub_comp(length, spacing = 0.5) {
    children(1); 
	
	length_center_to_side = 0.5 * length * tan(54);
	
    a = -37.325;
	
	offset_y = 0.5 * length * (tan(54) * cos(a) + tan(60));
	offset_z = length_center_to_side * sin(a);
	
	rotate(120) translate([0, offset_y, offset_z]) 
	    rotate([a, 0, 0]) 
	        generalized_pentagon_hexagon(length, spacing) {
			    children(0);
			    children(1);
			}
			
}

// a generalized pentagon and a generalized hexagon.
// Parameters:
//     length : the side length
//     spacing : the gap between the pentagon and hexagon
module generalized_pentagon_hexagon(length, spacing = 0.5) {
	pentagon_circle_r = 0.5 * length / sin(36);
	
	children(0); 
	
	a = 37.325;
	
	offset_y = 0.5 * length * tan(54) + pentagon_circle_r * cos(a);
	offset_z = 0.5 * length * tan(60) * sin(a);
	
	rotate(144) translate([0, -offset_y, -offset_z]) 
	    rotate([a, 0, 0]) 
		    children(1); 
}

// a half of generalized soccer polyhedron.
// Parameters:
//     line_length : the side length of pentagons and hexagons
//     spacing : the gap between the pentagon and hexagon
module generalized_half_soccer_polyhedron(line_length, spacing = 0.5) {
	pentagon_circle_r = 0.5 * line_length / sin(36);
	offset_y = pentagon_circle_r * cos(36);

	children(0);
	
	for(i = [0:4]) {
		rotate(72 * i) 
		    generalized_pentagon_based_sub_comp(line_length, spacing) {
			    children(0);
				children(1);
			}
	}
}

// a generalized soccer polyhedron.
// Parameters:
//     line_length : the side length of pentagons and hexagons
//     spacing : the gap between the pentagon and hexagon
//     center : center it or not
module generalized_soccer_polyhedron(height, spacing = 0.5, center = true) {
    line_length = height / 6.65;
	
	offset_for_center = center ? height / 2: 0;
	
	translate([0, 0, -offset_for_center]) union() {
		translate([0, 0, -line_length + line_length * 6.64875]) 
		    generalized_half_soccer_polyhedron(line_length, spacing) {
			    generalized_pentagon(line_length, spacing) children(0);
			    generalized_hexagon(line_length, spacing) children(1);			
			}
			
		rotate(36) mirror([0, 0, 1]) translate([0, 0, -line_length]) 
		    generalized_half_soccer_polyhedron(line_length, spacing) {
			    generalized_pentagon(line_length, spacing) children(0);
			    generalized_hexagon(line_length, spacing) children(1);				
			}
	}
}

// create a pentagon according the height of the soccer polyhedron
module pentagon_for_soccer_polyhedron(height) {
    line_length = height / 6.65;
    circle(0.5 * line_length / sin(36), $fn = 5);
}

// create a hexagon according the height of the soccer polyhedron
module hexagon_for_soccer_polyhedron(height) {
    line_length = height / 6.65;
    circle(0.5 * line_length / sin(30), $fn = 6);			
}

generalized_soccer_polyhedron(height, spacing) {
    pentagon_for_soccer_polyhedron(height); 
	 hexagon_for_soccer_polyhedron(height);
}
