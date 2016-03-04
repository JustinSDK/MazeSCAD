use <2d.scad>;
use <random_maze_generator.scad>;

heart_height = 30;
wall_thickness = 1.4;
wall_height = 1;
cblocks = 10;
levels = 3;
tip_factor = 15;
bottom = "YES";
ring = "YES";  


/*
 * constants, for clearness
 *
 */
 
// random directions, for picking up a direction to visit the next block
function PERMUTATION_OF_FOUR() = [
    [1, 2, 3, 4],
    [1, 2, 4, 3],
    [1, 3, 2, 4],
    [1, 3, 4, 2],
    [1, 4, 2, 3],
    [1, 4, 3, 2],
    [2, 1, 3, 4],
    [2, 1, 4, 3],
    [2, 3, 1, 4],
    [2, 3, 4, 1],
    [2, 4, 1, 3],
    [2, 4, 3, 1],
    [3, 1, 2, 4],
    [3, 1, 4, 2],
    [3, 2, 1, 4],
    [3, 2, 4, 1],
    [3, 4, 1, 2],
    [3, 4, 2, 1],
    [4, 1, 2, 3],
    [4, 1, 3, 2],
    [4, 2, 1, 3],
    [4, 2, 3, 1],
    [4, 3, 1, 2],
    [4, 3, 2, 1]
];

function NO_WALL() = 0;
function UP_WALL() = 1;
function RIGHT_WALL() = 2;
function UP_RIGHT_WALL() = 3;

function NOT_VISITED() = 0;
function VISITED() = 1;

/* 
 * utilities functions
 *
 */

// comare the equality of [x1, y1] and [x2, y2]
function cord_equals(cord1, cord2) = cord1 == cord2;

// is the point visited?
function not_visited(cord, vs, index = 0) =
    index == len(vs) ? true : 
        (cord_equals([vs[index][0], vs[index][1]], cord) && vs[index][2] == 1 ? false :
            not_visited(cord, vs, index + 1));
            
// pick a direction randomly
function rand_dirs() =
    PERMUTATION_OF_FOUR()[round(rands(0, 24, 1)[0])]; 

// give a index (exclusivly), slice a vector 
function head_to(i, vs) =
    i >= len(vs) ? vs : (
        i == 0 ? [] : concat(head_to(i - 1, vs), [vs[i - 1]])
    );

// give a index (exclusivly), slice a vector 
function tail_from(i, vs, index = 0, new_vs = []) =
    i >= len(vs) ? [] : (
        index < i ? tail_from(i, vs, index + 1) : (
            index < len(vs) ? tail_from(i, vs, index + 1, concat(new_vs, [vs[index]])) : new_vs
        )
    );

// replace v1 in the vector with v2 
function replace(v1, v2, vs, index = 0) =
    index == len(vs) ? vs : (
        vs[index] == v1 ? concat(concat(head_to(index, vs), [v2]), tail_from(index + 1, vs)) : replace(v1, v2, vs, index + 1)
    );
    
/* 
 * functions for generating a maze vector
 *
 */

// initialize rows of a maze
function init_row(n, length) =
    length == 0 ? [] : concat(init_row(n, length - 1), [[length, n, 0, UP_RIGHT_WALL()]]);
    
// initialize a maze
function init_maze(rows, columns) =
    rows == 0 ? [] : concat(init_maze(rows - 1, columns), init_row(rows, columns));
    
// find a vector in the maze vector
function find(i, j, maze_vector, index = 0) =
    index == len(maze_vector) ? [] : (
        cord_equals([i, j], [maze_vector[index][0], maze_vector[index][1]]) ? maze_vector[index] : find(i, j, maze_vector, index + 1)
    );

////
// NO_WALL = 0;
// UP_WALL = 1;
// RIGHT_WALL = 2;
// UP_RIGHT_WALL = 3;
function delete_right_wall(original_block) = 
    original_block == NO_WALL() || original_block == RIGHT_WALL() ? NO_WALL() : UP_WALL();

function delete_up_wall(original_block) = 
    (original_block == NO_WALL() || original_block == UP_WALL()) ? NO_WALL() : RIGHT_WALL();
    
function delete_right_wall_of(vs, is_visited, maze_vector) =
    replace(vs, [vs[0], vs[1] , is_visited, delete_right_wall(vs[3])] ,maze_vector);

function delete_up_wall_of(vs, is_visited, maze_vector) =
    replace(vs, [vs[0], vs[1] , is_visited, delete_up_wall(vs[3])] ,maze_vector);

function go_right(i, j, rows, columns, maze_vector) =
    go_maze(i + 1, j, rows, columns, delete_right_wall_of(find(i, j, maze_vector), VISITED(), maze_vector));
    
function go_up(i, j, rows, columns, maze_vector) =
    go_maze(i, j - 1, rows, columns, delete_up_wall_of(find(i, j, maze_vector), VISITED(), maze_vector));
    
