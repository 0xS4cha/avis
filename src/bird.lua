local d3gl = require("d3gl")
local Colors = d3gl.Colors

local bird = d3gl.class()

function bird:init(id, coords, rot, boids)
    self.id = id
    self.coords = coords
    self.rot = rot
    -- self.boids = boids
end

function bird:update()
    self:separation()
    self:alignment()
    self:cohesion()
    -- self:move()
end

function bird:cohesion()
    -- for i = 1, #self.boids do
    --     print(self.coords:dist(self.boids[i].coords))
    -- end
end

function bird:alignment()
end

function bird:separation()
end

local function calc_triangle(x, y, b, h, a)
  a = a or 0
  local c, s = math.cos(a), math.sin(a)
  local function rot(dx, dy)
    return x + dx*c - dy*s, y + dx*s + dy*c
  end
  local x1, y1 = rot(0,     -2*h/3)
  local x2, y2 = rot(-b/2,   h/3)
  local x3, y3 = rot( b/2,   h/3)
  return x1, y1, x2, y2, x3, y3
end

function bird:draw()
    d3gl.draw_triangle(calc_triangle(self.coords.x, self.coords.y, 1.0, 1.0, self.rot), Colors.WHITE)
end

return bird