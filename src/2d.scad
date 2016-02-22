function PI() = 3.14159;

// give a [x, y] point and length. draw a line in the x direction
module x_line(point, length, thickness = 1) {
    offset = thickness / 2;
    translate([point[0] - offset, point[1] - offset, 0]) 
        square([length + thickness, thickness]);
}

// give a [x, y] point and length. draw a line in the y direction
module y_line(point, length, thickness = 1) {
    offset = thickness / 2;
    translate([point[0] - offset, point[1] - offset, 0])  
        square([thickness, length + thickness]);
}

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




// create a equilateral triangle
module equilateral_triangle(side_length, center = false) {
    radius = 0.57735026918962576450914878050196 * side_length;
	circle(r = radius, center = center, $fn = 3); 
}

// create a holly equilateral triangle
module holly_equilateral_triangle(side_length, thickness = 1, center = true) {
    difference() {
	    offset(delta = thickness) equilateral_triangle(side_length, center = center);
	    equilateral_triangle(side_length, center = center);
    }
}

module a_quarter_sector(radius, angle) {
    intersection() {
        circle(radius, $fn=96);
        
        polygon([[0, 0], [radius, 0], [radius, radius * sin(angle)], [radius * cos(angle), radius * sin(angle)]]);
    }
}

module sector(radius, angles) {
    angle_from = angles[0];
    angle_to = angles[1];
    angle_difference = angle_to - angle_from;

    rotate(angle_from)
        if(angle_difference <= 90) {
            a_quarter_sector(radius, angle_difference);
        } else if(angle_difference > 90 && angle_difference <= 180) {
            sector(radius, [0, 90]);
            rotate(90) a_quarter_sector(radius, angle_difference - 90);
        } else if(angle_difference > 180 && angle_difference <= 270) {
            sector(radius, [0, 180]);
            rotate(180) a_quarter_sector(radius, angle_difference - 180);
        } else if(angle_difference > 270 && angle_difference <= 360) {
            sector(radius, [0, 270]);
            rotate(270) a_quarter_sector(radius, angle_difference - 270);
       }
}

// The heart is composed of two semi-circles and two isosceles triangles. 
// The triangle's two equal sides have length equals to the double `radius` of the circle.
// That's why the `solid_heart` module is drawn according a `radius` parameter.
module solid_heart(radius) {
    offset_h = 2.2360679774997896964091736687313 * radius / 2 - radius * sin(45);

    translate([radius * cos(45), offset_h, 0]) rotate([0, 0, -45]) union() {
        sector(radius, [0, 180]);
		translate([0, -radius, 0]) square(radius * 2, center = true);
	}
	
	translate([-radius * cos(45), offset_h, 0]) rotate([0, 0, 45]) union() {
	    sector(radius, [0, 180]);
		translate([0, -radius, 0]) square(radius * 2, center = true);
	}
}

module ring_heart(radius, thickness) {
    difference() { 
	    offset(delta = thickness) solid_heart(radius);
        solid_heart(radius);
	}
}