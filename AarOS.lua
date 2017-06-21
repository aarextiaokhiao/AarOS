--[[
AarOS Interperter 1.0
Created by Aarex

Read the readme.md for all of the commands.

TO DO:
Debug mode
]]--

-- Main variables
code,xPosition,yPosition,direction,memory,memoryPosition,output=io.read("*a"),1,1,0,{0},1,''

-- Functions
function getCharacterFromLocation(text,position)
 return string.sub(text,position,position)
end

function move()
 if direction == 0 then -- right
  xPosition = xPosition+1
 elseif direction == 1 then -- down
  yPosition = yPosition+1
 elseif direction == 2 then -- left
  xPosition = xPosition-1
 elseif direction == 3 then -- up
  yPosition = yPosition-1
 end
end

-- Splitting lines to store the lines
codeLineFind = code
lineCharacterNum = string.find(codeLineFind,"\n")
lines = {}
while not (lineCharacterNum==nil) do
 table.insert(lines,string.sub(codeLineFind,1,lineCharacterNum-1))
 codeLineFind = string.sub(codeLineFind,lineCharacterNum+1)
 lineCharacterNum = string.find(codeLineFind,"\n")
end
table.insert(lines,codeLineFind)

-- Get sizes
xSize = 0
ySize = 0
while true do
 ySize = ySize+1
 if lines[ySize] == nil then
  ySize = ySize-1
  break 
 end
 lineLength = string.len(lines[ySize])
 if xSize < lineLength then
  xSize = lineLength
 end
end
--print('X Size: '..xSize..', Y Size: '..ySize)

-- Preparation
stringMode = 0
input = arg[1]
debug = 0

-- Arugments
-- Coming soon!

-- Run
while true do
 if not (0 < xPosition and xSize+1 > xPosition and 0 < yPosition and ySize+1 > yPosition) then
  break
 end
 local command = getCharacterFromLocation(lines[yPosition],xPosition)
 --print('Command: '..command..', X: '..xPosition..', Y: '..yPosition..', Direction: '..direction)
 if not (command==nil) then
  if stringMode == 0 then -- Main commands
   if command=='+' then -- Increase cell
    memory[memoryPosition] = memory[memoryPosition]+1
   elseif command=='-' then -- Decrease cell
    memory[memoryPosition] = memory[memoryPosition]-1
   elseif command=='>' then -- Turn the pointer to right
    direction = 0
   elseif command=='<' then -- Turn the pointer to left
    direction = 2
   elseif command=='^' then -- Turn the pointer to up
    direction = 3
   elseif command=='v' then -- Turn the pointer to down
    direction = 1
   elseif command=='L' then -- Move to previous cell.
    if memoryPosition > 1 then
     memoryPosition = memoryPosition - 1
    end
   elseif command=='R' then -- Move to next cell.
    memoryPosition = memoryPosition + 1
   elseif command=='A' then -- Pop the next cell and add with the current cell.
    memory[memoryPosition] = memory[memoryPosition]+memory[memoryPosition+1]
    memory[memoryPosition+1] = 0
   elseif command=='M' then -- Pop the next cell and subtract the current cell by it.
    memory[memoryPosition] = memory[memoryPosition]-memory[memoryPosition+1]
    memory[memoryPosition+1] = 0
   elseif command=='P' then -- Pop the next cell and multiply with the current cell.
    memory[memoryPosition] = memory[memoryPosition]*memory[memoryPosition+1]
    memory[memoryPosition+1] = 0
   elseif command=='D' then -- Pop the next cell and divide the current cell by it.
    memory[memoryPosition] = memory[memoryPosition]/memory[memoryPosition+1]
    memory[memoryPosition+1] = 0
   elseif command=='S' then -- Skip the next command.
    move()
   elseif command=='I' then -- If the current cell is not 0, then skip a next command.
    if not (memory[memoryPosition] == 0) then
     move()
    end
   elseif command=='.' then -- Push the input to current cell.
    if not (input == nil) then
     memory[memoryPosition] = string.byte(string.sub(input,1,1))
     input = string.sub(input,2)
    else
     memory[memoryPosition] = 0
    end
   elseif command==',' then -- Pop a current cell, then output it as a character.
    output = output..string.char(memory[memoryPosition])
    memory[memoryPosition] = 0
   elseif command=='\'' then -- Start the simple string literal.
    stringMode = 1
   elseif command=='\\' then
    move()
    command = getCharacterFromLocation(lines[yPosition],xPosition)
    if command=='*' then -- Start the complex string literal.
     stringMode = 2
    else
     direction = (direction+2)%4
     move()
     direction = (direction+2)%4
    end
   elseif command=='&' then -- Remove the current cell.
    table.remove(memory,memoryPosition)
   elseif command=='%' then -- Pop a current cell, then output it as a number.
    output = output..memory[memoryPosition]
    memory[memoryPosition] = 0
   elseif command=='/' then -- Pop the next cell and 'mod' the current cell by it.
    memory[memoryPosition] = memory[memoryPosition] % memory[memoryPosition+1]
    memory[memoryPosition+1] = 0
   end
  elseif stringMode == 1 then -- Simple string literal
   if command=='\'' then -- End string literal
    stringMode = 0
   else -- Push character
    memory[memoryPosition] = string.byte(command)
    memoryPosition = memoryPosition+1
   end
  elseif stringMode == 2 then -- Complex string literal
   if command=='*' then
    move()
    command = getCharacterFromLocation(lines[yPosition],xPosition)
    if command=='\\' then -- End string literal.
     stringMode = 0
    else -- Push character
     memory[memoryPosition] = string.byte(command)
     memoryPosition = memoryPosition+1
     direction = (direction+2)%4
     move()
     direction = (direction+2)%4
    end
   else -- Push character
    memory[memoryPosition] = string.byte(command)
    memoryPosition = memoryPosition+1
   end
  end
 end
 if memory[memoryPosition] == nil then
  memory[memoryPosition] = 0
 end
 move()
 --print('Mode: '..stringMode..', Memory: '..memory[memoryPosition]..', Position: '..memoryPosition)
end

io.write(output)