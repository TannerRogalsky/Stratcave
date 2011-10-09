function love.load()
  dofile('requirements.lua')

  major = Node:new(300,300,25)

  particles = {}
  for _ = 1,10,1 do
    table.insert(particles, Particle:new(math.random(100 - major.radius) + 300 + major.radius, math.random(100) + 300 + major.radius))
  end
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
    if particle.z == -1 then
      particle:draw()
    end
  end
  major:draw()
  for _, particle in ipairs(particles) do
    if particle.z == 1 then
      particle:draw()
    end
  end
end
