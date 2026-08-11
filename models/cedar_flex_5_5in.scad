/*
  5.5-inch cedar-plug style trolling lure body
  Units: millimeters
*/

$fn = 120;

// Overall geometry
length_mm = 139.7;   // 5.5 in
max_dia_mm = 25.4;   // 1.0 in
nose_dia_mm = 5.0;
tail_dia_mm = 8.5;

// Functional features
leader_hole_dia_mm = 2.2;

// Optional ballast cavity near head (set to false to disable)
add_ballast_cavity = true;
ballast_cavity_dia_mm = 8.0;
ballast_cavity_depth_mm = 16.0;

module lure_body() {
    difference() {
        rotate_extrude(angle = 360)
            polygon([
                [0, 0],
                [nose_dia_mm / 2, 0],
                [8.8, 14],
                [max_dia_mm / 2, 36],
                [11.2, 92],
                [8.0, 120],
                [tail_dia_mm / 2, length_mm],
                [0, length_mm]
            ]);

        // Through leader hole
        translate([0, 0, -1])
            cylinder(h = length_mm + 2, d = leader_hole_dia_mm, center = false);

        // Optional ballast pocket in nose section
        if (add_ballast_cavity)
            translate([0, 0, 0])
                cylinder(h = ballast_cavity_depth_mm, d = ballast_cavity_dia_mm, center = false);
    }
}

lure_body();
