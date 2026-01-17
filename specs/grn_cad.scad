// OpenSCAD CAD Model for 1-kW Ground Reception Node (GRN)
//
// This is a parametric model for a 1-kW rectenna array.
// Designed for 5.8 GHz microwave reception with 90% efficiency.
//
// Dimensions: 10m x 10m array (100 m² active area)
// Materials: PET film substrate, copper dipole elements, GaAs Schottky diodes
//
// License: CERN-OHL-W v2

// Parameters
array_width = 10000;  // 10m in mm
array_height = 10000; // 10m in mm
dipole_length = 25.86; // λ/2 at 5.8 GHz (c/f/2 = 299792458/(5800000000*2) ≈ 25.86mm)
dipole_spacing = 25;   // 25mm grid spacing
diode_diameter = 1;    // 1mm diode package
substrate_thickness = 0.25; // 250µm PET film

// Calculate number of dipoles
num_dipoles_x = floor(array_width / dipole_spacing);
num_dipoles_y = floor(array_height / dipole_spacing);

// Substrate (PET film)
module substrate() {
    color("white", 0.8)
    cube([array_width, array_height, substrate_thickness]);
}

// Single dipole element
module dipole() {
    color("gold")
    union() {
        // Two arms of dipole
        translate([-dipole_length/2, 0, substrate_thickness])
        cube([dipole_length, 0.5, 0.1]);
        translate([0, -dipole_length/2, substrate_thickness])
        cube([0.5, dipole_length, 0.1]);

        // Schottky diode at center
        color("black")
        translate([-diode_diameter/2, -diode_diameter/2, substrate_thickness])
        cylinder(h=0.5, d=diode_diameter, $fn=16);
    }
}

// Full rectenna array
module rectenna_array() {
    substrate();

    // Place dipoles in grid
    for (x = [0 : num_dipoles_x - 1]) {
        for (y = [0 : num_dipoles_y - 1]) {
            translate([
                x * dipole_spacing + dipole_spacing/2,
                y * dipole_spacing + dipole_spacing/2,
                0
            ])
            dipole();
        }
    }
}

// Support structure (optional mounting frame)
module mounting_frame() {
    frame_thickness = 50; // 50mm aluminum frame
    color("silver")
    difference() {
        cube([array_width + 100, array_height + 100, frame_thickness]);
        translate([50, 50, -1])
        cube([array_width, array_height, frame_thickness + 2]);
    }
}

// Assembly
module grn_1kw() {
    mounting_frame();
    translate([50, 50, 50])
    rectenna_array();
}

// Render the model
grn_1kw();

// Export notes:
// - Use OpenSCAD to render STL for 3D printing prototypes
// - Scale appropriately for manufacturing
// - Actual rectenna uses flexible electronics, not rigid structures
// - This is a conceptual model for visualization and BOM validation
