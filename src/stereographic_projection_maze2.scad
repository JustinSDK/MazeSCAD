block_width = 24;
wall_thickness = 12; 
maze_rows = 12; 
maze_columns = 12; 
projected_maze = "YES"; // [YES, NO]

 
//... stereographic projection
//

// xy : [x, y]
function cartesian_to_polar(xy) = 
    [
        sqrt(xy[0] * xy[0] + xy[1] * xy[1]), 
        atan2(xy[1], xy[0])
    ];

// r_theta_phi : [r, theta, phi]
function spherical_to_cartesian(r_theta_phi) = 
    [
        r_theta_phi[0] * cos(r_theta_phi[2]) * cos(r_theta_phi[1]), 
        r_theta_phi[0] * cos(r_theta_phi[2]) * sin(r_theta_phi[1]), 
        r_theta_phi[0] * sin(r_theta_phi[2])
    ];
    
function stereographic_projection_polar_to_spherical(r, polar) = 
    [
        2 * r * sin(atan2(polar[0], (r * 2))),
        polar[1],
        atan2(polar[0], (r * 2))
    ];

// draw a line between point [x1, y1] and [x2, y2].
module line(point1, point2, width = 1, cap_round = true) {
    angle = 90 - atan((point2[1] - point1[1]) / (point2[0] - point1[0]));
    offset_x = 0.5 * width * cos(angle);
    offset_y = 0.5 * width * sin(angle);

    offset1 = [-offset_x, offset_y];
    offset2 = [offset_x, -offset_y];

    if(cap_round) {
        translate(point1) circle(d = width, $fn = 24);
        translate(point2) circle(d = width, $fn = 24);
    }

    polygon(points=[
        point1 + offset1, point2 + offset1,  
        point2 + offset2, point1 + offset2
    ]);
}

module polyline(points, width = 1) {
    module polyline_inner(points, index) {
        if(index < len(points)) {
            line(points[index - 1], points[index], width);
            polyline_inner(points, index + 1);
        }
    }

    polyline_inner(points, 1);
} 

module stereographic_projection_line3D(p1, p2, thickness1, thickness2, fn = 24) {
    $fn = fn;
    
    za1 = atan2(p1[1], p1[0]);
    xya1 = atan2(p1[2], dist_from_org(p1)); 
    
    za2 = atan2(p2[1], p2[0]);
    xya2 = atan2(p2[2], dist_from_org(p2));
    
    hull() {
        translate(p1) rotate([xya1, xya1, za1]) rotate(45) sphere(thickness1 / 2);
        translate(p2) rotate([xya2, xya2, za2]) rotate(45) sphere(thickness2 / 2);
    }
}


function stereographic_projection_xy_to_xyz(r, xy) =
    spherical_to_cartesian(
        stereographic_projection_polar_to_spherical(
            r, cartesian_to_polar(xy)
        )
    );
    

//.. maze
//

// Constants for wall types

NO_WALL = 0;    
UPPER_WALL = 1; 
RIGHT_WALL = 2; 
UPPER_RIGHT_WALL = 3;

function block_data(x, y, wall_type, visited) = [x, y, wall_type, visited];
function get_x(block_data) = block_data[0];
function get_y(block_data) = block_data[1];
function get_wall_type(block_data) = block_data[2];

// create a starting maze for being visited later.
function starting_maze(rows, columns) =  [
    for(y = [1:rows]) 
        for(x = [1:columns]) 
            block_data(
                x, y, 
                // all blocks have upper and right walls except the exit
                UPPER_RIGHT_WALL, 
                // unvisited
                false 
            )
];

// find out the index of a block with the position (x, y)
function indexOf(x, y, maze, i = 0) =
    i > len(maze) ? -1 : (
        [get_x(maze[i]), get_y(maze[i])] == [x, y] ? i : 
            indexOf(x, y, maze, i + 1)
    );

// is (x, y) visited?
function visited(x, y, maze) = maze[indexOf(x, y, maze)][3];

// is (x, y) visitable?
function visitable(x, y, maze, rows, columns) = 
    y > 0 && y <= rows &&     // y bound
    x > 0 && x <= columns &&  // x bound
    !visited(x, y, maze);     // unvisited

// setting (x, y) as being visited
function set_visited(x, y, maze) = [
    for(b = maze) 
        [x, y] == [get_x(b), get_y(b)] ? 
            [x, y, get_wall_type(b), true] : b
];
    
