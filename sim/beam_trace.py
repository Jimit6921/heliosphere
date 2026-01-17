#!/usr/bin/env python3
"""
Beam Trace Simulation for Heliosphere

Calculates beam divergence and spot size for ISH to MOR transmission.
"""

import argparse
import math

def beam_trace(ish_power, distance):
    """
    Simulate microwave beam propagation.

    Args:
        ish_power (float): ISH output power in watts
        distance (float): Distance to receiver in meters
    """
    # Constants
    frequency = 5.8e9  # 5.8 GHz
    wavelength = 3e8 / frequency  # meters
    aperture_diameter = 1000  # meters

    # Beam divergence (rad)
    theta = 1.22 * wavelength / aperture_diameter

    # Spot size at distance
    spot_diameter = theta * distance

    # Power density at center (simplified, ignoring Gaussian profile)
    area = math.pi * (spot_diameter / 2)**2
    power_density = ish_power / area

    print(f"ISH Power: {ish_power / 1e9:.1f} GW")
    print(f"Distance: {distance / 1e11:.1f} × 10^11 m")
    print(f"Wavelength: {wavelength:.3f} m")
    print(f"Aperture: {aperture_diameter} m")
    print(f"Beam divergence: {theta * 1e6:.1f} µrad ({math.degrees(theta):.4f}°)")
    print(f"Spot diameter: {spot_diameter / 1000:.0f} km")
    print(f"Power density: {power_density:.1f} W/m²")

    # Safety check
    if power_density > 1000:
        print("WARNING: Power density exceeds 1 kW/m² safety limit!")
    else:
        print("✓ Within safety limits.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Beam trace simulation")
    parser.add_argument("--ish_power", type=float, required=True, help="ISH power in watts")
    parser.add_argument("--distance", type=float, required=True, help="Distance in meters")
    args = parser.parse_args()

    beam_trace(args.ish_power, args.distance)
