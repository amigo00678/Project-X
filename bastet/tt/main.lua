
------------------

-- timer
gTimer = nil

------------------

cBstOn = true

------------------

-- class declarations

local cell = {}
cell.__index = cell

local shape = {}
shape.__index = shape

local board = {}
board.__index = board

local manager = {}
manager.__index = manager

------------------

-- global instance of manager class

local instManager = nil

------------------
-- classes for bastard algorithm
------------------

-- bastard board for evaluation

local boardBst = {}
boardBst.__index = boardBst

-- decision tree

local decTree = {}
decTree.__index = decTree

------------------

-- cell image width and height

cImageWidth = 20
cImageHeight = 20

------------------

-- board width and height

cBoardWidth = 16
cBoardHeight = 20

------------------

-- the initial position of new shape

cOriginX = math.floor(cBoardWidth / 2) - 2
cOriginY = 1

------------------

-- score and rows to display at the end of the game

cScore = 0
cRows = 0

------------------

-- images

cEmpty = nil
cBlue = nil
cGreen = nil
cPurple = nil
cGrey = nil
cOrange = nil
cViolet = nil
cBlueL = nil

cSplash = nil
cPause = nil

------------------

-- sound

cSound = nil
	
------------------

-- a flag to indicate start of new game
-- used for synchronisation between draw/update/timer function

createNewManager = true

------------------

-- shapes and their rotations

cShape1 = {
	-- first shape and it's rotations, a stick
	{{2, 1, 1, 1}, {2, 1, 1, 1}, {2, 1, 1, 1}, {2, 1, 1, 1}},
	{{2, 2, 2, 2}, {1, 1, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}},
}
	
cShape2 = {
	-- second shape, square
	{{2, 2, 1, 1}, {2, 2, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}},
}

cShape3 = {
	-- third shape, left zigzag
	{{2, 2, 1, 1}, {1, 2, 2, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}},
	{{1, 2, 1, 1}, {2, 2, 1, 1}, {2, 1, 1, 1}, {1, 1, 1, 1}},
}

cShape4 = {
	-- forth shape, right zigzag
	{{1, 2, 2, 1}, {2, 2, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}},
	{{2, 1, 1, 1}, {2, 2, 1, 1}, {1, 2, 1, 1}, {1, 1, 1, 1}},
}

cShape5 = {
	-- fifth shape, star
	{{2, 2, 2, 1}, {1, 2, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}},
	{{2, 1, 1, 1}, {2, 2, 1, 1}, {2, 1, 1, 1}, {1, 1, 1, 1}},
	{{1, 2, 1, 1}, {2, 2, 2, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}},
	{{1, 2, 1, 1}, {2, 2, 1, 1}, {1, 2, 1, 1}, {1, 1, 1, 1}},
}

cShape6 = {
	-- sixth shape, left horse
	{{2, 2, 1, 1}, {2, 1, 1, 1}, {2, 1, 1, 1}, {1, 1, 1, 1}},
	{{2, 1, 1, 1}, {2, 2, 2, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}},
	{{1, 2, 1, 1}, {1, 2, 1, 1}, {2, 2, 1, 1}, {1, 1, 1, 1}},
	{{2, 2, 2, 1}, {1, 1, 2, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}},
}

cShape7 = {
	-- seventh shape, right horse
	{{2, 2, 1, 1}, {1, 2, 1, 1}, {1, 2, 1, 1}, {1, 1, 1, 1}},
	{{2, 2, 2, 1}, {2, 1, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}},
	{{2, 1, 1, 1}, {2, 1, 1, 1}, {2, 2, 1, 1}, {1, 1, 1, 1}},
	{{1, 1, 2, 1}, {2, 2, 2, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}},
}

------------------
-- states
------------------

-- board cell state
local empty, filled = 1, 2

-- game states
local idle, play, pause, over, stopped = 1, 2, 3, 4, 5

------------------

-- love load function

