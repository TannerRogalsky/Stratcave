function love.load()
  dofile('requirements.lua')

  major = Node:new(300,300,50)

  particles = {}
  table.insert(particles, Particle:new(310,400,10))
  table.insert(particles, Particle:new(400,310,10))
  for _, particle in ipairs(particles) do
    major:addParticle(particle)
  end
end

function love.update(dt)
  for _, particle in ipairs(particles) do
    particle:update(dt)
  end
end

function love.draw()
  for _, particle in ipairs(particles) do
    if particle.deltax < 0 then
      particle:draw()
    end
  end
  major:draw()
  for _, particle in ipairs(particles) do
    if particle.deltax >= 0 then
      particle:draw()
    end
  end
end