function visit(v, maze_vector) =
    replace(v, [v[0], v[1], VISITED(), v[3]], maze_vector);
 
function go_left(i, j, rows, columns, maze_vector) =
    go_maze(i - 1, j, rows, columns, delete_right_wall_of(find(i - 1, j, maze_vector), NOT_VISITED(), maze_vector));
    
function go_down(i, j, rows, columns, maze_vector) =
    go_maze(i, j + 1, rows, columns, delete_up_wall_of(find(i, j + 1, maze_vector), NOT_VISITED(), maze_vector));
    
function go_maze(i, j, rows, columns, maze_vector) =
    look_around(i, j, rand_dirs(), rows, columns, visit(find(i, j, maze_vector), maze_vector));
    
function look_around(i, j, dirs, rows, columns, maze_vector, index = 0) =
    index == 4 ? maze_vector : 
        look_around( 
            i, j, dirs, 
            rows, columns, 
            build_wall(i, j, dirs[index], rows, columns, maze_vector), 
            index + 1
        ); 

function build_wall(i, j, n, rows, columns, maze_vector) = 
    n == 1 && i != columns && not_visited([i + 1, j], maze_vector) ? go_right(i, j, rows, columns, maze_vector) : ( 
        n == 2 && j != 1 && not_visited([i, j - 1], maze_vector) ? go_up(i, j, rows, columns, maze_vector)  : (
            n == 3 && i != 1 && not_visited([i - 1, j], maze_vector) ? go_left(i, j,rows, columns,  maze_vector)  : (
                n == 4 && j != rows && not_visited([i, j + 1], maze_vector) ? go_down(i, j, rows, columns, maze_vector) : maze_vector
            ) 
        )
    ); 

module ring_heart_sector(radius, angle, tip_factor, thickness) {
	intersection() {
		ring_heart(radius - 0.1, tip_factor, thickness + 0.2);
		rotate([0, 0, angle]) x_line([0, 0], radius * 3, thickness);
	}
}

module heart_to_heart_wall(radius, length, angle, tip_factor, thickness) {
    intersection() {
        difference() {
            solid_heart(radius + length, tip_factor);
		    solid_heart(radius, tip_factor);
	    }
	    rotate([0, 0, angle]) 
		    x_line([0, 0], (radius + length) * 2, thickness);
	}
}

module heart_maze(radius, cblocks, levels, tip_factor, height = 1, thickness = 1) {
    full_circle_angle = 360;
    arc_angle = full_circle_angle / cblocks;
	r = radius / (levels + 1);
	
	maze = go_maze(1, 1, cblocks, levels, replace([levels, cblocks - 1, 0, UP_RIGHT_WALL()], [levels, cblocks - 1, 0, UP_WALL()], init_maze(cblocks, levels)));
	
	
	difference() {
		linear_extrude(height) union() {
			for(i = [1 : levels + 1]) {
				ring_heart(r * i, tip_factor, thickness);
			}
		  
		  
			for(i = [0:len(maze) - 1]) { 
				cord = maze[i];
				cr = cord[0]; 
				cc = cord[1] - 1;    
				v = cord[3];
				
				angle = cc * arc_angle;
				 
				if(v == 1 || v == 3) { 
					heart_to_heart_wall(r * cr, r, cc * arc_angle + 90, tip_factor, thickness);
				} 
			}
	    }
		
		
		linear_extrude(height) union() {
		    // maze entry
		    ring_heart_sector(r, 1.5 * arc_angle + 90, tip_factor, thickness);

	        // road to the next level
			for(i = [0:len(maze) - 1]) { 
				cord = maze[i];
				cr = cord[0]; 
				cc = cord[1] - 1;    
				v = cord[3];
				
				if(v == 0 || v == 1) {
					ring_heart_sector(r * (cr + 1), (cc + 0.5) * arc_angle + 90, tip_factor, thickness);
				}  
			}
		}
	}
}

heart_maze(heart_height / 3.12, cblocks, levels, tip_factor, wall_height, wall_thickness);

if(bottom == "YES") {
    translate([0, 0, -wall_thickness]) 
	    linear_extrude(wall_thickness) 
		    offset(delta = wall_thickness) 
			    solid_heart(heart_height / 3.12, tip_factor, wall_thickness);
}

if(ring == "YES") {
    if(bottom == "YES")  {
	    translate([0, heart_height / 3.12 +  wall_thickness / 2, -wall_thickness / 2]) 
			linear_extrude(wall_height) 
				arc(heart_height / 3.12 / 2, [45, 135], wall_thickness);
	} else {
	    translate([0, heart_height / 3.12 + wall_thickness / 2, 0]) 
			linear_extrude(wall_height) 
				arc(heart_height / 3.12 / 2, [45, 135], wall_thickness);
	}
}