function love.load()

	-- using hump timer
	gTimer = require "hump.timer"

	love.keyboard.setKeyRepeat(true)
	
	-- load images
	
	cEmpty = love.graphics.newImage("empty.png")
	cBlue = love.graphics.newImage("blue.png")
	cGreen = love.graphics.newImage("green.png")
	cPurple = love.graphics.newImage("purple.png")
	cGrey = love.graphics.newImage("grey.png")
	cOrange = love.graphics.newImage("orange.png")
	cViolet = love.graphics.newImage("violet.png")
	cBlueL = love.graphics.newImage("blueL.png")
	
	cSplash = love.graphics.newImage("splash.png")
	cPause = love.graphics.newImage("pause.png")
	
	-- load sond
	
	cSound = love.audio.newSource("Alessandra_Celletti__Jaan_Patterson_-_04_-_La_Trama_dei_Sogni.mp3")
	cSound:setVolume(0.9)
	cSound:setPitch(0.5)
	
end

------------------

-- love key pressed

function love.keypressed(key, isrepeat)

	if key == 'a' then
		instManager.currentShape:move(-1, 0)
	elseif key == 'd' then
		instManager.currentShape:move(1, 0)
	elseif key == 'w' then
		instManager.currentShape:rotate()
	elseif key == 's' then
		instManager.currentShape:move(0, 1)
	elseif key == 'p' then
		if instManager.state == play then
			instManager.state = pause
		elseif instManager.state == pause then
			instManager.state = play
		end
	elseif key == 'n' then
		createNewManager = true
	end
	
end

------------------

-- love update

function love.update(dt)

	gTimer.update(dt)
	
	if createNewManager then
		instManager = {}
		instManager.__index = manager
		instManager = manager.create()
		instManager.counter = 3
		instManager:init()
		createNewManager = false
	end
	
end

------------------

-- place in xy coordinates to draw pending figure

cTableOffset = 3 + cBoardWidth

-- place in pixels to draw side text

cTableImagePos = cTableOffset * cImageWidth

------------------

-- helper function to resize image

function setImageSize(image, x, y)
	return x / image:getWidth(), y / image:getHeight()
end

------------------

-- love draw

function love.draw()
	
	if instManager.state == idle then

		-- before start of the game
	
		love.graphics.draw(cSplash, cImageWidth, cImageHeight, 0,
			setImageSize(cSplash, cBoardWidth * cImageWidth, cBoardHeight * cImageHeight))
		
	elseif instManager.state == pause then
	
		-- paused
	
		love.graphics.draw(cPause, cImageWidth, cImageHeight, 0,
			setImageSize(cPause, cBoardWidth * cImageWidth, cBoardHeight * cImageHeight))
		
		love.graphics.print('Paused! Press \'p\' to continue', cTableImagePos, 100)
		
	elseif instManager.state == over then
	
		-- game finished
		
		love.graphics.print('         Game over!\n\n\n\n     Score: '..
			cScore..' Rows: '..cRows..'\n\n\n\nPress \'n\' to start new game',
			cTableImagePos, 100)
	
	elseif instManager.state == play then
	
		-- playing
	
		-- paint board, shape, pending shape
		instManager.board:draw()
		instManager.currentShape:draw()
		--instManager.pendingShape:drawOf(cTableOffset, 5)
	
		-- draw side text
		
		love.graphics.print('Use \'w a s d\' to control figure, \'p\' to pause, \'n\' for new game',
			cTableImagePos, 20)
			
		love.graphics.print('Score: '..instManager.score..' Rows: '..instManager.rows,
			cTableImagePos, 60)
			
		--love.graphics.print('Next figure:',
			--cTableImagePos, 100)
	end
	
end

------------------
-- cell class
-- the minimum unit of operation, shape consists of cells, board consists of cells
------------------

-- ctor

function cell.create(state, x, y, index)

	local c = {}
	c.__index = c
	setmetatable(c, cell)
	
	-- filled or empty
	c.state = state
	
	-- position
	c.x = x
	c.y = y
	c.offsetX = 0
	c.offsetY = 0
	
	-- index of a shape
	c.index = index
	
	return c
	
end

------------------

-- check if a cell can be moved by offsets

