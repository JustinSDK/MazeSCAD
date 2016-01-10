module hollow_sphere(radius, thickness = 1) {
    difference() {
	    sphere(radius + thickness, $fn = 96);
        sphere(radius, $fn = 96);
	}
}