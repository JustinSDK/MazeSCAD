use <2d.scad>;
use <random_maze_generator.scad>;

x_blocks = 10; 
y_blocks = 10;
z_blocks = 10;
wall_thickness = 1;
wall_height = 1;
block_width = 5;
edge_enabled = "YES";

module maze_cube(blocks, block_width, wall_thickness, wall_height) {
    x_blocks = blocks[0];
    y_blocks = blocks[1];
    z_blocks = blocks[2];
    
    length = block_width * x_blocks + wall_thickness * 2;
    width = block_width * y_blocks + wall_thickness * 2;
    height = block_width * z_blocks + wall_thickness * 2;
   
   
    
   maze_vector1 = go_maze(1, 1, y_blocks, x_blocks, replace([1, 1, 0, UP_RIGHT_WALL()], [1, 1, 0, RIGHT_WALL()],
        replace([x_blocks, y_blocks, 0, UP_RIGHT_WALL()], [x_blocks, y_blocks, 0, UP_WALL()], init_maze(y_blocks, x_blocks))
    ));
    
    maze_vector2 = go_maze(1, 1, y_blocks, x_blocks, replace([x_blocks, 1, 0, UP_RIGHT_WALL()], [x_blocks, 1, 0, RIGHT_WALL()], init_maze(y_blocks, x_blocks)));
    
    maze_vector3 = go_maze(1, 1, x_blocks, z_blocks, replace([z_blocks, x_blocks, 0, UP_RIGHT_WALL()], [z_blocks, x_blocks, 0, UP_WALL()], init_maze(x_blocks, z_blocks)));
    
    maze_vector4 = go_maze(1, 1, z_blocks, x_blocks, replace([x_blocks, 1, 0, UP_RIGHT_WALL()], [x_blocks, 1, 0, UP_WALL()], init_maze(z_blocks, x_blocks)));
    
    maze_vector5 = go_maze(1, 1, z_blocks, y_blocks, replace([y_blocks, 1, 0, UP_RIGHT_WALL()], [y_blocks, 1, 0, RIGHT_WALL()], init_maze(z_blocks, y_blocks)));
    
    maze_vector6 = go_maze(1, 1, y_blocks, z_blocks,  replace([z_blocks, 1, 0, UP_RIGHT_WALL()], [z_blocks, 1, 0, RIGHT_WALL()], init_maze(y_blocks, z_blocks))); 
    
    
    cube([length, width, height]);
        
    // 1
    translate([wall_thickness, wall_thickness, -wall_height]) 
        linear_extrude(wall_height) 
        union() {
            y_line([0, 0], block_width);
            maze(y_blocks, x_blocks, maze_vector1, block_width, wall_thickness);
        }
                
    // 5
    translate([wall_thickness, wall_thickness, height]) 
         linear_extrude(wall_height) 
            maze(y_blocks, x_blocks, maze_vector2, block_width, wall_thickness);
    // 6       
    translate([length - wall_thickness, -wall_height, height - wall_thickness]) 
         rotate([90, 90, 180]) linear_extrude(wall_height) 
            maze(x_blocks, z_blocks, maze_vector3, block_width, wall_thickness);
    // 3
    translate([wall_thickness, width, height - wall_thickness]) 
        rotate([-90, 0, 0]) linear_extrude(wall_height) 
            maze(z_blocks, x_blocks, maze_vector4, block_width, wall_thickness);     
    // 4
    translate([-wall_height, width - wall_thickness, height - wall_thickness]) 
         rotate([90, 180, 90])linear_extrude(wall_height) 
            maze(z_blocks, y_blocks, maze_vector5, block_width, wall_thickness);
        
    // 2
    translate([length, width - wall_thickness, wall_thickness]) 
         rotate([0, -90, 180]) linear_extrude(wall_height) 
            maze(y_blocks, z_blocks, maze_vector6, block_width, wall_thickness);

            
    if(edge_enabled == "YES") {
        edge_square_width = 1.5 * wall_thickness + wall_height;
                
        translate([wall_thickness / 2 + block_width, -wall_height, -wall_height]) 
            cube([block_width * (x_blocks - 1) + 1.5 * wall_thickness + wall_height, edge_square_width, edge_square_width]);
         
        translate([0, width - 1.5 * wall_thickness, -wall_height]) 
            cube([length + wall_height, edge_square_width, edge_square_width]);        

        translate([-wall_height , -wall_height, -wall_height]) 
            cube([edge_square_width, y_blocks * block_width + wall_height * 2 + wall_thickness * 2, edge_square_width]);

        translate([x_blocks * block_width + wall_thickness / 2, -wall_height, -wall_height]) 
            cube([edge_square_width, (y_blocks - 1) * block_width + wall_height + wall_thickness * 1.5, edge_square_width]);        
            
        // 
  
        translate([-wall_height, -wall_height, height - edge_square_width + wall_height]) 
            cube([block_width * (x_blocks - 1) + 1.5 * wall_thickness + wall_height, edge_square_width, edge_square_width]);
            
          
        translate([-wall_height, width - 1.5 * wall_thickness, height - edge_square_width + wall_height]) 
            cube([length + wall_height - wall_thickness / 2, edge_square_width, edge_square_width]);        
            
        translate([-wall_height , block_width + wall_thickness / 2, height - edge_square_width + wall_height]) 
            cube([edge_square_width, (y_blocks - 1) * block_width , edge_square_width]);
            

        translate([x_blocks * block_width + wall_thickness / 2, -wall_height, height - edge_square_width + wall_height]) 
            cube([edge_square_width, y_blocks * block_width + wall_height * 2 + wall_thickness * 2, edge_square_width]);     

        //

        
        translate([-wall_height, -wall_height, 0])
            cube([edge_square_width, edge_square_width, height]);          
  
        translate([length - 1.5* wall_thickness, -wall_height, 0])
            cube([edge_square_width, edge_square_width, height]);           
            
                
        translate([-wall_height, width - 1.5 * wall_thickness, 0])
            cube([edge_square_width, edge_square_width, height - block_width - wall_thickness / 2]);

        translate([length - 1.5 * wall_thickness, width - 1.5 * wall_thickness, 0])
            cube([edge_square_width, edge_square_width, height - block_width - wall_thickness / 2]);     
    }        
}
    
/*
 * create a maze
 *
 */

maze_cube([x_blocks, y_blocks, z_blocks], block_width, wall_thickness, wall_height);