function cell:canMove(dx, dy)
	
	-- new position
	local nx = self.x + dx
	local ny = self.y + dy
	
	local cell = instManager.board:getCell(nx, ny)

	if not cell or cell.state == filled then
		return false
	else
		return true
	end

end

------------------

-- displace cell

function cell:move(dx, dy)

	self.offsetX = self.offsetX + dx
	self.offsetY = self.offsetY + dy
	
	self.x = self.x + dx
	self.y = self.y + dy
	
end

------------------
-- shape class
-- a combination of cells
------------------

-- ctor

function shape.create(x, y)

	local index = love.math.random(1, 7)
	return shape.createIndex(x, y, index)

end

------------------

function shape.createIndex(x, y, index)

	--print('shape.create'..'; x: '..x..'; y: '..y)
	
	local s = {}
	
	s.__index = s
	setmetatable(s, shape)

	-- index from cShapes
	
	if index == 0 then
		s.index = love.math.random(1, 7)
	else
		s.index = index
	end
	
	s.cShape = shape.getShapeByIndex(s.index)
	
	-- crete shape cells
	
	s.cells = {}
	
	for i = 1, 4 do
		for j = 1, 4 do
		
			if s.cShape[1][i][j] == filled then
			
				local cell = cell.create(filled, i, j, s.index)
				cell:move(x, y)

				-- check if there is a place for this cell
				
				s:checkCanCreate(cell.x, cell.y)
				
				table.insert(s.cells, cell)
			end

		end
	end
	
	-- initial rotation of the shape
	s.rotation = 1
	
	return s
end

------------------

-- clone a shape

------------------

function shape.clone(shapeSrc)

	local s = {}
	
	s.__index = s
	setmetatable(s, shape)
	
	s.cShape = shapeSrc.cShape
	s.index = shapeSrc.index
	
	s.cells = {}
	
	for key, value in pairs(shapeSrc.cells) do
		
		local cellInst = cell.create(value.state, value.x, value.y, value.index)
		
		-- index of a shape
		cellInst.index = value.index
	
		cellInst.x = value.x
		cellInst.y = value.y
		
		cellInst.offsetX = value.offsetX
		cellInst.offsetY = value.offsetY
		
		cellInst.state = value.state
		
		table.insert(s.cells, cellInst)
	end
	
	s.rotation = shapeSrc.rotation
	
	return s
	
end

------------------

-- check if the pace to create a shape is free

function shape:checkCanCreate(x, y)

	if not createNewManager and instManager then
		local boardCell = instManager.board:getCell(x, y)
		
		if not cell or boardCell.state == filled then
			instManager:over()
			cScore = instManager.score
			cRows = instManager.rows
		end
	end

end

------------------

-- get hard coded shapes

function shape.getShapeByIndex(index)

	if index == 1 then
		return cShape1
	elseif index == 2 then
		return cShape2
	elseif index == 3 then
		return cShape3
	elseif index == 4 then
		return cShape4
	elseif index == 5 then
		return cShape5
	elseif index == 6 then
		return cShape6
	elseif index == 7 then
		return cShape7
	end

end

------------------

-- check if a shape can be moved
-- possible if all cells can be moved

function shape:canMove(dx, dy)

	for key, value in pairs(self.cells) do
		if not value:canMove(dx, dy) then
			return false
		end
	end
	
	return true
end

------------------

-- displace shape by offsets

function shape:move(dx, dy)
	
	if not self:canMove(dx, dy) then
		return false
	end
	
	for key, value in pairs(self.cells) do
		value:move(dx, dy)
	end
	
	return true
	
end

------------------

-- shape painting

function shape:draw()

	local manager = instManager
	local image = manager.board:getImageByIndex(manager.currentShape.index)
			
	for key, value in pairs(self.cells) do

		if value.state == filled then
			love.graphics.draw(image, value.x * cImageWidth, value.y * cImageHeight)
		end

	end

end

------------------

-- shape painting by offset

