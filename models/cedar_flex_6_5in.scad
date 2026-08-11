/*
  6.5-inch cedar-plug style trolling lure body
  Units: millimeters
*/

$fn = 120;
profile_steps = 220;

// Overall geometry
length_mm = 165.1;   // 6.5 in
max_dia_mm = 25.4;   // 1.0 in
nose_dia_mm = 5.0;
tail_dia_mm = 11.0;

// Profile control points (radius + axial position)
shoulder_radius_mm = 8.9;
shoulder_z_mm = 16.0;
mid_radius_mm = max_dia_mm / 2; // derived from max_dia_mm
mid_z_mm = 43.0;
taper_radius_mm = 11.0;
taper_z_mm = 112.0;
rear_taper_radius_mm = 8.6;
rear_taper_z_mm = 146.0;

// Functional features
wall_thickness_mm = 0.8;
bore_end_dia_mm = 3.0;
leader_entry_length_mm = 2.5;
epsilon_mm = 0.0001;

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

function clamp01(t) =
    let(tc = t < 0 ? 0 : (t > 1 ? 1 : t))
    tc;
function hermite_radius(z, z0, z1, r0, r1, m0, m1) =
    let(
        t = clamp01((z - z0) / (z1 - z0)),
        tt = t * t,
        ttt = tt * t,
        h00 = 2 * ttt - 3 * tt + 1,
        h10 = ttt - 2 * tt + t,
        h01 = -2 * ttt + 3 * tt,
        h11 = ttt - tt,
        dz = z1 - z0
    )
    h00 * r0 + h10 * dz * m0 + h01 * r1 + h11 * dz * m1;

profile_z_mm = [0, shoulder_z_mm, mid_z_mm, taper_z_mm, rear_taper_z_mm, length_mm];
profile_r_mm = [nose_dia_mm / 2, shoulder_radius_mm, mid_radius_mm, taper_radius_mm, rear_taper_radius_mm, tail_dia_mm / 2];

function profile_tangent_at(i) =
    i == 0 ? (profile_r_mm[1] - profile_r_mm[0]) / (profile_z_mm[1] - profile_z_mm[0]) :
    i == len(profile_z_mm) - 1 ? (profile_r_mm[i] - profile_r_mm[i - 1]) / (profile_z_mm[i] - profile_z_mm[i - 1]) :
    (profile_r_mm[i + 1] - profile_r_mm[i - 1]) / (profile_z_mm[i + 1] - profile_z_mm[i - 1]);

function segment_index_for_z(z) =
    let(matches = [
        for (i = [0 : len(profile_z_mm) - 2])
            if (profile_z_mm[i] <= z && z <= profile_z_mm[i + 1])
            i
    ])
    len(matches) > 0 ? max(matches) : len(profile_z_mm) - 2;

function outer_radius_at(z) =
    let(
        zc = z < 0 ? 0 : (z > length_mm ? length_mm : z),
        si = segment_index_for_z(zc),
        z0 = profile_z_mm[si],
        z1 = profile_z_mm[si + 1],
        r0 = profile_r_mm[si],
        r1 = profile_r_mm[si + 1],
        m0 = profile_tangent_at(si),
        m1 = profile_tangent_at(si + 1)
    )
    hermite_radius(zc, z0, z1, r0, r1, m0, m1);

function inner_radius_at(z) =
    z <= leader_entry_length_mm ? bore_end_dia_mm / 2 :
    max(outer_radius_at(z) - wall_thickness_mm, 0);

profile_sample_z_mm = [for (i = [1 : profile_steps - 1]) length_mm * i / profile_steps];

inner_profile = concat([
    [inner_radius_at(0), 0],
    for (z = profile_sample_z_mm)
        if (0 < z && z < length_mm)
        [inner_radius_at(z), z]
], [[inner_radius_at(length_mm), length_mm]]);

outer_profile = concat([
    [outer_radius_at(0), 0],
    for (z = profile_sample_z_mm)
        if (0 < z && z < length_mm)
        [outer_radius_at(z), z]
], [[outer_radius_at(length_mm), length_mm]]);

z_samples = concat(
    [0],
    [leader_entry_length_mm],
    [min(leader_entry_length_mm + epsilon_mm, length_mm)],
    profile_sample_z_mm,
    [length_mm]
);

entry_wall_sampled_mm = min([
    for (z = z_samples)
        if (z <= leader_entry_length_mm)
        outer_radius_at(z) - bore_end_dia_mm / 2
]);
assert(entry_wall_sampled_mm >= wall_thickness_mm - epsilon_mm);
assert(bore_end_dia_mm / 2 <= outer_radius_at(leader_entry_length_mm) - wall_thickness_mm + epsilon_mm);

min_outer_hollow_radius_mm = min([
    for (z = z_samples)
        if (z > leader_entry_length_mm)
        outer_radius_at(z)
]);
assert(min_outer_hollow_radius_mm >= wall_thickness_mm - epsilon_mm);

min_wall_sampled_mm = min([
    for (z = z_samples)
        if (z > leader_entry_length_mm)
        outer_radius_at(z) - inner_radius_at(z)
]);
assert(min_wall_sampled_mm >= wall_thickness_mm - epsilon_mm);

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
