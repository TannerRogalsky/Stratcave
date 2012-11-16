require 'moan'
luafft = require "luafft"

horizontal_scale = love.graphics.getWidth() / 44100

function love.load()
  -- Moan.newSample(Moan.osc.sin(Moan.pitch(pitch, octave), amp))
  sample_rate = 1000
  sin_sample = Moan.newSample(Moan.osc.sin(Moan.pitch("a", 0), 0.3, sample_rate))
  sin_source = love.audio.newSource(sin_sample)

  complex_nums = {}
  transforms = {}

  for i=0,1023 do
    table.insert(complex_nums, complex.new(sin_sample:getSample(i), 0))
  end
  transforms = fft(complex_nums, false)
  for i,v in ipairs(transforms) do
    print(i,v)
  end

  active = false
  coords = {}
end

function love.update(dt)
  if active == false then return end

  prev_sample_index = sample_index or 0
  sample_index = sin_source:tell("samples")

  if sample_index > 0 then
    local ltranforms = {}
    for i=prev_sample_index,sample_index,44100 / sample_rate do
      local complex = complex.new(sin_sample:getSample(i), 0)
      table.insert(coords, ltranforms)
      table.insert(coords, complex)
      -- print(i, complex, sin_sample:getSample(i))
    end
    ltranforms = fft(ltranforms, false)
    table.insert(transforms, ltranforms)
    for i,v in ipairs(ltranforms) do
      print(i,v)
    end
    -- print(sample_index, complex)
  end
end

function love.draw()
  love.graphics.setColor(0,255,0)
  love.graphics.print(love.timer.getFPS(), 0, 0)
  love.graphics.setColor(255,255,255)
  for i,v in ipairs(coords) do
    if i > 1 then
      love.graphics.line(i * (44100 / sample_rate) * horizontal_scale,love.graphics.getHeight() / 2 + coords[i][1] * 100,
                        (i-1) * (44100 / sample_rate) * horizontal_scale,love.graphics.getHeight() / 2 + coords[i - 1][1] * 100)
    end
  end
  -- love.graphics.line(0,love.graphics.getHeight()/2, sample_index*horizontal_scale,love.graphics.getHeight()/2)
end

-- function love.keypressed(key)
--   if active == false then
--     active = true
--     love.audio.play(sin_source)
--   end
-- end
