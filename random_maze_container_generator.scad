use <random_maze_generator.scad>;
use <random_maze_cylinder_generator.scad>;

wall_height = 2;
wall_thickness = 1;

cylinder_radius = 80;
cylinder_height = 25;

vertical_blocks = 5;
horizontal_blocks = 50;

/* 
 * modules for creating a maze
 *
 */

module maze_container(cylinder_r_h, blocks_v_h, wall_thickness = 1, wall_height = 1) {
    maze_vector = go_maze(1, 1, vertical_blocks, horizontal_blocks, replace([horizontal_blocks, 1, 0, UP_RIGHT_WALL()], [horizontal_blocks, 1, 0, UP_WALL()], init_maze(vertical_blocks, horizontal_blocks)));
    
    cylinder_r = cylinder_r_h[0];
    cylinder_h = cylinder_r_h[1];    

    difference() {
        maze_cylinder([cylinder_radius, cylinder_height], [vertical_blocks, horizontal_blocks], maze_vector, wall_thickness, wall_height);
        
        translate([0, 0, -cylinder_h + wall_thickness]) 
            cylinder(h=cylinder_h + wall_thickness, r=cylinder_r - wall_height, $fn=96);
    }
}

maze_container([cylinder_radius, cylinder_height], [vertical_blocks, horizontal_blocks], wall_thickness, wall_height);


