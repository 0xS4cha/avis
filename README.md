# AVIS 🐦

A lightweight boids simulation written in Lua, designed to run on [d3m0n os Lua runtime](https://github.com/d3m0n-project/lua).

AVIS explores emergent flocking behavior through a simple 2D simulation, where individual birds follow a small set of local rules to produce coordinated movement.

## About

AVIS is a small graphics and simulation project built using [`d3gl`](https://github.com/d3m0n-project/d3gl), a custom Lua runtime developed for the [`d3m0n_os`](https://github.com/d3m0n-project/d3m0n_os) kernel project.

Rather than relying on a conventional desktop operating system or a standard game engine, this project targets a custom environment where Lua code runs within a bare-metal operating system.

The goal is to experiment with real-time graphics, lightweight simulation, and flocking algorithms in a constrained environment.

## Features

- **Boids simulation** - flocking behavior based on local interactions.
- **Separation** - birds steer away from nearby neighbors.
- **Alignment** - birds adjust their direction to match nearby birds.
- **Cohesion** - birds steer toward the center of their local flock.
- **Field of view** - birds consider only neighbors within their vision angle.
- **Toroidal movement** - birds wrap around the screen boundaries.
- **Lightweight rendering** - birds are rendered as simple triangles.
- **Bare-metal target** - designed for the custom Lua environment used by d3m0n_os.

## Built With

- [Lua](https://www.lua.org/) - scripting language.
- [d3m0n-project/lua](https://github.com/d3m0n-project/lua) - custom Lua runtime and graphics environment.
- [d3m0n-project/d3m0n_os](https://github.com/d3m0n-project/d3m0n_os) - bare-metal operating system kernel.

## Project Structure

```text
.
├── main.lua          # Application entry point and simulation loop
├── bird.lua          # Bird behavior, steering, movement, and rendering
└── simulation.lua    # Simulation configuration
```

The entry-point filename may differ depending on your project setup.

## How It Works

AVIS implements a variation of Craig Reynolds' classic boids model. Each bird makes decisions based on nearby birds rather than following a centrally controlled path.

Three steering rules define the flock's behavior:

### 1. Separation

Birds avoid crowding nearby neighbors by steering away from them.

### 2. Alignment

Birds gradually adjust their heading toward the average heading of nearby neighbors.

### 3. Cohesion

Birds steer toward the local center of nearby birds, helping the flock stay together.

The simulation also uses a configurable field of view, limiting which neighbors influence each bird.

## Configuration

Simulation parameters are defined in `simulation.lua`:

```lua
return {
    boids = 70,
    vision_angle = math.pi * 3 / 2,

    separation = {
        strength = 0.08,
        radius = 20
    },

    alignment = {
        strength = 0.04,
        radius = 50
    },

    cohesion = {
        strength = 0.01,
        radius = 80
    }
}
```

| Parameter | Description |
|---|---|
| `boids` | Number of birds in the simulation. |
| `vision_angle` | Angular field of view, in radians. |
| `separation.radius` | Maximum distance for separation. |
| `separation.strength` | Strength of the separation steering rule. |
| `alignment.radius` | Maximum distance for alignment. |
| `alignment.strength` | Strength of the alignment steering rule. |
| `cohesion.radius` | Maximum distance for cohesion. |
| `cohesion.strength` | Strength of the cohesion steering rule. |

Adjusting these values changes the density, responsiveness, and overall appearance of the flock.

## Performance

The simulation is intended to remain lightweight and suitable for experimentation on constrained hardware.

Potential optimizations include:

- Reducing repeated neighbor searches.
- Avoiding unnecessary temporary table allocations.
- Precomputing constant values.
- Using squared distances for range checks.
- Measuring simulation and rendering performance independently.
- Optimizing mathematical operations for the target ARM architecture where appropriate.

Actual performance depends on the target CPU, floating-point support, Lua runtime implementation, and graphics backend.

## Running

AVIS is intended to run inside the custom environment provided by the d3m0n-project Lua runtime.

It is not necessarily a standalone application for a conventional desktop Lua installation, because it depends on the runtime's `d3gl` API and graphics facilities.

For runtime setup and kernel instructions, refer to:

- [Lua runtime repository](https://github.com/d3m0n-project/lua)
- [d3m0n_os repository](https://github.com/d3m0n-project/d3m0n_os)

## Credits and Acknowledgements

- **d3m0n-project** - for the custom Lua runtime and the d3m0n_os kernel environment.
- **Craig Reynolds** - for the foundational boids model and flocking behavior concepts.

## License

AVIS is released under the MIT License.

The Lua runtime and operating system kernel are separate projects and remain subject to their respective licenses.
