local d3gl = require("d3gl")
local config = require("src.config.simulation")
local Colors = d3gl.Colors

local bird = d3gl.class()

function bird:init(id, coords, rot, boids)
    self.id = id
    self.coords = coords
    self.rot = rot
    self.boids = boids
end

function bird:update()
    self:separation()
    self:alignment()
    self:cohesion()
    self:move()
end

function bird:inFieldOfView(other)
    local dx = other.coords.x - self.coords.x
    local dy = -(other.coords.y - self.coords.y)
    local angle = math.atan(dy, dx)

    local diff = (angle - self.rot + math.pi) % (2 * math.pi) - math.pi
    return math.abs(diff) <= config.vision_angle / 2
end

function bird:BirdsinRange(min, max)
    local result = {}
    for _, other in ipairs(self.boids) do
        if other ~= self then
            local dist = self.coords:dist(other.coords)
            if dist > min and dist < max and self:inFieldOfView(other) then
                result[#result + 1] = other
            end
        end
    end
    return result
end

function bird:steerTowards(target, strength)
    local diff = (target - self.rot + math.pi) % (2 * math.pi) - math.pi
    self.rot = self.rot + diff * strength
end

function bird:cohesion()
    local neighbors = self:BirdsinRange(0, config.cohesion.radius)
    if #neighbors == 0 then return end

    local cx, cy = 0, 0
    for _, other in ipairs(neighbors) do
        cx = cx + other.coords.x
        cy = cy + other.coords.y
    end
    cx, cy = cx / #neighbors, cy / #neighbors

    local target = math.atan(-(cy - self.coords.y), cx - self.coords.x)
    self:steerTowards(target, config.cohesion.strength)
end

function bird:alignment()
    local neighbors = self:BirdsinRange(0, config.alignment.radius)
    if #neighbors == 0 then return end

    local sx, sy = 0, 0
    for _, other in ipairs(neighbors) do
        sx = sx + math.cos(other.rot)
        sy = sy + math.sin(other.rot)
    end

    self:steerTowards(math.atan(sy, sx), config.alignment.strength)
end

function bird:separation()
    local neighbors = self:BirdsinRange(0, config.separation.radius)
    if #neighbors == 0 then return end

    local rx, ry = 0, 0
    for _, other in ipairs(neighbors) do
        local dx = self.coords.x - other.coords.x
        local dy = self.coords.y - other.coords.y
        local d2 = dx * dx + dy * dy
        if d2 > 0 then
            rx = rx + dx / d2
            ry = ry + dy / d2
        end
    end
    if rx == 0 and ry == 0 then return end

    local target = math.atan(-ry, rx)
    self:steerTowards(target, config.separation.strength)
end

function bird:move()
    self.coords.x = (self.coords.x + math.cos(self.rot)) % d3gl.width
    self.coords.y = (self.coords.y - math.sin(self.rot)) % d3gl.height
end

function bird:calc_triangle(x, y, b, h, a)
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
    local x1, y1, x2, y2, x3, y3 = self:calc_triangle(
        self.coords.x, self.coords.y, 5, 10, math.pi / 2 - self.rot)
    d3gl.draw_triangle(x1, y1, x2, y2, x3, y3, Colors.WHITE, Colors.WHITE)
end

return bird