function shape:drawOf(offx, offy)

	local manager = instManager
	local image = manager.board:getImageByIndex(manager.pendingShape.index)
	
	for key, value in pairs(self.cells) do

		if value.state == filled then
			love.graphics.draw(image, (offx + value.x) * cImageWidth, (offy + value.y) * cImageHeight)
		end

	end

end

------------------

-- rotate a shape
-- use predefined rotations

function shape:rotate()

	return self:rotateCheck(true)

end

------------------

function shape:rotateCheck(check)

	local rot = self.rotation
	local cShape = shape.getShapeByIndex(self.index)
	local shapesNum = table.getn(cShape)
	
	if rot + 1 <= shapesNum then
		rot = rot + 1
	else
		rot = 1
	end
	
	-- translation from world to local coordinates
	
	local offsetX = self.cells[1].offsetX
	local offsetY = self.cells[1].offsetY
	
	-- create a new shape from predefined
	
	local cells = {}
	
	for i = 1, 4 do
		for j = 1, 4 do
		
			if self.cShape[rot][i][j] == filled then
				local cell = cell.create(filled, i, j, self.index)
				cell:move(offsetX, offsetY)
				table.insert(cells, cell)
			end

		end
	end
	
	local canRotate = true
			
	if check then
	
		-- check if new position of shape is free
		-- if so assign new shape
	
		for key, value in pairs(cells) do
			--print('x,y: '..value.x..';'..value.y)
			local cell = instManager.board:getCell(value.x, value.y)
		
			--if cell then
				--print('state: '..cell.state)
			--end
		
			if not cell or cell.state == filled then
				canRotate = false
				print('cant rotate')
				break
			end
		end
	end
	
	-- rotate if valid rotation
	
	if canRotate then
		self.cells = cells
		self.rotation = rot
	end
	
end

------------------
-- board class
-- board is where the action happens
-- the cells are stored in board by names for faster access
-- a cell name is 'x..y' coordinates, see board:getCell() function
------------------

-- ctor

function board.create(w, h)
	print('board.create')

	local b = {}
	setmetatable(b, board)
	
	
	-- create cells
	b.cells = {}
	local name = ''
	
	-- insert top and bottom rows
	for i = 1, w do
		name = i..';1'
		b.cells[name] = cell.create(filled, i, 1, 1)
		name = i..';'..h
		b.cells[name] = cell.create(filled, i, h, 1)
	end
	
	-- insert inside rows
	for i = 2, h - 1 do

		name = '1;'..i
		b.cells[name] = cell.create(filled, 1, i, 1)
		
		for j = 2, w - 1 do
			name = j..';'..i
			b.cells[name] = cell.create(empty, j, i, 1)
		end
		
		name = w..';'..i
		b.cells[name] = cell.create(filled, w, i, 1)
		
	end
	
	-- store width and height
	b.w = w
	b.h = h
	
	return b
end

------------------

-- board can give cell image by cell image index

function board:getImageByIndex(index)

	if index == 1 then
		return cBlue
	elseif index == 2 then
		return cGreen
	elseif index == 3 then
		return cPurple
	elseif index == 4 then
		return cGrey
	elseif index == 5 then
		return cOrange
	elseif index == 6 then
		return cViolet
	elseif index == 7 then
		return cBlueL
	end

end

------------------

-- drawing the board

function board:draw()
	
	local manager = instManager
	local image = cEmpty
	
	for key, value in pairs(self.cells) do

		if value.state == empty then
			image = cEmpty
		else
			image = self:getImageByIndex(value.index)
		end
		
		love.graphics.draw(image, value.x * cImageWidth, value.y * cImageHeight)
		
	end

end

------------------

-- find a cell with specific coordinates

function board:getCell(x, y)
	name = x..';'..y
	return self.cells[name]
end

------------------

-- add a shape to board
-- if shape is added to board it becomes a part of it
-- and cannot move any more

function board:addShape(shape)
	
	for key,value in pairs(shape.cells) do
	
		cell = self:getCell(value.x, value.y)
		
		if cell then
			cell.state = filled
		end
		
		-- copy index to keep shape color after it was moved to board
		--cell.index = value.index
	end
	
end

------------------

