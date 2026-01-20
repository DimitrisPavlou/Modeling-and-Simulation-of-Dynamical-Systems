# System Identification and Adaptive Control Suite

This repository contains a three-part project focused on the modeling, estimation, and robust control of dynamic systems. The work progresses from offline statistical analysis to real-time adaptive architectures designed to handle uncertainty and disturbances.

---

## Project Overview

The objective of this project is to bridge the gap between theoretical system modeling and practical control implementation.

The project is organized into three modules:

1. Offline estimation for statistical parameter identification  
2. Online estimation for real-time parameter tracking  
3. Robust adaptive control using MRAC architectures  

---

## Project Modules

### Part 1: Offline Parameter Estimation

This module focuses on identifying constant system parameters using batch input–output data.

Method:
- Least Squares (LS) estimation

Key points:
- Normal equations are implemented to minimize the sum of squared residuals
- Persistence of Excitation conditions are verified to guarantee identifiability

---

### Part 2: Online Parameter Estimation

This module extends the estimation framework to real-time applications where parameters may vary over time.

Estimation approach:
- Gradient-descent-based adaptive laws

Estimation architectures:
- Parallel configuration  
  The model runs independently of the plant.

- Series–parallel configuration  
  Plant state feedback is used inside the estimator to improve convergence and stability.

Stability:
- Lyapunov-based analysis guarantees asymptotic convergence of the tracking error  
  (e(t) → 0 as t → ∞)

---

### Part 3: Robust Adaptive Control

This module develops a Model Reference Adaptive Control (MRAC) scheme designed to remain stable under bounded disturbances and modeling uncertainty.

Controller:
- Adaptive control laws for reference model tracking

Robustness enhancements:
- Sigma modification  
  Adds a leakage term to prevent parameter drift during low excitation.

- Epsilon modification  
  Scales the leakage term with the magnitude of the tracking error.

---

## Technology Stack

- MATLAB for simulation and analysis

Core concepts:
- Lyapunov stability theory
- Adaptive gradient methods
- Parameter convergence
- Robustness analysis
