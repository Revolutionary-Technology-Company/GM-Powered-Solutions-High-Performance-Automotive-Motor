// =========================================================================
// UNIVERSAL GM LS3-SIZE POWERTRAIN MOTOR MOUNT & SHOCK ISOLATION BRACKET
// Reference Constraints: 4.430" x 3.064" Fastener Grid / 93mm Cushion Clearance
// =========================================================================

$fn = 100; // High render resolution

// Conversion Factor
inch_to_mm = 25.4;

// Exact GM Block-Side Footprint Dimensions
hole_spacing_x = 4.430 * inch_to_mm; // 112.522 mm
hole_spacing_y = 3.064 * inch_to_mm; // 77.825 mm
bolt_hole_dia  = 10.5;                // Clearance for M10x1.5 structural fasteners
plate_thickness = 15.0;               // 15mm thick CNC billet aluminum base

// Shock Isolator (shocks.scad integration) Parameters
cushion_thickness = 93.0;             // Standard GM solid rubber cushion profile
isolator_cup_dia  = 75.0;             // Outer diameter for the shock core housing

module gm_block_side_plate() {
    difference() {
        // Base billet block
        translate([-10, -10, 0])
            cube([hole_spacing_x + 20, hole_spacing_y + 20, plate_thickness]);
        
        // Exact 4-Bolt Pattern Center-to-Center Holes
        translate([0, 0, -1])                  cylinder(d=bolt_hole_dia, h=plate_thickness+2);
        translate([hole_spacing_x, 0, -1])      cylinder(d=bolt_hole_dia, h=plate_thickness+2);
        translate([0, hole_spacing_y, -1])      cylinder(d=bolt_hole_dia, h=plate_thickness+2);
        translate([hole_spacing_x, hole_spacing_y, -1]) cylinder(d=bolt_hole_dia, h=bolt_hole_dia+2);
    }
}

module quantum_shock_cage() {
    // Extruded armature extending to the chassis cushion stand
    translate([hole_spacing_x / 2, hole_spacing_y / 2, plate_thickness]) {
        difference() {
            // Main structural pillar
            cylinder(d1=isolator_cup_dia + 20, d2=isolator_cup_dia + 5, h=45);
            // Embedded internal chamber for the rubber shock element
            translate([0, 0, 10])
                cylinder(d=isolator_cup_dia, h=36); // Clears the isolation core cushion
        }
    }
}

// Assemble the complete physical component
union() {
    gm_block_side_plate();
    quantum_shock_cage();
}
