use <2d.scad>;

module hollow_sphere(radius, thickness = 1) {
    difference() {
	    sphere(radius + thickness, $fn = 96);
        sphere(radius, $fn = 96);
	}
}

function eclipse_y(inner_r, angle) = inner_r * cos(angle);
function eclipse_z(outer_r, angle) = outer_r * sin(angle);

module eclipse_heart_one_side(ellipse_inner_r, ellipse_outer_r, step, tip_factor) {
	for(angle = [0 : step : 90]) {
		heart_height = eclipse_y(ellipse_outer_r, angle) ;
		prev_heart_thickness = angle == 0 ? 0 : eclipse_z(ellipse_inner_r, angle - step); 
		
		linear_height = eclipse_z(ellipse_inner_r, angle) - prev_heart_thickness;
		linear_scale = eclipse_y(ellipse_outer_r, angle + step) / heart_height;
		
		translate([0, 0, prev_heart_thickness]) 
			linear_extrude(linear_height, scale = linear_scale) 
				solid_heart(heart_height, tip_factor);
	}
}

module eclipse_heart(ellipse_inner_r, ellipse_outer_r, step, tip_factor) {
	eclipse_heart_one_side(ellipse_inner_r, ellipse_outer_r, step, tip_factor);
	mirror([0, 0, 1]) eclipse_heart_one_side(ellipse_inner_r, ellipse_outer_r, step, tip_factor);
}
