--[[
AarOS Interpreter 1.2
AarOS Version Interpreted: 1.2
Created by Aarex

Read the readme.md for all of the commands.
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

function nextCommand(xPosition,yPosition,direction)
 if direction == 0 then -- right
  xPosition = xPosition+1
 elseif direction == 1 then -- down
  yPosition = yPosition+1
 elseif direction == 2 then -- left
  xPosition = xPosition-1
 elseif direction == 3 then -- up
  yPosition = yPosition-1
 end
 local nextCommand = getCharacterFromLocation(lines[yPosition],xPosition)
 if nextCommand == nil then
  return ''
 else
  return nextCommand
 end
end

-- Variables from arugments
debug = false
verbose = false
version = 4

-- Arugments
for number,flag in ipairs(arg) do
 if number > 1 then
  if string.sub(flag,1,2) == '-h' then
   print('Help:')
   print('-d: Debug mode')
   print('-v: Verbose mode')
   print('-r: Run in different versions')
   os.exit()
  end
  if string.sub(flag,1,2) == '-d' then
   debug = true
  end
  if string.sub(flag,1,2) == '-v' then
   verbose = true
  end
  if string.sub(flag,1,2) == '-r' then
   if string.sub(flag,3,3) ~= ' ' then -- No given version
    print('Help:')
    print('-r 1.0: Run in version 1.1')
    print('-r 1.1: Run in version 1.1')
    print('-r 1.1.1: Run in version 1.1.1')
    print('-r 1.2: Run in version 1.2')
    os.exit()
   elseif string.sub(flag,4) == '1.0' then -- Pre-development version
    version = 1
   elseif string.sub(flag,4) == '1.1' then  -- First release version
    version = 2
   elseif string.sub(flag,4) == '1.1.1' then
    version = 3
   elseif string.sub(flag,4) == '1.2' then
    version = 4
   else
    print('Wrong version!')
    os.exit()
   end
  end
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

-- Preparation
stringMode = 0
if version > 3 then
 popMode = 1
else
 popMode = 2
end
input = arg[1]

-- Popping
function pop2Cells(memoryPosition)
 local a,b
 if popMode == 1 then
  a,b=memory[memoryPosition],memory[memoryPosition+1]
 else
  a,b=memory[memoryPosition+1],memory[memoryPosition]
 end
 memory[memoryPosition] = 0
 memory[memoryPosition+1] = 0
 return a,b
end

-- Run
while true do
 if not (0 < xPosition and xSize+1 > xPosition and 0 < yPosition and ySize+1 > yPosition) then
  break
 end
 if memory[memoryPosition-1] == nil then
  memory[memoryPosition-1] = 0
 end
 if memory[memoryPosition] == nil then
  memory[memoryPosition] = 0
 end
 if memory[memoryPosition+1] == nil then
  memory[memoryPosition+1] = 0
 end
 local command = getCharacterFromLocation(lines[yPosition],xPosition)
 if verbose then print('Command: '..command..', X: '..xPosition..', Y: '..yPosition..', Direction: '..direction) end
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
   elseif command=='A' then -- Addition
    local cell1,cell2 = pop2Cells(memoryPosition)
    memory[memoryPosition] = cell1+cell2
    memory[memoryPosition+1] = 0
   elseif command=='M' then
    local nCommand = nextCommand(xPosition,yPosition,direction)
    if version > 3 and nCommand == '/' then -- Mirrors
     move()
     if direction == 0 then
      direction = 3
     elseif direction == 1 then
      direction = 2
     elseif direction == 2 then
      direction = 1
     elseif direction == 3 then
      direction = 0
     end
    elseif version > 3 and nCommand == '\\' then -- Mirrors
     move()
     if direction == 0 then
      direction = 1
     elseif direction == 1 then
      direction = 0
     elseif direction == 2 then
      direction = 3
     elseif direction == 3 then
      direction = 2
     end
    elseif version < 3 then -- Subtraction
     local cell1,cell2 = pop2Cells(memoryPosition)
     memory[memoryPosition] = cell1-cell2
    else
     memory[memoryPosition] = memory[memoryPosition]-memory[memoryPosition+1]
    end
    memory[memoryPosition+1] = 0
   elseif command=='P' then -- Multiplication
    local cell1,cell2 = pop2Cells(memoryPosition)
    memory[memoryPosition] = cell1*cell2
    memory[memoryPosition+1] = 0
   elseif command=='D' then -- Division
    if not (memory[memoryPosition+1]==0) then
     local cell1,cell2 = pop2Cells(memoryPosition)
     memory[memoryPosition] = cell1/cell2
     memory[memoryPosition+1] = 0
    end
   elseif command=='S' then -- Skip
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
    if version > 2 then
     memory[memoryPosition] = 0
    end
   elseif command=='@' then -- End program
    break
   elseif version > 1 and (version < 3 and command=='\'') or (version > 2 and command=='\"') then -- Start the simple string literal.
    stringMode = 1
   elseif version > 1 and command=='\\' then
    local nCommand = nextCommand(xPosition,yPosition,direction)
    if nCommand=='*' then -- Start the complex string literal.
     move()
     stringMode = 2
    else
     if popMode == 1 then
      popMode = 2
     else
      popMode = 1
     end
    end
   elseif version > 1 and command=='&' then -- Remove the current cell.
    table.remove(memory,memoryPosition)
   elseif version > 1 and command=='%' then -- Pop a current cell, then output it as a number.
    output = output..memory[memoryPosition]
    if version > 2 then
     memory[memoryPosition] = 0
    end
   elseif version > 1 and command=='/' then -- Pop the next cell and 'mod' the current cell by it.
    if not (memory[memoryPosition+1]==0) then
     memory[memoryPosition] = memory[memoryPosition] % memory[memoryPosition+1]
     memory[memoryPosition+1] = 0
    end
   elseif version > 3 and command=='\'' then -- Start a number literal
    stringMode = 3
   elseif version > 3 and command=='E' then -- Exponentiation
    local cell1,cell2 = pop2Cells(memoryPosition)
    memory[memoryPosition] = cell1^cell2
    memory[memoryPosition+1] = 0
   elseif version > 3 and command=='$' then -- Pop
    memory[memoryPosition] = 0
   elseif version > 3 and command=='#' then -- Swap cells    
    local swapMemory = memory[memoryPosition] 
    memory[memoryPosition] = memory[memoryPosition+1]
    memory[memoryPosition+1] = swapMemory
   elseif version > 3 and command=='`' then -- Copy cell   
    memory[memoryPosition+1] = memory[memoryPosition]
   end
  elseif stringMode == 1 then -- Simple string literal
   if (version < 3 and command=='\'') or (version > 2 and command=='\"') then -- End string literal
    stringMode = 0
   else -- Push character
    memory[memoryPosition] = string.byte(command)
    memoryPosition = memoryPosition+1
   end
  elseif stringMode == 2 then -- Complex string literal
   if command=='*' then
    local nCommand = nextCommand(xPosition,yPosition,direction)
    if nCommand=='\\' then -- End string literal.
     move()
     stringMode = 0
    else -- Push character
     memory[memoryPosition] = string.byte(command)
    end
   else -- Push character
    memory[memoryPosition] = string.byte(command)
    memoryPosition = memoryPosition+1
   end
  elseif stringMode == 3 then -- Number literal
   if command == '\'' then -- End string literal
    stringMode = 0
   elseif string.byte(command) > 47 and string.byte(command) < 58 then -- Push number
    memory[memoryPosition] = command
    memoryPosition = memoryPosition+1
   end
  end
 end
 move()
 if verbose then print('String Mode: '..stringMode..', Pop Mode: '..popMode..', Memory: '..memory[memoryPosition]..', Position: '..memoryPosition) end
end

if debug then
 if verbose then print() end
 local verNames = {"1.0","1.1","1.1.1","1.2"}
 print('String Mode: '..stringMode)
 print('Pop Mode: '..popMode)
 print('Version: '..verNames[version])
 print('X Size: '..xSize..', Y Size: '..ySize)
 print('Final position: ('..xPosition..','..yPosition..')')
 local dirNames = {"Right","Down","Left","Up"}
 print('Final direction: '..dirNames[direction+1])
 print('Memory: ')
 mem = ''
 for _,num in ipairs(memory) do
  mem = mem..num..','
 end
 mem = string.sub(mem,1,string.len(mem)-1)
 print(mem)
 print('Output: ')
elseif verbose then
 print()
end

io.write(output)