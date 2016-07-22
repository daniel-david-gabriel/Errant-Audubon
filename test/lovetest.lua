local lovetest = {}

lovetest._version = "0.1.0"

-- Search the passed in arguments for either -t or --test
function lovetest.detect(args) 
  for _, flag in ipairs(args) do
    if flag == "-t" or flag == "--test" then
      return true
    end
  end
  return false
end

-- Run the unit tests, On windows, don't quit. This allows the user to see the
-- test results in the console
function lovetest.run() 
  require "test/lunatest"

  lovetest.runTests("test")

  local opts = {verbose=true}
  local failures = lunatest.run(nil, opts)

  if love._os ~= "Windows" then
    if failures > 0 then
      os.exit(failures)
    else
      love.event.push("quit")
    end
  end
end

function lovetest.runTests(dir)
  for _, filename in ipairs(love.filesystem.getDirectoryItems(dir)) do
    if love.filesystem.isFile(dir .. "/" .. filename) and filename:match("^test_.*%.lua$") then
      local testname = (filename:gsub(".lua", ""))
      lunatest.suite(dir .. "/" .. testname)
    elseif love.filesystem.isDirectory(dir .. "/" .. filename) then
      lovetest.runTests(dir .. "/".. filename)
    end
  end
end

return lovetest
