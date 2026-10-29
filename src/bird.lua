
local d3gl = require("d3gl")
local config = require("src.config.simulation")
local Colors = d3gl.Colors

local bird = d3gl.class()

local cos = math.cos
local sin = math.sin
local atan = math.atan
local pi = math.pi

local TWO_PI = 2 * pi
local HALF_PI = pi * 0.5

local MOVE_SPEED = 60
local MAX_DT = 0.05

local FOV_COS = cos(config.vision_angle * 0.5)
local FOV_COS2 = FOV_COS * FOV_COS

local SEP_R = config.separation.radius
local ALI_R = config.alignment.radius
local COH_R = config.cohesion.radius

local SEP_R2 = SEP_R * SEP_R
local ALI_R2 = ALI_R * ALI_R
local COH_R2 = COH_R * COH_R

local SEP_STRENGTH = config.separation.strength
local ALI_STRENGTH = config.alignment.strength
local COH_STRENGTH = config.cohesion.strength

local function angle_diff(target, current)
    return (target - current + pi) % TWO_PI - pi
end

local function visible(dx, dy, d2, fx, fy)
    local dot = dx * fx + dy * fy

    if FOV_COS >= 0 then
        if dot < 0 then
            return false
        end
        return dot * dot >= FOV_COS2 * d2
    else
        if dot >= 0 then
            return true
        end
        return dot * dot <= FOV_COS2 * d2
    end
end

function bird:init(id, coords, rot, boids)
    self.id = id
    self.coords = coords
    self.rot = rot
    self.boids = boids

    self.px = coords.x
    self.py = coords.y
    self.pr = rot
end

function bird:snapshot()
    self.px = self.coords.x
    self.py = self.coords.y
    self.pr = self.rot
end

function bird:update(dt)
    if dt == nil or dt ~= dt or dt < 0 then
        dt = 0
    elseif dt > MAX_DT then
        dt = MAX_DT
    end

    local x = self.px
    local y = self.py
    local rot = self.pr

    local boids = self.boids
    local count = #boids

    local fx = cos(rot)
    local fy = sin(rot)

    local sepX, sepY = 0, 0
    local aliX, aliY = 0, 0
    local cohX, cohY = 0, 0

    local sepN, aliN, cohN = 0, 0, 0

    for i = 1, count do
        local other = boids[i]
        if other ~= self then
            local dx = other.px - x
            local screenDy = other.py - y
            local d2 = dx * dx + screenDy * screenDy

            if d2 > 0 and d2 < COH_R2 then
                local dy = -screenDy

                if visible(dx, dy, d2, fx, fy) then
                    if d2 < SEP_R2 then
                        sepX = sepX - dx
                        sepY = sepY - dy
                        sepN = sepN + 1
                    end

                    if d2 < ALI_R2 then
                        aliX = aliX + cos(other.pr)
                        aliY = aliY + sin(other.pr)
                        aliN = aliN + 1
                    end

                    cohX = cohX + dx
                    cohY = cohY + dy
                    cohN = cohN + 1
                end
            end
        end
    end

    local frameScale = dt * 60

    if sepN > 0 and (sepX ~= 0 or sepY ~= 0) then
        local target = atan(-sepY, sepX)
        rot = rot + angle_diff(target, rot)
            * SEP_STRENGTH * frameScale
    end

    if aliN > 0 and (aliX ~= 0 or aliY ~= 0) then
        local target = atan(aliY, aliX)
        rot = rot + angle_diff(target, rot) * ALI_STRENGTH * frameScale
    end

    if cohN > 0 and (cohX ~= 0 or cohY ~= 0) then
        local target = atan(cohY, cohX)
        rot = rot + angle_diff(target, rot) * COH_STRENGTH * frameScale
    end

    self.rot = rot

    local nx = x + cos(rot) * MOVE_SPEED * dt
    local ny = y - sin(rot) * MOVE_SPEED * dt

    local width = d3gl.width
    local height = d3gl.height

    if nx >= width then
        nx = nx - width
    elseif nx < 0 then
        nx = nx + width
    end

    if ny >= height then
        ny = ny - height
    elseif ny < 0 then
        ny = ny + height
    end

    self.coords.x = nx
    self.coords.y = ny
end


function bird:draw()
    local function drawTriangle(x, y, rot, color)
        local a = HALF_PI - rot
        local c, s = cos(a), sin(a)

        local x1 = x + (20 / 3) * s
        local y1 = y - (20 / 3) * c

        local x2 = x - 2.5 * c - (10 / 3) * s
        local y2 = y - 2.5 * s + (10 / 3) * c

        local x3 = x + 2.5 * c - (10 / 3) * s
        local y3 = y + 2.5 * s + (10 / 3) * c

        d3gl.draw_triangle(
            x1, y1, x2, y2, x3, y3,
            color, color
        )
    end

    -- erase tracks
    if self.drawn then
        drawTriangle(self.lastX, self.lastY, self.lastRot, d3gl.hex("#0b1020"))
    end

    -- draw bird
    drawTriangle(self.coords.x, self.coords.y, self.rot, Colors.WHITE)

    self.lastX = self.coords.x
    self.lastY = self.coords.y
    self.lastRot = self.rot
    self.drawn = true
end


return bird
