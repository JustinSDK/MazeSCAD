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

module arc(radius, angles, width = 1, fn = 24) {
    difference() {
		sector(radius + width, angles, fn);
		sector(radius, angles, fn);
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

module sector(radius, angles, fn = 24) {
    d = radius - radius * cos(180 / fn);
	r = (radius + d) / cos(180 / fn);

	difference() {
	    circle(radius, $fn = fn);
		points = [for(a = [angles[0] : -360 / fn : angles[1] - 360]) 
		    [r * cos(a), r * sin(a)]
		];
		polygon(concat([[0, 0]], points));
	}
}

// The heart is composed of two semi-circles and two isosceles triangles. 
// The triangle's two equal sides have length equals to the double `radius` of the circle.
// That's why the `solid_heart` module is drawn according a `radius` parameter.
module solid_heart(radius, tip_factor) {
    offset_h = 2.2360679774997896964091736687313 * radius / 2 - radius * sin(45);
	tip_radius = radius / tip_factor;
	
    translate([radius * cos(45), offset_h, 0]) rotate([0, 0, -45])
    hull() {
        circle(radius, $fn = 96);
		translate([radius - tip_radius, -radius * 2 + tip_radius, 0]) 
		    circle(tip_radius, center = true, $fn = 96);
	}
	
	translate([-radius * cos(45), offset_h, 0]) rotate([0, 0, 45]) hull() {
        circle(radius, $fn = 96);
		translate([-radius + tip_radius, -radius * 2 + tip_radius, 0]) 
		    circle(tip_radius, center = true, $fn = 96);
	}
}

module ring_heart(radius, tip_factor, thickness) {
    difference() { 
	    offset(delta = thickness) solid_heart(radius, tip_factor);
        solid_heart(radius, tip_factor);
	}
}