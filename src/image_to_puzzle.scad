use <puzzle_generator.scad>;

// png: 100x100 pixels
filename = "caterpillar.png";  // [image_surface:100x100]
width = 100;
x_blocks = 3; 
spacing = 0.4;

// Create a smile face in a circle.
//
// Parameters: 
//     radius - the radius of the circle
module smile_face(radius) {
	difference() {
		circle(radius);
		translate([radius / 3, radius / 3, 0]) circle(radius / 8);
		translate([-radius / 3, radius / 3, 0]) circle(radius / 8);
		difference() {
			translate([0, -radius / 5, 0]) circle(radius / 2);
			translate([0, radius / 3, 0]) square(radius, center = true);
		}
	}
}

// Load a png file and use the `surface` module to create a model.
// If `filename` is a empty string, it will create a smile face.
// The png file should be 100x100 pixels.
// 
// Parameters: 
//     filename - the png file.
//     width - the width of the image.
module image_to_surface(filename, width) {
    $fn = 48;
    origin_width = 100;
	half_origin_width = 50;
	scale_factor = width / origin_width;

	scale([scale_factor, scale_factor, 1])  union() {
		color("white") if(filename == "") { // default: smile face
		    translate([half_origin_width, half_origin_width, 0]) linear_extrude(4) 
			    smile_face(half_origin_width);
		}
		else {		
			intersection() {			   
			   linear_extrude(4) square(origin_width); 
			   surface(file = filename);
			} 
		}
		color("black") linear_extrude(2) square(origin_width);  
	}
}    

// Load a png file and use the `surface` module to create a puzzle.
// If `filename` is a empty string, it will create a smile face.
// The png file should be 100x100 pixels.
// 
// Parameters: 
//     filename - the png file.
//     width - the width of the image.
//     spacing - a small space between pieces to avoid overlaping while printing.
module image_to_puzzle(filename, width, x_blocks, spacing) {       
	piece_side_length = width / x_blocks;
	y_blocks = x_blocks;

	intersection() {
		image_to_surface(filename, width);
		linear_extrude(15)
			  puzzle(x_blocks, y_blocks, piece_side_length, spacing);    		 
	}	
}
 
image_to_puzzle(filename, width, x_blocks, spacing);

