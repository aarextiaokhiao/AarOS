--[[
AarOS Interperter ?.?
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
     stringMode = 0
