return {
    boids = 50, -- smooth refresh rate at this amount
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