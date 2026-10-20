local d3gl = require("d3gl")
local config = require("src.config.simulation")
local bird = require("src.bird")
local Colors = d3gl.Colors
local random_range = d3gl.mathx.random_range
local BACKGROUND = d3gl.hex("#0b1020")

local app = {}

local simulation = {
    boids = {}
}

function app.load()
    for i = 1, config.boids do
        local x = random_range(0, d3gl.width)
        local y = random_range(0, d3gl.height)
        simulation.boids[#simulation.boids + 1] = bird(i, d3gl.vec2(x, y), math.pi / 4, simulation.boids)
    end
end

function app.update(dt)
    for i = 1, #simulation.boids do
        simulation.boids[i]:update()
    end
end

function app.draw()
    d3gl.clear(BACKGROUND)
    for i = 1, #simulation.boids do
        simulation.boids[i]:draw()
    end
end

d3gl.run(app, { title = "avis" })