// 0（right）、1（upper）、2（left）、3（down）
function rand_dirs() =
    [
        [0, 1, 2, 3],
        [0, 1, 3, 2],
        [0, 2, 1, 3],
        [0, 2, 3, 1],
        [0, 3, 1, 2],
        [0, 3, 2, 1],
        [1, 0, 2, 3],
        [1, 0, 3, 2],
        [1, 2, 0, 3],
        [1, 2, 3, 0],
        [1, 3, 0, 2],
        [1, 3, 2, 0],
        [2, 0, 1, 3],
        [2, 0, 3, 1],
        [2, 1, 0, 3],
        [2, 1, 3, 0],
        [2, 3, 0, 1],
        [2, 3, 1, 0],
        [3, 0, 1, 2],
        [3, 0, 2, 1],
        [3, 1, 0, 2],
        [3, 1, 2, 0],
        [3, 2, 0, 1],
        [3, 2, 1, 0]
    ][round(rands(0, 24, 1)[0])]; 

// get x value by dir
function next_x(x, dir) = x + [1, 0, -1, 0][dir];
// get y value by dir
function next_y(y, dir) = y + [0, 1, 0, -1][dir];

// go right and carve the right wall
function go_right_from(x, y, maze) = [
    for(b = maze) [get_x(b), get_y(b)] == [x, y] ? (
        get_wall_type(b) == UPPER_RIGHT_WALL ? 
            [x, y, UPPER_WALL, visited(x, y, maze)] : 
            [x, y, NO_WALL, visited(x, y, maze)]
        
    ) : b
]; 

// go up and carve the upper wall
function go_up_from(x, y, maze) = [
    for(b = maze) [get_x(b), get_y(b)] == [x, y] ? (
        get_wall_type(b) == UPPER_RIGHT_WALL ? 
            [x, y, RIGHT_WALL, visited(x, y, maze)] :  
            [x, y, NO_WALL, visited(x, y, maze)]
        
    ) : b
]; 

// go left and carve the right wall of the left block
function go_left_from(x, y, maze) = [
    for(b = maze) [get_x(b), get_y(b)] == [x - 1, y] ? (
        get_wall_type(b) == UPPER_RIGHT_WALL ? 
            [x - 1, y, UPPER_WALL, visited(x - 1, y, maze)] : 
            [x - 1, y, NO_WALL, visited(x - 1, y, maze)]
    ) : b
]; 

// go down and carve the upper wall of the down block
function go_down_from(x, y, maze) = [
    for(b = maze) [get_x(b), get_y(b)] == [x, y - 1] ? (
        get_wall_type(b) == UPPER_RIGHT_WALL ? 
            [x, y - 1, RIGHT_WALL, visited(x, y - 1, maze)] : 
            [x, y - 1, NO_WALL, visited(x, y - 1, maze)]
    ) : b
]; 

// 0（right）、1（upper）、2（left）、3（down）
function try_block(dir, x, y, maze, rows, columns) =
    dir == 0 ? go_right_from(x, y, maze) : (
        dir == 1 ? go_up_from(x, y, maze) : (
            dir == 2 ? go_left_from(x, y, maze) : 
                 go_down_from(x, y, maze)   // 這時 dir 一定是 3
            
        ) 
    );


// find out visitable dirs from (x, y)
function visitable_dirs_from(x, y, maze, rows, columns) = [
    for(dir = [0, 1, 2, 3]) 
        if(visitable(next_x(x, dir), next_y(y, dir), maze, maze_rows, columns)) 
            dir
];  
    
// go maze from (x, y)
function go_maze(x, y, maze, rows, columns) = 
    //  have visitable dirs?
    len(visitable_dirs_from(x, y, maze, rows, columns)) == 0 ? 
        set_visited(x, y, maze)      // road closed
        : walk_around_from(          
            x, y, 
            rand_dirs(),             
            set_visited(x, y, maze), 
            rows, columns
        );

// try four directions
function walk_around_from(x, y, dirs, maze, rows, columns, i = 4) =
    // all done?
    i > 0 ? 
        // not yet
        walk_around_from(x, y, dirs, 
            // try one direction
            try_routes_from(x, y, dirs[4 - i], maze, rows, columns),  
            , rows, columns, 
            i - 1) 
        : maze;
        
function try_routes_from(x, y, dir, maze, rows, columns) = 
    // is the dir visitable?
    visitable(next_x(x, dir), next_y(y, dir), maze, rows, columns) ?     
        // try the block 
        go_maze(
            next_x(x, dir), next_y(y, dir), 
            try_block(dir, x, y, maze, rows, columns),
            rows, columns
        ) 
        // road closed so return maze directly
        : maze;   
        