-- print evaluation board to terminal
-- for debug only

------------------

function board:printBrd()

	for i = 1, self.w do
		for j = 1, self.h do
		
			local cell = self:getCell(i, j)
			
			if cell and cell.state == filled then
				io.write('2')
			else
				io.write('1')
			end
			
		end
		
		print('<')
		
	end

	print('\n')
end

------------------

-- check if rows filled, shift upper rows if so,
-- update score, rows count

function board:checkRows()

	local numRows = 0
	local cell, cellAbove = nil, nil
	local rowReady = true
	
	-- for all rows inside the board check if they are filled
	
	for row = 2, self.h - 1 do
		
		rowReady = true
		
		for column = 2, self.w - 1 do

			cell = self:getCell(column, row)
			
			if not cell or cell.state == empty then
				rowReady = false
				break;
			end
			
		end

		-- if a row was filled
		
		if rowReady then
		
			-- move all rows above it down by 1
			
			for rowAbove = row, 3, -1 do
				
				--print('row above: '..rowAbove..';'..rowAbove - 1)
				
				for i = 2, self.w - 1 do
				
					cellAbove = self:getCell(i, rowAbove - 1)
					cell = self:getCell(i, rowAbove)
					
					if cellAbove and cell then
						cell.state = cellAbove.state
					end
					
				end
			end
		
			-- the second row should always be filled with empty cells
			
			for i = 2, self.w - 1 do
			
				cell = self:getCell(i, 2)
				
				if cell then
					cell.state = empty
				end
				
			end
			
			-- increase number of filled rows
			
			numRows = numRows + 1
			
		end
		
	end
	
	-- update score, rows count
	
	if numRows > 0 then
		instManager.score = instManager.score + 10 * numRows * numRows
		instManager.rows = instManager.rows + numRows
	end

end

------------------
-- manager class
-- a class to operate on all the data/states
------------------

-- ctor

function manager.create()

	print('manager.create')
	local m = {}
	setmetatable(m, manager)
	
	-- state
	m.state = idle
	
	-- board
	m.board = board.create(cBoardWidth, cBoardHeight);
	
	m.currentShape = shape.create(cOriginX, cOriginY)
	m.pendingShape = shape.create(cOriginX, cOriginY)
	
	-- speed of update
	m.timerOut = 1
	
	
	m.score = 0
	m.rows = 0

	-- a counter for splash screen delay
	m.counter = 0
	
	if cBstOn then
		-- a bastartd board
		m.boardBst = {}
	end
	
	return m

end

------------------

function manager:init()
	
	if cBstOn then
		-- create a board clone for the algorithm
		self.boardBst = boardBst.create(cBoardWidth, cBoardHeight)
	end
	
	-- play some sound
	self.play()
	
	-- add a function to be called on time out
	gTimer.add(self.timerOut, function(func) self:timerFunction() gTimer.add(self.timerOut, func) end)

end

------------------

-- indicate that the game has finished

function manager:over()
	
	-- update state
	
	self.state = over
	
end
------------------

-- start sound

function manager:play()

	cSound:play()

end

------------------

-- update function

function manager:timerFunction()

	if self.state == idle then
	
		-- game has not started yet
		-- show splash for a while
		
		self.counter = self.counter + 1
		
		if self.counter > 2 then
			self.state = play
			self.counter = 0
			cScore = 0
			cRows = 0
		end
		
	elseif self.state == pause then
	
		-- paused, not updates
		return
		
	elseif self.state == over then
	
		-- do nothing
		return
		
	elseif self.state == play then
		
		-- operational state update all
		
		if not self.currentShape:move(0, 1) then
			self.board:addShape(self.currentShape)
			--self.currentShape = self.pendingShape
			
			if cBstOn then
				self.boardBst:update(self.board)
				local index = self.boardBst:getNextShapeIndex()
				self.currentShape = shape.createIndex(cOriginX, cOriginY, index)
			else
				self.currentShape = shape.create(cOriginX, cOriginY)
			end
			
			self.board:checkRows()
		end
	end

end


------------------
-- bastard algorithm
------------------

