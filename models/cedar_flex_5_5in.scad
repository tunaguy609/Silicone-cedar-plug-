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

// Profile control points (radius + axial position)
shoulder_radius_mm = 8.8;
shoulder_z_mm = 14.0;
mid_radius_mm = max_dia_mm / 2; // derived from max_dia_mm
mid_z_mm = 36.0;
taper_radius_mm = 11.2;
taper_z_mm = 92.0;
rear_taper_radius_mm = 8.0;
rear_taper_z_mm = 120.0;

// Functional features
leader_hole_dia_mm = 2.2;

assert(nose_dia_mm > 0 && tail_dia_mm > 0 && max_dia_mm > 0);
assert(shoulder_radius_mm > 0 && mid_radius_mm > 0 && taper_radius_mm > 0 && rear_taper_radius_mm > 0);
assert(0 < shoulder_z_mm && shoulder_z_mm < mid_z_mm && mid_z_mm < taper_z_mm && taper_z_mm < rear_taper_z_mm && rear_taper_z_mm < length_mm);

module lure_body() {
    difference() {
        rotate_extrude(angle = 360)
            polygon([
                [nose_dia_mm / 2, 0],
                [shoulder_radius_mm, shoulder_z_mm],
                [mid_radius_mm, mid_z_mm],
                [taper_radius_mm, taper_z_mm],
                [rear_taper_radius_mm, rear_taper_z_mm],
                [tail_dia_mm / 2, length_mm],
                [0, length_mm],
                [0, 0]
            ]);

        // Through leader hole
        translate([0, 0, -1])
            cylinder(h = length_mm + 2, d = leader_hole_dia_mm, center = false);

    }
}

lure_body();
