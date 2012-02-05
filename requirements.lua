-- Helper assignments and erata
g = love.graphics
-- The pixel grid is actually offset to the center of each pixel. So to get clean pixels drawn use 0.5 + integer increments.
g.setPoint(2.5, "rough")
math.randomseed(os.time())
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end
function pointInCircle(circle, point) return (point.x-circle.x)^2 + (point.y - circle.y)^2 < circle.radius^2 end
globalID = 0
function generateID() globalID = globalID + 1 return globalID end

-- Put any game-wide requirements in here
require 'middleclass'
require 'base.lua'
require 'character.lua'
require 'level.lua'
require 'screen.lua'
require 'layer.lua'
Stateful = require 'stateful'
json = require('json')
