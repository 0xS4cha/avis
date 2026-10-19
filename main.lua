local d3gl = require("d3gl")
local Colors = d3gl.Colors

local BACKGROUND = d3gl.hex("#0b1020")

local app = {}

function app.load()
end

function app.update(dt)
end

function app.draw()
    d3gl.clear(BACKGROUND)
    d3gl.draw_text(8, 8, "AVIS", Colors.WHITE, 2)
    d3gl.draw_fps(8, d3gl.height - 12)
    for i = 1, 10 do
        local x = d3gl.random_range(0, d3gl.width)
        local y = d3gl.random_range(0, d3gl.height)
        local r = d3gl.random_range(5, 20)
        local c = d3gl.hsv(d3gl.random_range(0, 360), 1, 1)
        d3gl.draw_circle(x, y, r, c)
    end
end

d3gl.run(app, { title = "avis" })
