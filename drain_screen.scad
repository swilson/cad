
module hex(hole, wall, thick){
    hole = hole;
    wall = wall;
    difference(){
        rotate([0, 0, 30]) cylinder(d = (hole + wall), h = thick, $fn = 6);
        translate([0, 0, -0.1]) rotate([0, 0, 30]) cylinder(d = hole, h = thick + 0.2, $fn = 6);
    }
}

// Model Parameters - use these to customize your model
meshLineWidth = 1.5;// [mm] make sure this is not smaller than your min feature width
sliceHeight = 100;  // [mm] sets how thick the mesh lines are
pitch = 10.0;          // [mm] center to center spacing for adjacent parallel mesh lines


module mesh(diameter, height) { 
    // y- direction mesh lines
    for (i = [-diameter:pitch:diameter]) {
        translate ([i, 0, 0]) cube([meshLineWidth, 1.1*diameter, height], center=true);
        
    }
    
    // x- direction mesh lines
    for (i = [-diameter:pitch * 2:diameter]) {
        translate ([0, i, 0]) cube([1.1*diameter, meshLineWidth, height], center=true);
        
    }
}



module hexgrid(box, holediameter, wallthickness) {
    a = (holediameter + (wallthickness/2))*sin(60);
    for(x = [holediameter/2: a: box[0]]) {
        for(y = [holediameter/2: 2*a*sin(60): box[1]]) {
            translate([x, y, 0]) hex(holediameter, wallthickness, box[2]);
            translate([x + a*cos(60), y + a*sin(60), 0]) hex(holediameter, wallthickness, box[2]);

        }
    }
        
}

  module prism(l, w, h){
      polyhedron(//pt 0        1        2        3        4        5
              points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
              faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
              );
      
      // preview unfolded (do not include in your function
      /*
      z = 0.08;
      separation = 2;
      border = .2;
      translate([0,w+separation,0])
          cube([l,w,z]);
      translate([0,w+separation+w+border,0])
          cube([l,h,z]);
      translate([0,w+separation+w+border+h+border,0])
          cube([l,sqrt(w*w+h*h),z]);
      translate([l+border,w+separation,0])
          polyhedron(//pt 0       1       2        3       4       5
                  points=[[0,0,0],[h,w,0],[0,w,0], [0,0,z],[h,w,z],[0,w,z]],
                  faces=[[0,1,2], [3,5,4], [0,3,4,1], [1,4,5,2], [2,5,3,0]]
                  );
      translate([0-border,w+separation,0])
          polyhedron(//pt 0       1         2        3       4         5
                  points=[[0,0,0],[0-h,w,0],[0,w,0], [0,0,z],[0-h,w,z],[0,w,z]],
                  faces=[[1,0,2],[5,3,4],[0,1,4,3],[1,2,5,4],[2,0,3,5]]
                  );
                  */
      }

// first arg is vector that defines the bounding box, length, width, height
// second arg in the 'diameter' of the holes. In OpenScad, this refers to the corner-to-corner diameter, not flat-to-flat
// this diameter is 2/sqrt(3) times larger than flat to flat
// third arg is wall thickness.  This also is measured that the corners, not the flats. 

od=107;
id=100;
or=od/2;
ir=id/2;
height=50;
$fn=120;

wallWidth = 2;

union() {
        intersection() {    
            union() {
                difference() {
                    cylinder(h=height * 2, r=ir);
                    translate([0, 0, -1]) cylinder(h=height * 2, r=ir - wallWidth);
                }


                intersection() {
                    cylinder(h=height * 2, r=ir);
                    mesh(diameter=id, height = height * 3);
                }
            }  

            union() {
                translate([-ir, -ir, 0]) cube([id, id, 10]);
                translate([-ir, -ir, 10]) prism(id, id, height);
            }
        }

    difference() {
        cylinder(h=4, r=or);
        translate([0, 0, -1]) cylinder(h=4 + 2, r=ir - wallWidth);
    }
}
