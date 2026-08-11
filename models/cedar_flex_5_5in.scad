/*
  5.5-inch cedar-plug style trolling lure body
  Units: millimeters
*/

$fn = 120;
profile_steps = 220;

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
wall_thickness_mm = 0.8;
bore_end_dia_mm = 3.0;
leader_entry_length_mm = 2.5;

assert(nose_dia_mm > 0 && tail_dia_mm > 0 && max_dia_mm > 0);
assert(shoulder_radius_mm > 0 && mid_radius_mm > 0 && taper_radius_mm > 0 && rear_taper_radius_mm > 0);
assert(0 < shoulder_z_mm && shoulder_z_mm < mid_z_mm && mid_z_mm < taper_z_mm && taper_z_mm < rear_taper_z_mm && rear_taper_z_mm < length_mm);
assert(wall_thickness_mm > 0);
assert(bore_end_dia_mm > 0);
assert(leader_entry_length_mm > 0 && leader_entry_length_mm < length_mm);
assert(nose_dia_mm > bore_end_dia_mm && tail_dia_mm > bore_end_dia_mm);
assert(nose_dia_mm / 2 > wall_thickness_mm + bore_end_dia_mm / 2);
assert(tail_dia_mm / 2 > wall_thickness_mm + bore_end_dia_mm / 2);
assert(profile_steps >= 2);

function smoothstep(t) =
    let(tc = t < 0 ? 0 : (t > 1 ? 1 : t))
    tc * tc * (3 - 2 * tc);
function smooth_lerp(z, z0, z1, r0, r1) =
    let(t = (z - z0) / (z1 - z0))
    r0 + (r1 - r0) * smoothstep(t);

function outer_radius_at(z) =
    z <= shoulder_z_mm ? smooth_lerp(z, 0, shoulder_z_mm, nose_dia_mm / 2, shoulder_radius_mm) :
    z <= mid_z_mm ? smooth_lerp(z, shoulder_z_mm, mid_z_mm, shoulder_radius_mm, mid_radius_mm) :
    z <= taper_z_mm ? smooth_lerp(z, mid_z_mm, taper_z_mm, mid_radius_mm, taper_radius_mm) :
    z <= rear_taper_z_mm ? smooth_lerp(z, taper_z_mm, rear_taper_z_mm, taper_radius_mm, rear_taper_radius_mm) :
    smooth_lerp(z, rear_taper_z_mm, length_mm, rear_taper_radius_mm, tail_dia_mm / 2);

function inner_radius_at(z) =
    z <= leader_entry_length_mm ? bore_end_dia_mm / 2 :
    max(outer_radius_at(z) - wall_thickness_mm, 0);

inner_profile = concat([
    [inner_radius_at(0), 0],
    for (i = [1 : profile_steps - 1])
        let(z = length_mm * i / profile_steps)
        [inner_radius_at(z), z]
], [[inner_radius_at(length_mm), length_mm]]);

outer_profile = concat([
    [outer_radius_at(0), 0],
    for (i = [1 : profile_steps - 1])
        let(z = length_mm * i / profile_steps)
        [outer_radius_at(z), z]
], [[outer_radius_at(length_mm), length_mm]]);

z_samples = concat(
    [0],
    [leader_entry_length_mm],
    [min(leader_entry_length_mm + length_mm / profile_steps * 0.1, length_mm)],
    [for (i = [1 : profile_steps - 1]) length_mm * i / profile_steps],
    [length_mm]
);

entry_wall_sampled_mm = min([
    outer_radius_at(0) - bore_end_dia_mm / 2,
    outer_radius_at(leader_entry_length_mm) - bore_end_dia_mm / 2
]);
assert(entry_wall_sampled_mm >= wall_thickness_mm - 0.0001);
assert(bore_end_dia_mm / 2 <= outer_radius_at(leader_entry_length_mm) - wall_thickness_mm + 0.0001);

min_wall_sampled_mm = min([
    for (z = z_samples)
        if (z >= leader_entry_length_mm)
        outer_radius_at(z) - inner_radius_at(z)
]);
assert(min_wall_sampled_mm >= wall_thickness_mm - 0.0001);

module outer_body() {
    rotate_extrude(angle = 360)
        polygon(concat(outer_profile, [[0, length_mm], [0, 0]]));
}

module full_length_bore() {
    rotate_extrude(angle = 360)
        polygon(concat(inner_profile, [[0, length_mm], [0, 0]]));
}

module lure_body_hollow() {
    difference() {
        outer_body();
        full_length_bore();
    }
}

lure_body_hollow();
