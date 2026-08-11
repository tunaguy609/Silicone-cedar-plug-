# Silicone Cedar Plug (5.5" Cedar Flex Style)

This repository now defines a concise build specification for a **5.5 inch trolling lure** in the style of a cedar-flex profile.

## Target Design

- **Overall length:** 5.5 in (139.7 mm)
- **Body shape:** tapered bullet/cedar plug profile with slightly rounded nose and narrow tail transition
- **Primary use:** offshore trolling for pelagic species
- **Tracking goal:** stable straight track from 5 to 10 knots

## Recommended Construction

- **Core:** turned cedar dowel or cedar body blank
- **Outer skin:** durable silicone overmold for impact resistance and improved finish life
- **Leader channel:** through-hole centered along the body axis
- **Head weighting:** optional forward ballast insert to keep the lure tracking true

## Suggested Dimensions (starting point)

- **Max body diameter:** 0.95 in to 1.05 in
- **Nose diameter at tip radius:** ~0.20 in
- **Tail diameter before skirt/terminal hardware:** 0.30 in to 0.40 in
- **Through-hole diameter:** sized for selected leader system (commonly 1.5 mm to 2.5 mm clearance)

## Rigging Baseline

- **Leader:** 150 to 300 lb mono or fluorocarbon
- **Hook setup:** single or double hook rig matched to local regulations and target species
- **Skirt/chaser option:** flexible vinyl or silicone skirt in baitfish colorways

## Finish Options

- Natural cedar tone under clear silicone
- Blue/white, pink/white, or black/purple offshore contrast patterns
- UV-reactive accent stripes for low-light visibility

## Validation Checklist

1. Water-test at 5, 7, and 10 knots
2. Confirm no roll-out or side-skipping in clean water
3. Confirm silicone skin adhesion after repeated strikes and washdown
4. Adjust forward ballast and skirt length until tracking is consistently straight

## OpenSCAD + 3D Printing

An OpenSCAD model is included at:

- `models/cedar_flex_5_5in.scad`

### Open in OpenSCAD

1. Open the `.scad` file in OpenSCAD
2. Adjust parameters at the top of the file if needed:
   - `length_mm`
   - `max_dia_mm`
   - `nose_dia_mm`
   - `tail_dia_mm`
   - `shoulder_radius_mm`, `shoulder_z_mm`
   - `mid_radius_mm`, `mid_z_mm`
   - `taper_radius_mm`, `taper_z_mm`
   - `rear_taper_radius_mm`, `rear_taper_z_mm`
   - `wall_thickness_mm`
   - `bore_end_dia_mm`
3. Press **F6** (Render)

### Export STL

1. In OpenSCAD: **File → Export → Export as STL**
2. Slice in your preferred slicer

### Suggested Print Setup (starting point)

- Material: PETG, ABS, ASA, or Nylon (better impact/heat resistance than PLA)
- Orientation: body axis vertical or shallow angled support strategy
- Perimeters/Walls: 4+
- Infill: 40% to 100% depending on desired sink rate and strength
- Layer height: 0.16 to 0.24 mm

The model now uses a full-length internal bore (hollow interior) with smooth taper transitions; adjust wall thickness and bore diameter to match your hardware and strength needs.