function decTree.create(w)

	print('decTree.create')
	
	local dt = {}
	dt.__index = decTree
	setmetatable(dt, decTree)
	
	-- creating nodes at start up
	-- for all shapes for all rotations add all positions add a node
	-- later all the nodes (shapes) will be added to the board clone
	-- to evaluate their value
	
	dt.nodes = {}
	
	for index = 1, 7 do
	
		local cShape = shape.getShapeByIndex(index)
		
		-- get number of rotations
		local rotations = table.getn(cShape)
	
		-- create a shape by index
		local shapeInst = shape.createIndex(1, cOriginY, index)
		
		-- for browse all possible rotations and possible position
		for rotation = 1, rotations do
		
			-- after creation a shape has rotation 1 so no need to rotate it
			if rotation > 1 then
				shapeInst:rotateCheck(false)
			end
			
			-- move shape to the very left position
			while shapeInst:move(-1, 0) do
				--print('moved to: '..shapeInst.cells[1].x)
			end
			
			-- add a shape at it's left position
			dt:addNode(shapeInst)
			
			-- move shape by one position to the right and add a node at each move
			while shapeInst:move(1, 0) do
				dt:addNode(shapeInst)
			end
		end
	end

	return dt
	
end

------------------

-- nodes are the shape + rotation + position combinations used for evaluation
-- of their drop

