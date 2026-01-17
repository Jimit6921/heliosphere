# Assumptions and Technical Dependencies

This document outlines key assumptions, technical dependencies, and risk factors for the Heliosphere project. These are based on current (2024) technology readiness levels (TRL) and expected advancements by 2030–2050.

## Core Assumptions

### 1. Material and Component Maturity
- **Perovskite/GaAs Tandem Solar Cells (40% AM0 Efficiency)**:
  - TRL: 4 (lab-validated, 2024 NREL records)
  - Risk: Space radiation degradation; requires encapsulation and testing at 0.5 AU
  - Mitigation: Use GaAs-only cells (35% efficiency, TRL 9) as fallback

- **GaN-on-SiC MMICs (85% RF Efficiency at 5.8 GHz)**:
  - TRL: 5 (DARPA-funded prototypes, 2023)
  - Risk: Radiation hardness unproven for deep-space orbits
  - Mitigation: Redundant MMIC arrays with automatic failover

- **Inflatable CFRP Booms + Dyneema Tethers**:
  - TRL: 7 (used in Starlink Gen2, 2024)
  - Risk: Micrometeorite puncture
  - Mitigation: Self-healing polymers (emerging tech)

### 2. Orbital and Propulsion Feasibility
- **Nuclear-Electric Tug for 0.5 AU Deployment**:
  - Assumes availability by 2035 (post-Artemis program)
  - Risk: Regulatory delays on nuclear propulsion
  - Mitigation: Solar-electric propulsion (slower, but TRL 9)

- **Stable 0.5 AU Orbit**:
  - Assumes Venus-Earth L3-like point stability
  - Risk: Orbital perturbations from Jupiter
  - Mitigation: Station-keeping thrusters (ion engines, TRL 9)

### 3. Economic and Scaling Assumptions
- **Launch Costs ($100/kg to 0.5 AU)**:
  - Based on reusable super-heavy launchers (e.g., Starship derivatives)
  - Risk: If costs remain >$200/kg, project becomes uneconomical
  - Mitigation: In-situ resource utilization (lunar aluminum mining, TRL 3)

- **Global Investment (0.15% of GDP)**:
  - Assumes green bond markets scale to $150B/year
  - Risk: Geopolitical instability
  - Mitigation: Decentralized funding via GRN cooperatives

## Technical Dependencies

### Software and Firmware
- **RISC-V SoC with seL4 Microkernel**:
  - TRL: 8 (used in space missions, 2024)
  - Dependency: Open-source toolchain maturity

- **Ed25519 Cryptography for Beacon Signing**:
  - TRL: 9 (quantum-resistant, widely deployed)
  - Dependency: Hardware-accelerated Ed25519 in radiation-hardened chips

### Simulation and Validation
- **Beam Propagation Models**:
  - Assumes Gaussian beam approximation holds for diffraction-limited systems
  - Dependency: Validation against ESA/NASA SBSP simulations

## Risk Mitigation Strategies

1. **Prototyping Roadmap**:
   - 2026: Ground-based 1-kW rectenna demo
   - 2028: LEO 100-kW beam test
   - 2032: GEO MOR prototype

2. **Fallback Technologies**:
   - If GaN fails: Solid-state amplifiers (lower efficiency, but TRL 9)
   - If perovskite fails: Multi-junction GaAs (30% efficiency, TRL 9)

3. **Regulatory Assumptions**:
   - Operates under Outer Space Treaty (1967) and Moon Agreement (1979)
   - Assumes ICNIRP safety guidelines remain at 1 kW/m² limit

## Open Research Questions
- Long-term radiation effects on perovskite cells at 0.5 AU
- Scalability of inflatable structures beyond 1 km diameter
- Economic viability without subsidies

These assumptions will be updated as TRLs advance. All designs are modular to accommodate technology substitutions.