maze_blocks = go_maze(
    1, 1,   // starting point
    starting_maze(maze_rows, maze_columns),  
    maze_rows, maze_columns
);

function block_wall_points(wall_type, block_width) =
    concat(
        wall_type == UPPER_WALL || wall_type == UPPER_RIGHT_WALL ? 
            [[0, block_width], [block_width, block_width]] : []
        ,
        
        wall_type == RIGHT_WALL || wall_type == UPPER_RIGHT_WALL ?
            [[block_width, block_width], [block_width, 0]] : []
    ); 
     
function dist_from_org(p) = 
    sqrt(pow(p[0], 2) + pow(p[1], 2));
 
function distance2D(p1, p2) = 
    sqrt(pow(p1[0] - p2[0], 2) + pow(p1[1] - p2[1], 2));
 
function distance3D(p1, p2) = 
    sqrt(pow(p1[0] - p2[0], 2) + pow(p1[1] - p2[1], 2) + pow(p1[2] - p2[2], 2));
    
function append_left_down_walls(rows, columns, blocks) = concat(
        concat(
            blocks, 
            [for(r = [1:rows]) block_data(0, r, RIGHT_WALL, true)]
        ), 
        [for(c = [1:columns]) block_data(c, 0, UPPER_WALL, true)]
    );
  
module draw_stereographic_projection_maze2(rows, columns, blocks, block_width, wall_thickness) {
    fn = 4; // for lines, the bigger it is, the more round line

    sphere_r = block_width * rows / 6;
    half_thickness = wall_thickness / 2;
    
    function offset(a) = [half_thickness * cos(a), half_thickness * sin(a)];
    
    function line_r(cpt) = cpt[0] == 0 && cpt[1] == 0 ? wall_thickness : distance3D(
        stereographic_projection_xy_to_xyz(
            sphere_r, 
            cpt - offset(acos(cpt[0] / dist_from_org(cpt)))
        ),
        stereographic_projection_xy_to_xyz(
            sphere_r,
            cpt + offset(acos(cpt[0] / dist_from_org(cpt)))
        )
    );
    
    translate([0, 0, sphere_r]) union() {
        for(block = blocks) {
            left_down_pts = [ 
                get_x(block) - 1 - columns / 2, 
                get_y(block) - 1 - rows / 2
            ] * block_width;
                  
            block_wall_pts = [
                for(block_wall_pt = block_wall_points(get_wall_type(block), block_width))                           
                    block_wall_pt + left_down_pts 
            ]; 
    
            if(block_wall_pts != []) {
                pts_translated_to_xyz = [
                     for(pt = block_wall_pts)
                         stereographic_projection_xy_to_xyz(sphere_r, pt) + [0, 0, -sphere_r]
                ];
  
                // draw one wall
                stereographic_projection_line3D(
                    pts_translated_to_xyz[0], 
                    pts_translated_to_xyz[1], 
                    line_r(block_wall_pts[0]), 
                    line_r(block_wall_pts[1]), 
                    fn
                );
                 
                // draw another wall
                if(len(pts_translated_to_xyz) != 2) {
                    stereographic_projection_line3D(
                        pts_translated_to_xyz[2], pts_translated_to_xyz[3], 
                        line_r(block_wall_pts[1]), 
                        line_r(block_wall_pts[2]), 
                        fn
                    );
                }
                
            }
        } 
    }
}


module draw_maze(rows, columns, blocks, block_width, wall_thickness) {
    for(block = blocks) {
        xy = [
            get_x(block) - 1 - columns / 2, 
            get_y(block) - 1 - rows / 2
        ] * block_width;
        
        block_wall_pts = 
            block_wall_points(get_wall_type(block), block_width);

        if(block_wall_pts != []) {
            pts_translated_to_xy = [for(pt = block_wall_pts) pt + xy];
            
            polyline(
                pts_translated_to_xy, 
                wall_thickness
            );
        }
    }
}

draw_stereographic_projection_maze2(
    maze_rows, 
    maze_columns, 
    append_left_down_walls(maze_rows, maze_columns, maze_blocks), 
    block_width, 
    wall_thickness
);   

if(projected_maze == "YES") {
    color("black") linear_extrude(wall_thickness, center = true) draw_maze(
        maze_rows, 
        maze_columns, 
        append_left_down_walls(maze_rows, maze_columns, maze_blocks), 
        block_width, 
        wall_thickness
    );
}