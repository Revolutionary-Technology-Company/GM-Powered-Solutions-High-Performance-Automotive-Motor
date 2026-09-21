// =========================================================================
// UNIVERSAL GM LS3 TO TREMEC TR-6060 ADAPTER PLATE WITH SHOCK CAGE
// Coordinate Origin (0,0) = Crankshaft / Motor Shaft Centerline Axis
// All units are explicitly in millimeters (mm)
// =========================================================================

$fn = 120; // Maximum curve resolution

// Standard Conversions & Base Material Properties
inch_to_mm = 25.4;
plate_thickness = 19.05;          // 0.75-inch solid billet aluminum plate
bolt_clearance_dia = 10.5;        // clearance for standard M10x1.5 bolts
dowel_ream_dia = 12.60;           // reamed tight fit for 0.496" factory alignment dowels

// Exact GM Gen IV LS3 Bellhousing Coordinates (Converted from Inches to mm)
// Looking directly at the back of the engine block block face
ls_bolts_x = [
    0.000  * inch_to_mm,   // Hole 1: 12 o'clock center rigidity bolt
    4.125  * inch_to_mm,   // Hole 2: Top Right
    6.610  * inch_to_mm,   // Hole 3: Mid Right
    4.875  * inch_to_mm,   // Hole 4: Lower Right
   -4.250  * inch_to_mm,   // Hole 5: Lower Left
   -6.610  * inch_to_mm,   // Hole 6: Mid Left
   -4.125  * inch_to_mm    // Hole 7: Top Left
];

ls_bolts_y = [
    8.650  * inch_to_mm,   // Hole 1: 12 o'clock center
    7.500  * inch_to_mm,   // Hole 2: Top Right
    2.000  * inch_to_mm,   // Hole 3: Mid Right
   -2.812  * inch_to_mm,   // Hole 4: Lower Right
   -2.812  * inch_to_mm,   // Hole 5: Lower Left
    2.000  * inch_to_mm,   // Hole 6: Mid Left
    7.500  * inch_to_mm    // Hole 7: Top Left
];

// Dowel Coordinates (Sits on the Lower Horizontal Alignment Plane)
dowel_x = [ -6.110 * inch_to_mm,  6.110 * inch_to_mm ];
dowel_y = [ -2.812 * inch_to_mm, -2.812 * inch_to_mm ];

module adapter_plate_base() {
    difference() {
        // Main structural plate circle clearing the 14-inch flywheel swing envelope
        cylinder(d=18.0 * inch_to_mm, h=plate_thickness, center=false);
        
        // Central core shaft clearance bore
        translate([0, 0, -1])
            cylinder(d=6.5 * inch_to_mm, h=plate_thickness + 2);
        
        // Parametric Drilling for the 7 LS Engine Face Holes
        for (i = [0 : 6]) {
            translate([ls_bolts_x[i], ls_bolts_y[i], -1])
                cylinder(d=bolt_clearance_dia, h=plate_thickness + 2);
        }
        
        // Reaming for the two structural centering alignment dowels
        for (d = [0 : 1]) {
            translate([dowel_x[d], dowel_y[d], -1])
                cylinder(d=dowel_ream_dia, h=plate_thickness + 2);
        }
    }
}

// Global Rubber Shock Core Armatures (shocks.scad integration hooks)
module chassis_torque_isolators() {
    // Left-side block mount arm extending out to the factory SS subframe
    translate([-7.5 * inch_to_mm, 2.5 * inch_to_mm, plate_thickness]) {
        difference() {
            cylinder(d=95, h=93); // Structural bracket tower height matching GM cushion spec
            translate([0,0,5]) cylinder(d=75, h=89); // Internal pocket for the rubber shock isolation ring
        }
    }
    // Right-side block mount arm
    translate([7.5 * inch_to_mm, 2.5 * inch_to_mm, plate_thickness]) {
        difference() {
            cylinder(d=95, h=93);
            translate([0,0,5]) cylinder(d=75, h=89);
        }
    }
}

// Generate compiled production module
union() {
    adapter_plate_base();
    chassis_torque_isolators();
}
