-- Helper assignments and erata
g = love.graphics
math.randomseed(os.time())
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end

-- Put any game-wide requirements in here
require 'middleclass'
require 'Particle'
require 'Node'