function decTree:addNode(shapeSrc)

	--print('add node: index '..shape.index..'; rot '..shape.rotation..'; x '..shape.cells[1].x)
	
	table.insert(self.nodes, shape.clone(shapeSrc))

	--print('nodes: '..#self.nodes)
	
end

------------------
-- create a clone of the board for score math
------------------

function boardBst.create(w, h)

	print('boardBst.create')

	local board = {}
	board.__index = board
	setmetatable(board, boardBst)
	
	board.cells = {}
	
	board.decTree = decTree.create(w)
	
	--print('tree size: '..table.getn(board.decTree.nodes))
	
	board.w = w
	board.h = h

	board.prevIndex = 1
	
	return board
	
end

------------------
-- copy the play board to evaluation board
------------------

function boardBst:update(boardInst)

	--print('board update')
	
	for key, value in pairs(boardInst.cells) do
		
		local cellInst = self:getCell(value.x, value.y)
		
		if not cellInst then
			self.cells[value.x..';'..value.y] = 
				cell.create(value.state, value.x, value.y, value.index)
		else
			cellInst.state = value.state
		end
		
	end

end

------------------

-- score evaluation function

------------------

function boardBst:evaluate(shape)

	-- print('calculate new scores')

	local height = self:getHeight()
	
	-- move shape down as much as possible
	while shape:move(0, 1) do
		--print('moved by 1 down')
	end
	
	-- check if a shape can be placed on the board
	
	local cellInst = nil
	
	for key, value in pairs(shape.cells) do
		cellInst = self:getCell(value.x, value.y)
		if not cell or cellInst.state == filled then
			return 0
		end
	end
	
	
	-- add shape cells to board cells
	self:addShape(shape)
	
	-- check if rows were filled
	score = self:checkRows() * 1000000

	-- check if the number of rows with at least one filled cell increased
	score = score - self:checkAdditionalLines(height) * 10

	-- clear shape cells in board
	self:removeShape(shape)

	-- return shape to its original position
	while shape:move(0, -1) do
	end
	
	return score
	
end



------------------

-- check if more lines were added
-- i.e. if the number of not empty rows increased

------------------

function boardBst:checkAdditionalLines(height)

	local newLines = self:getHeight() - height
	--print('new lines: '..newLines)
	return newLines

end

------------------

-- calculate height occupied by cells
-- i.e. the number of rows with at least one filled cell
------------------

function boardBst:getHeight()
	
	local filledRows = 0
	local rowFilled = false
	local cellInst = nil
	
	for row = 2, self.h - 1 do
	
		rowFilled = false
	
		for column = 2, self.w - 1 do

			cellInst = self:getCell(column, row)
			
			--print(column..'; '..row)
			
			if cellInst.state == filled then
				rowFilled = true
				break;
			end
			
		end
		
		if rowFilled then
			filledRows = filledRows + 1
		end
		
	end
	
	--print('filled rows: '..filledRows)
	
	return filledRows
	
end

------------------

-- print evaluation board to terminal
-- for debug only

------------------

function boardBst:printBrd()

	for i = 1, self.w do
		for j = 1, self.h do
		
			local cell = self:getCell(i, j)
			
			if cell.state == filled then
				io.write('2')
			else
				io.write('1')
			end
			
		end
		
		print('<')
		
	end

	print('\n')
end

------------------

-- perform calculations on next shape

------------------

function boardBst:getNextShapeIndex()

	print('calculating next shape index')
	

	-- set some start values for min scores
	-- use two min scores to avoid repeating of the same shape
	local minScore = 1000000000
	local secondMinScore = minScore
	local score = 1
	
	-- indexes of shapes with min scores
	local index = 1
	local secondIndex = index
	
	-- nodes in tree have same index
	-- the result has to include all scores for the same index
	local shapeIndex = 1
	
	-- scan all nodes of decision tree and find the lowest score
	for key, value in pairs(self.decTree.nodes) do
	
		--print('index: '..value.index..'; rotation: '..value.rotation..'; pos: '..value.cells[1].x)
		
		-- while the same shape sum the scores in all nodes
		-- otherwise compare the totals score
		if value.index == shapeIndex then
		
			local sc = self:evaluate(value)
			--print('local score: '..sc)
			score = score + sc
		
		else
			print('prev total score: '..score..'; prev index: '..value.index - 1)

			if score < minScore then
		
				print('score chosen: '..score..'; index: '..value.index - 1)
				secondMinScore = minScore
				secondIndex = index
			
				minScore = score
				index = value.index - 1
			end
		
			score = self:evaluate(value)
			--print('local score: '..score)
			shapeIndex = value.index
		end
		
		-- print('score: >> '..score)
		
	end

	print('prev total score: '..score..'; index: '..shapeIndex)
	print('index: '..index..';prev index: '..self.prevIndex)
	
	-- check if prev shape was the same as this one
	-- if so return second lowest score
	if self.prevIndex == index then
		self.prevIndex = secondIndex
		print('result: '..secondIndex)
		return secondIndex
	end
	
	print('result: '..index)
	self.prevIndex = index
	return index

end

------------------

-- check if rows were filled by the node
-- so we move a rotated/offset shape down
-- and check if lines were filled
------------------

function boardBst:checkRows()
	
	--print('checking rows for a node')
	
	local rowReady = true
	
	-- number of filled rows
	local readyRows = 0
	
	for row = 2, self.h - 1 do
		
		rowReady = true
	
		for column = 2, self.w - 1 do
			cell = self:getCell(column, row)
		
			-- if any cell is empty in the row it's not filled
			if cell.state == empty then
				--print('cell state >> '..cell.state)
				rowReady = false
				break;
			end
		end
		
		if rowReady then
			--print('st >> '..cell.state..'; row ready')
			readyRows = readyRows + 1
		end
			
	end
	
	--if readyRows > 0 then
		--print('ready rows: '..readyRows)
	--end
	
	return readyRows
	
end

------------------

-- add shape to the board to check new configuration

------------------

function boardBst:addShape(shape)

	local cellInst = nil
	
	-- so we add a shape cells to beard cells and evaluate a board
	
	for key, value in pairs(shape.cells) do
		
		cellInst = self:getCell(value.x, value.y)
		--print(value.x, value.y)
		cellInst.state = filled
	end
	
end

------------------

-- remove shape to get default board configuration

------------------

function boardBst:removeShape(shape)

	local cell = nil
	
	-- remove added shape cells from board cells for next shapes
	
	for key, value in pairs(shape.cells) do
	
		cell = self:getCell(value.x, value.y)
		cell.state = empty
	end
	
end

------------------

-- get cell of the board

------------------

function boardBst:getCell(x, y)
	return self.cells[x..';'..y]
end

------------------


