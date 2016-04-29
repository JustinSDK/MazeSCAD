use <2d.scad>;
use <random_maze_generator.scad>;
use <random_maze_regular_polygon_generator.scad>;
use <generalized_soccer_polyhedron.scad>;
use <maze_soccer_ polyhedron.scad>;

height = 50; 

module maze_soccer(height) {
    spacing = 1;
	
	$fn = 48;

	intersection() {
	
		union() {
			sphere(height / 2 - 3); 
						
			generalized_soccer_polyhedron(height, spacing) {
				pentagon_maze_for_soccer_polyhedron(height);
				hexagon_for_soccer_polyhedron(height);
			}
		}
		
		sphere(height / 2 - 2); 
	}
}

maze_soccer(height);
