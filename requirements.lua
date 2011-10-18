-- Helper assignments and erata
g = love.graphics
math.randomseed(os.time())
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end
function pointInCircle(circle, point) return (point.x-circle.x)^2 + (point.y - circle.y)^2 < circle.radius^2 end

-- Put any game-wide requirements in here
require 'middleclass'
require 'Particle'
require 'Node'