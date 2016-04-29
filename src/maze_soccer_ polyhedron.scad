use <2d.scad>;
use <random_maze_generator.scad>;
use <random_maze_regular_polygon_generator.scad>;
use <generalized_soccer_polyhedron.scad>;

height = 50; 
maze_in = "hexagon"; // [pentagon, hexagon, both]

// create a pentagon according the height of the soccer polyhedron
module pentagon_maze_for_soccer_polyhedron(height) {
	wall_thickness = 0.68;
	radius_of_circle_wrapper = 0.5 * height / 6.6 / sin(36) - wall_thickness;
	
	cblocks = 6;
	levels = 3;
	sides = 5; 
	
	regular_polygon_maze(radius_of_circle_wrapper, cblocks, levels, wall_thickness, sides); 			
}

// create a hexagon according the height of the soccer polyhedron
module hexagon_maze_for_soccer_polyhedron(height) {
	wall_thickness = 0.68;
	radius_of_circle_wrapper = 0.5 * height / 6.6 / sin(30) - wall_thickness;
	
	cblocks = 6;
	levels = 3;
	sides = 6;
	
	regular_polygon_maze(radius_of_circle_wrapper, cblocks, levels, wall_thickness, sides);	
}

module maze_soccer_polyhedron(height, maze_in) {
    spacing = 1;
	
	sphere(height / 2 - 1); 
	
    if(maze_in == "pentagon"){
		generalized_soccer_polyhedron(height, spacing) {
			pentagon_maze_for_soccer_polyhedron(height);
			hexagon_for_soccer_polyhedron(height);
		}	
	} else if(maze_in == "hexagon"){
		generalized_soccer_polyhedron(height, spacing) {
			pentagon_for_soccer_polyhedron(height);
			hexagon_maze_for_soccer_polyhedron(height);
		}	
	} else if(maze_in == "both") {
		generalized_soccer_polyhedron(height, spacing) {
			pentagon_maze_for_soccer_polyhedron(height);
			hexagon_maze_for_soccer_polyhedron(height);
		}
	} 
}

maze_soccer_polyhedron(height, maze_in);
