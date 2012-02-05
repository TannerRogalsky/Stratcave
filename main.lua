dofile('requirements.lua')

function love.load()
  local lfs = love.filesystem
  levels = lfs.enumerate("levels")
  for i,v in ipairs(levels) do
    level = love.filesystem.read("levels/"..v)
    print(level)
    for k,v in pairs(json.decode(level)) do
      if k == "layout" then
        for i,v in ipairs(v) do
          print(i,unpack(v))
        end
      else
        print(k,v)
      end
    end
  end
end

function love.update(dt)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  if key == 'q' or key == 'escape' then
    os.exit(1)
  end
end

function love.keyreleased(key, unicode)
end

function love.draw()
end
