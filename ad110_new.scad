include <cyl_head_bolt.scad>;

$fn=120;

x_angle=15;
y_angle=0;
flip = 0;

mirror([flip,0,0])translate([0,0,19.5])difference() {
    // Body
    translate([0,0,-2])hull() {
        translate([0,0,2])face();
        for(theta = [0:5:x_angle]) {
            rotate([0,theta,0])face();
        }
        for(theta = [0:1:y_angle]) {
            translate([0,118,0])mirror([0,1,0])rotate([-theta,x_angle,0])face();
        }
    }

    // Center hole
    hull () {
        translate([25,55,4])minkowski(){
            cube([25,20,8], center=true); // main
            cylinder(r=5, h=2, center=true); // draft
        }
        mirror([0,1,0])translate([0,-110,0])rotate([-y_angle,x_angle,0])
        translate([25,55,-4])minkowski(){
            cube([25,20,8], center=true);
            cylinder(r=5, h=2, center=true);
        }
    }

    translate([3,-2,3])cube([45,118,3.5]); // main cutout
    translate([25,60,5.5])cube([20,118,4], center=true); // bracket cutout

    
    translate([25.5,116,3])scale([2.0,1.0,1.0])difference() {
        // Top bracket cutout
        cylinder(d=20,h=3, center=true, $fn=6);
        translate([0,10,0])cube([20,20,5],center=true);
    }
    translate([25,60,0]) {
        // Bracket screw holes
        translate([+12,+39.5,0])cylinder(d=3.7, h=100, center=true);
        translate([+12,+39.5,-2])nutcatch_parallel("M5", clh=10, clk=0.3);

        translate([-12,+39.5,0])cylinder(d=3.7, h=100, center=true);
        translate([-12,+39.5,-2])nutcatch_parallel("M5", clh=10, clk=0.3);

        translate([  0,-43.0,0])cylinder(d=3.7, h=100, center=true);
        translate([ 0,-43.0,-2])nutcatch_parallel("M5", clh=10, clk=0.3);
    }
    
    translate([25,60,5])rotate([0,x_angle,0]) {
        // Bottom mounting hole
        translate([0,-30,0]){
            hull(){
                // Screw slot
                translate([0,+2,0])cylinder(d=5, h=100, center=true);
                translate([0,-2,0])cylinder(d=5, h=100, center=true);
            }
            hull() {
                // Head slot
                translate([0,+2,0])cylinder(d=15, h=16, center=true);
                translate([0,-2,0])cylinder(d=15, h=16, center=true);
            }
        }
        // Top mounting hole
        translate([0,+28,0]) {
            hull() {
                translate([+3,0,0])cylinder(d=5, h=100, center=true);
                translate([-3,0,0])cylinder(d=5, h=100, center=true);
            }
            hull() {
                translate([+3,0,0])cylinder(d=15, h=16, center=true);
                translate([-3,0,0])cylinder(d=15, h=16, center=true);
            }
        }
    }
}

module face() {
    cube([51,118,5]);
}
