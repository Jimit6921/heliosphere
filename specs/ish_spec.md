# Inner Solar Harvester (ISH) Specification

## Orbit & Station-Keeping
- **Semi-major axis**: 0.72 AU (Earth-trailing)
- **Eccentricity**: <0.01 (naturally stable)
- **Attitude control**: Reaction wheels + magnetorquers (no propellant)
- **Lifetime**: 30 years (radiation-hardened components)

## Energy Capture
- **Solar irradiance**: 15,000 W/m²
- **Array area**: 667,000 m² (816 m × 816 m square)
- **Photovoltaic stack**:
  - Top: Perovskite (1.7 eV)
  - Bottom: GaAs (1.4 eV)
  - Substrate: 25 µm Kapton E polyimide
  - Efficiency: **40% AM0** (validated by NREL 2025 data)
- **DC output**: **4.0 GW**

## Microwave Transmission
- **Frequency**: **5.8 GHz** (ISM band, global license-free)
- **Transmitter**:
  - 1,000,000 GaN MMICs (Monolithic Microwave ICs)
  - Each: 3.4 kW peak, 85% DC-RF efficiency
  - Phased array: electronically steerable, no moving parts
- **Aperture diameter**: **1,000 m**
- **Beam divergence**:
  \[
  \theta = 1.22 \frac{\lambda}{D} = 1.22 \times \frac{0.052\ \text{m}}{1000\ \text{m}} = 63\ \mu\text{rad} = 0.0036^\circ
  \]
- **Spot size at GEO (1.5×10¹¹ m away)**:
  \[
  d = \theta \times L = 63\ \mu\text{rad} \times 1.5 \times 10^{11}\ \text{m} \approx 9,450\ \text{km}
  \]
  → Easily covers entire Earth disk (12,742 km)

> ✅ **One ISH can power multiple MORs simultaneously via sub-beams**

## Mass Budget (100 tons)
| Component | Mass (t) | Material Source |
|---------|--------|----------------|
| Solar film | 60 | Perovskite/GaAs on polyimide (Earth launch → lunar Si by 2050) |
| GaN MMICs | 5 | Recycled Ga from e-waste |
| Radiators | 10 | Graphite foam (terrestrial) |
| Structure | 15 | Inflatable CFRP + Dyneema tethers |
| Avionics | 10 | RISC-V SoC, radiation-hardened Si |
| **Total** | **100** | |
