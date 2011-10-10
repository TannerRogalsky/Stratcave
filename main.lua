dofile('requirements.lua')

function love.load()
  love.mouse.setVisible(false)

  nodes = {}
  particles = {}

  table.insert(nodes, Node:new(300,300,50))
  table.insert(nodes, Node:new(600,300,50))
  generateParticles(nodes[1], 10)
  generateParticles(nil, 10)
end

function love.update(dt)
  for _, particle in ipairs(particles) do
    particle:update(dt)
  end
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end

function love.draw()
  for _, particle in ipairs(particles) do
    if particle.z == -1 then
      particle:draw()
    end
  end
  for _,node in ipairs(nodes) do
    node:draw()
  end
  for _, particle in ipairs(particles) do
    if particle.z == 1 then
      particle:draw()
    end
  end

  do -- draw the mouse area thing
    g.setLineStipple(0xF0)
    g.setColor(0,255,255)
    g.circle("line", love.mouse.getX(), love.mouse.getY(), 100, 50)
    g.setLineStipple(0xFFFF)
  end
end

function generateParticles(parent, num)
  for _ = 1,(num or 1),1 do
    if parent == nil then
      table.insert(particles, Particle:new(math.random(g.getWidth()), math.random(g.getHeight()))) 
    else
      if math.random() > 0.5 then
        table.insert(particles, Particle:new(math.random(100 - parent.radius) + 300 + parent.radius / 2, math.random(100) + 300 + parent.radius, parent))
      else
        table.insert(particles, Particle:new(math.random(100 - parent.radius) + 300 + parent.radius, math.random(100) + 300 + parent.radius / 2, parent))
      end
    end
  end
end
