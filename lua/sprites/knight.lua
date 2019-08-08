require("lua/sprites/sprite")
require("lua/sprites/hud")
require("lua/journalentry")
require("lua/sprites/tools/sword")
require("lua/sprites/tools/glove")
require("lua/sprites/tools/shield")

require("lua/sprites/effects/dust")
require("lua/sprites/effects/book")

Knight = {}
Knight.__index = Knight


setmetatable(Knight, {
  __index = Sprite,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Knight:_init()
	Sprite._init(self, 400, 14*32, 32, 32)

	self.hud = Hud(self)
	self.health = 100

	self.upPressed = false
	self.downPressed = false
	self.leftPressed = false
	self.rightPressed = false
	self.hasMoved = false
	self.facingDirection  = "down"
	self.displayDirection  = self.facingDirection
    self.freeze_direction = false
	
	self.PROJECTILES = {}
	
	self.tool = nil
	self.toolPressed = false
	self.subtool = nil
	self.subtoolPressed = false	
    self.tool_timer = 0
    self.tool_timer_max = 20
    self.tool_switch = 0
    
	self.shiftPressed = false	
	self.altPressed = false
	
	self.xSpeed = 0
	self.ySpeed = 0
	self.speed = 0
	self.move_angle = (3/2)*math.pi
	self.move_angle_delay = 0
	self.move_angle_delay_max = 15
	self.dest_angle = self.move_angle
	self.max_speed = 6
	self.speed_step = 0.5
	self.speed_step_high = 1.8
	self.spriteName = "audubon"
	self.spriteCounter = 1
	self.spriteTimer = 0
	
	self.isGrabbing = false
	self.grabbedEnemy = nil
    
    self.run_dust_counter = 0
    self.button_cooler = 0.15
    self.double_tap_state = 0
    self.double_tap_button = "down"
    
    self.invincibility_frames = 0
	self.slide_vel = 0
    
	self.STATE = "STAND"
	self.HOP_SPEED_MAX = 8
	self.HOP_SPEED = self.HOP_SPEED_MAX
	self.HOP_OFFSET = 0
	self.hop_dir = 1
	self.HOP_SLOW = 0
	self.KICK_BOOST = false
    
	self.HOPPING = false
	self.SKID_COUNT_MAX = 60
	self.SKID_COUNT = self.SKID_COUNT_MAX
	self.dodgeDirection = 0
	self.LUNGE_COUNTER = 20
	self.LUNGE_SPEED = self.LUNGE_COUNTER
	self.LUNGE_X = 0
	self.LUNGE_Y = 0
	self.LUNGE_DEST_X = 0
	self.LUNGE_DEST_Y = 0
	self.LUNGE_RADIUS = 140
	self.LUNGE_LOCK = false
	self.LUNGE_TIMER_ONE = 100
	self.LUNGE_TIMER_TWO = 100
	self.strafeDirection = "down"
	
	-- save data
	self.money = 0
	self.area = 0
	self.tools = self:initializeTools()
	self.journal = self:initializeJournal()
	self.flags = self:initializeFlags()
	
	self.garbage = false
	
	self.SQUISH_TIMER = math.pi*(3/8)
	
    -- test text
	--self.testText = "This is a test message to show how text can be produced one character at a time."
	--self.testTextCounter = 0
	--self.testTextTimer = 0
	
	self.xAxis = 0
	self.yAxis = 0
	
	self.grab_sound = love.audio.newSource("media/soundEffects/snd_se_item_screw_equip.wav", "static")
	self.wall_hit_sound = love.audio.newSource("media/soundEffects/snd_se_common_cliff_catch.wav", "static")
end

function Knight.draw(self)
	for i,v in pairs(self.PROJECTILES) do
		v:draw()
	end
	
	love.graphics.print(self.move_angle/math.pi, 300, 200)
	love.graphics.print(self.dest_angle/math.pi, 300, 230)
	love.graphics.print(self.move_angle_delay, 300, 150)
	
	
	love.graphics.print(self.xAxis, 100, 30)
	love.graphics.print(self.yAxis, 100, 50)
    
    if self.LUNGE_LOCK then
    	love.graphics.print("TRUE", 10, 30)
    else
    	love.graphics.print("FALSE", 10, 30)
    end
    love.graphics.print(self.STATE, 10, 50)
    love.graphics.print(self.strafeDirection, 10, 70)
    
    --lunge timers lol
	love.graphics.setColor(50, 200, 100, 255)
	love.graphics.rectangle("fill", self.x-42, self.y-83, 32, 8)
	love.graphics.setColor(160, 255, 130, 255)
	love.graphics.rectangle("fill", self.x-42, self.y-83, 32*(self.LUNGE_TIMER_ONE/100), 8)
	
	love.graphics.setColor(160, 20, 90, 255)
	love.graphics.rectangle("fill", self.x-42, self.y-74, 32, 8)
	love.graphics.setColor(230, 50, 60, 255)
	love.graphics.rectangle("fill", self.x-42, self.y-74, 32*(self.LUNGE_TIMER_TWO/100), 8)
	
    
	if options.debug then
		love.graphics.setColor(255, 0, 0, 128)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
	
	love.graphics.setColor(0, 100, 100, 128)		-- makeshift shadow
	love.graphics.ellipse("fill", self.x-16, self.y - 1, 16, 4)
	
	local moveAngle = math.atan2(self.ySpeed, self.xSpeed)
	if self.xSpeed == 0 and self.ySpeed == 0 then
		if self.displayDirection == "down" then
			moveAngle = (1/2)*math.pi
		elseif self.displayDirection == "left" then
			moveAngle = math.pi
		elseif self.displayDirection == "up" then
			moveAngle = (3/2)*math.pi
		end
	end
	
	love.graphics.setColor(0, 0, 0, 255)
	if self.invincibility_frames < 100 and self.invincibility_frames > 70 then
		love.graphics.ellipse("fill", self.x-16, self.y, 6, 6)	
	end
	
	if self.STATE == "LUNGE" then
		love.graphics.ellipse("fill", self.LUNGE_DEST_X, self.LUNGE_DEST_Y, 2, 2)
	else
		love.graphics.ellipse("fill", self.x + self.LUNGE_RADIUS * math.cos(-self.move_angle), self.y + self.LUNGE_RADIUS * math.sin(-self.move_angle), 2, 2)
	end
	
	-- ------------------- --
	
	--[[
	if self.invincibility_frames > 0 then			
		love.graphics.setColor(255, 255, 255, 127)	-- draw char at half opacity if recently hit
	else
		love.graphics.setColor(255, 255, 255, 255)
	end
	--]]
	local sprites = images:getImage(self.spriteName)
    
    -- rectangle because animating is hard
    if self.STATE == "WALL_CLING" or self.STATE == "WALL_SLIDE" then
		love.graphics.setColor(100, 20, 70)
	elseif self.STATE == "CORNER_CLING_TWO" and self.spriteCounter % 4 == 0 then
		love.graphics.setColor(100, 180, 130)
	else
		if self.invincibility_frames > 0 then			
			love.graphics.setColor(200, 80, 30, 127)	-- draw char at half opacity if recently hit
		else
			love.graphics.setColor(200, 80, 30, 255)
		end
	end
	
	love.graphics.rectangle("fill", self.x-32, self.y-64-self.HOP_OFFSET, 32, 64)
	
	love.graphics.setColor(0, 0, 0)
	local stupid_circle_x = self.x-16
	local stupid_circle_y = self.y
	if self.displayDirection == "down" then
		stupid_circle_y = stupid_circle_y + 40
	end
	if self.displayDirection == "up" then
		stupid_circle_y = stupid_circle_y - 40
	end
	if self.displayDirection == "right" then
		stupid_circle_x = stupid_circle_x + 40
	end
	if self.displayDirection == "left" then
		stupid_circle_x = stupid_circle_x - 40
	end
	love.graphics.ellipse("fill", stupid_circle_x, stupid_circle_y, 3)
    
    
	if not (self.tool == nil) then
		self.tool:draw()
	end
	
	
	
	if self.altPressed then
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.ellipse("fill", (self.x-16)-48, (self.y), 4, 4)
		love.graphics.ellipse("fill", (self.x-16)+48, (self.y), 4, 4)
		love.graphics.ellipse("fill", (self.x-16), (self.y)-48, 4, 4)
		love.graphics.ellipse("fill", (self.x-16), (self.y)+48, 4, 4)
	end
	
    love.graphics.push("all")
	love.graphics.translate(math.floor(camera.x-400), math.floor(camera.y-300))
	self.hud:draw(self)
    love.graphics.pop("all")
end

function Knight.keypressed(self, key)
	if key == keyBindings:getUp() then
		self.upPressed = true
		self.facingDirection = "up"
		self.move_angle_delay = 0
	end
	if key == keyBindings:getLeft() then
		self.leftPressed = true
		self.facingDirection = "left"
		self.move_angle_delay = 0
	end
	if key == keyBindings:getDown() then
		self.downPressed = true
		self.facingDirection = "down"
		self.move_angle_delay = 0
	end
	if key == keyBindings:getRight() then
		self.rightPressed = true
		self.facingDirection = "right"
		self.move_angle_delay = 0
	end
	if key == keyBindings:getTool() then
		self.toolPressed = true
	end
	if key == keyBindings:getSubtool() then
		self.subtoolPressed = true
	end
	if key == keyBindings:getShift() then
		self.shiftPressed = true
	end 
	if key == keyBindings:getSpace() then
		self.altPressed = true
	end 
end

function Knight.keyreleased(self, key)
	if self.hasMoved then
		self.hasMoved = false
	end
	
	if key == keyBindings:getUp() then
		self.upPressed = false
	end
	if key == keyBindings:getLeft() then
		self.leftPressed = false
	end
	if key == keyBindings:getDown() then
		self.downPressed = false
	end
	if key == keyBindings:getRight() then
		self.rightPressed = false
	end
	if key == keyBindings:getTool() then
		self.toolPressed = false
	end
	if key == keyBindings:getSubtool() then
		self.subtoolPressed = false
	end
	if key == keyBindings:getShift() then
		self.shiftPressed = false
	end
	if key == keyBindings:getSpace() then
		self.altPressed = false
	end
end

function Knight.resetKeys(self)
	self.upPressed = false
	self.downPressed = false
	self.leftPressed = false
	self.rightPressed = false
end

function Knight.update(self, dt)
	self.xAxis = leftxDir
	self.yAxis = leftyDir
	
	if math.abs(self.xAxis) < 0.5 then
		self.xAxis = 0
	end
	if math.abs(self.yAxis) < 0.5 then
		self.yAxis = 0
	end
	
	if self.STATE == "CW_SPIN" then
		
		-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		if self.subtoolPressed then
			if not self.LUNGE_LOCK then
				local moveAngle = 0
				
				if self.displayDirection == "up" then
					if self.leftPressed then
						moveAngle = (3/4)*math.pi
					elseif self.rightPressed then
						moveAngle = (1/4)*math.pi
					else
						moveAngle = (1/2)*math.pi
					end
				elseif self.displayDirection == "right" then
					if self.upPressed then
						moveAngle = (1/4)*math.pi
					elseif self.downPressed then
						moveAngle = (7/4)*math.pi
					else
						moveAngle = 0
					end
				elseif self.displayDirection == "down" then
					if self.leftPressed then
						moveAngle = (5/4)*math.pi
					elseif self.rightPressed then
						moveAngle = (7/4)*math.pi
					else
						moveAngle = (3/2)*math.pi
					end
				else
					if self.upPressed then
						moveAngle = (3/4)*math.pi
					elseif self.downPressed then
						moveAngle = (5/4)*math.pi
					else
						moveAngle = math.pi
					end
				end
				
				
				self.LUNGE_DEST_X = self.x + self.LUNGE_RADIUS * math.cos(-moveAngle)
				self.LUNGE_DEST_Y = self.y + self.LUNGE_RADIUS * math.sin(-moveAngle)
					
				self.STATE = "LUNGE"
				self.LUNGE_TIMER_ONE = 0
				self.LUNGE_LOCK = true
				self.LUNGE_SPEED = self.LUNGE_COUNTER
				self.LUNGE_X = self.x
				self.LUNGE_Y = self.y
				return
			end
		else
			self.LUNGE_LOCK = false
		end
		-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		
		
		
		
		local angle = math.atan(self.spin_speed/self.spin_radius)
		
		if self.spin_dir == "cw" then
		self.spin_angle = self.spin_angle + angle
		elseif self.spin_dir == "ccw" then
		self.spin_angle = self.spin_angle - angle
		end
		
		if self.spin_angle > 2*math.pi then
			self.spin_angle = self.spin_angle - 2*math.pi
		end
		
		self.xSpeed = self.spin_speed*math.cos(self.spin_angle + math.pi/2)
		self.ySpeed = self.spin_speed*math.sin(self.spin_angle + math.pi/2)
		self:move("right", self.xSpeed)
		self:move("down", self.ySpeed)
		
		if self.spin_speed > 0 then
			self.spin_speed = self.spin_speed - self.speed_step
		elseif self.spin_speed <= 0 then
			self.spin_speed = 0
		end
		
		if not self.altPressed then
			self.STATE = "STAND"
			self.xSpeed = 10*math.cos(self.spin_angle + math.pi/2)
			self.ySpeed = 10*math.sin(self.spin_angle + math.pi/2)
		end
		
		
		return
	end
	
	-- YOU'RE JUST ALWAYS ATTRACTED TO WALLS
	--[[
	local garbage = 0.75
	if not map:canMove(self, "left", 96) then
		self:move("left", 5)
	end
	if not map:canMove(self, "right", 96) then
		self:move("right", 5)
	end
	if not map:canMove(self, "up", 96) then
		self:move("up", 5)
	end
	if not map:canMove(self, "down", 96) then
		self:move("down", 5)
	end
	--]]
	-- -------------------------------------
	
	
	
	if self.altPressed and not self.subtoolPressed and self.STATE == "STAND" then
		
		--[[
		local please_god = false
		self.spin_radius = 64
		
		local DUMB_x = self.x
		local DUMB_y = self.y
		
		if self.displayDirection == "down" then
			if not map:canMove(self, "left", self.spin_radius) then
				self.spin_dir = "cw"
				please_god = true
			elseif not map:canMove(self, "right", self.spin_radius) then
				self.spin_dir = "ccw"
				please_god = true
			end
		elseif self.displayDirection == "left" then
			if not map:canMove(self, "up", self.spin_radius) then
				self.spin_dir = "cw"
				please_god = true
			elseif not map:canMove(self, "down", self.spin_radius) then
				self.spin_dir = "ccw"
				please_god = true
			end
		elseif self.displayDirection == "up" then
			if not map:canMove(self, "left", self.spin_radius) then
				self.spin_dir = "ccw"
				please_god = true
			elseif not map:canMove(self, "right", self.spin_radius) then
				self.spin_dir = "cw"
				please_god = true
			end
		elseif self.displayDirection == "right" then
			if not map:canMove(self, "up", self.spin_radius) then
				self.spin_dir = "ccw"
				please_god = true
			elseif not map:canMove(self, "down", self.spin_radius) then
				self.spin_dir = "cw"
				please_god = true
			end
		end
		
		self.x = DUMB_x
		self.y = DUMB_y
		
		if please_god then
			self.STATE = "CW_SPIN"
			
			self.grab_sound:play()
			
			self.spin_speed = 12 --self.max_speed
			self.spin_angle = 0
			
			self.spin_point_x = self.x
			self.spin_point_y = self.y
			
			if self.displayDirection == "down" then
				self.spin_point_x = self.x - self.spin_radius
				self.spin_point_y = self.y
				self.spin_angle = 0
			elseif self.displayDirection == "left" then
				self.spin_point_x = self.x
				self.spin_point_y = self.y - self.spin_radius
				self.spin_angle = (1/2)*math.pi
			elseif self.displayDirection == "up" then
				self.spin_point_x = self.x + self.spin_radius
				self.spin_point_y = self.y
				self.spin_angle = math.pi
			elseif self.displayDirection == "right" then
				self.spin_point_x = self.x
				self.spin_point_y = self.y + self.spin_radius
				self.spin_angle = (3/2)*math.pi
			end
		end
		
		if not map:canMove(self, "left", 48) then
			self.xSpeed = -10
		end
		if not map:canMove(self, "right", 48) then
			self.xSpeed = 10
		end
		if not map:canMove(self, "up", 48) then
			self.ySpeed = -10
		end
		if not map:canMove(self, "down", 48) then
			self.ySpeed = 10
		end
		--]]
	end
	
	if self.altPressed and self.STATE == "LUNGE" then
		if not map:canMove(self, "left", 48) then
			self.LUNGE_DEST_X = self.LUNGE_DEST_X - 5
		elseif not map:canMove(self, "right", 48) then
			self.LUNGE_DEST_X = self.LUNGE_DEST_X + 5
		elseif not map:canMove(self, "up", 48) then
			self.LUNGE_DEST_Y = self.LUNGE_DEST_Y - 5
		elseif not map:canMove(self, "down", 48) then
			self.LUNGE_DEST_Y = self.LUNGE_DEST_Y + 5
		end
	end
	
	
	
	--self.LUNGE_TIMER_ONE = 100
	--self.LUNGE_TIMER_TWO = 100
	
	if self.invincibility_frames > 0 then
		self.invincibility_frames = self.invincibility_frames - 1
    end
	
	self.hud:update(dt, self)
	
	for i,v in pairs(self.PROJECTILES) do
		v:update()
	end
	
	if self.STATE == "KNOCKBACK" then
		if self.invincibility_frames <= 80 then
			self.STATE = "STAND"
			return
		end
		self:move("right", self.xSpeed)
		self:move("down", self.ySpeed)
		self:decrementSpeeds()
		return
	end
	
	--if not (self.tool == nil) then
	--	self.tool:update(dt)
	--end

	if not (self.subtool == nil) then
		self.subtool:update(dt)
	end
	
	--if self.tool_timer > 30 then 
	--	self.tool:use(self)
	--end
	if self.tool_timer > 0 then 
		self.tool_timer = self.tool_timer - 1
	end
	
	if self.toolPressed then
		if self.tool_timer == 0 and self.tool_switch == 0 then
			if table.getn(self.PROJECTILES) < 3 then
				table.insert(self.PROJECTILES, Sword())
			end
			self.tool_timer = 5
		end
	end
	
	if self.STATE == "CORNER_CLING_TWO" then
		if self.subtoolPressed then
			if not self.LUNGE_LOCK then
				local moveAngle = 0
				
				if self.displayDirection == "up" then
					if self.leftPressed then
						moveAngle = (3/4)*math.pi
					elseif self.rightPressed then
						moveAngle = (1/4)*math.pi
					else
						moveAngle = (1/2)*math.pi
					end
				elseif self.displayDirection == "right" then
					if self.upPressed then
						moveAngle = (1/4)*math.pi
					elseif self.downPressed then
						moveAngle = (7/4)*math.pi
					else
						moveAngle = 0
					end
				elseif self.displayDirection == "down" then
					if self.leftPressed then
						moveAngle = (5/4)*math.pi
					elseif self.rightPressed then
						moveAngle = (7/4)*math.pi
					else
						moveAngle = (3/2)*math.pi
					end
				else
					if self.upPressed then
						moveAngle = (3/4)*math.pi
					elseif self.downPressed then
						moveAngle = (5/4)*math.pi
					else
						moveAngle = math.pi
					end
				end
				
				
				self.LUNGE_DEST_X = self.x + self.LUNGE_RADIUS * math.cos(-moveAngle)
				self.LUNGE_DEST_Y = self.y + self.LUNGE_RADIUS * math.sin(-moveAngle)
					
				self.STATE = "LUNGE"
				self.LUNGE_TIMER_ONE = 0
				self.LUNGE_LOCK = true
				self.LUNGE_SPEED = self.LUNGE_COUNTER
				self.LUNGE_X = self.x
				self.LUNGE_Y = self.y
				return
			end
		else
			self.LUNGE_LOCK = false
		end
		
		self.LUNGE_TIMER_ONE = 100
		self.LUNGE_TIMER_TWO = 100
		
		if self.xSpeed == 0 and self.ySpeed == 0 then
			self.STATE = "STAND"
			return
		end
		
		local turn_corner = false 
		
		if self.displayDirection == "left" then
			if self.rightPressed then
				turn_corner = true
			end
		elseif self.displayDirection == "right" then
			if self.leftPressed then
				turn_corner = true
			end
		elseif self.displayDirection == "down" then
			if self.upPressed then
				turn_corner = true
			end
		elseif self.displayDirection == "up" then
			if self.downPressed then
				turn_corner = true
			end
		end
		
		if not turn_corner then
			if self.spriteCounter > 0 then
				self.spriteCounter = self.spriteCounter - 1
				return
			end
			if self.spriteCounter <= 0 then
				self.STATE = "STAND"
				return
			end
		end
		
		if self.displayDirection == "left" then
			if self.ySpeed > 0 then
				self.displayDirection = "down"
			else
				self.displayDirection = "up"
			end
			
			self.xSpeed = math.abs(self.ySpeed)
			self.ySpeed = 0
		elseif self.displayDirection == "right" then
			if self.ySpeed > 0 then
				self.displayDirection = "down"
			else
				self.displayDirection = "up"
			end
			
			self.xSpeed = -1 * math.abs(self.ySpeed)
			self.ySpeed = 0
		elseif self.displayDirection == "down" then
			if self.xSpeed > 0 then
				self.displayDirection = "right"
			else
				self.displayDirection = "left"
			end
			
			self.ySpeed = -1 * math.abs(self.xSpeed)
			self.xSpeed = 0
		elseif self.displayDirection == "up" then
			if self.xSpeed > 0 then
				self.displayDirection = "right"
			else
				self.displayDirection = "left"
			end
			
			self.ySpeed = math.abs(self.xSpeed)
			self.xSpeed = 0
		end
		
		self.strafeDirection = oppositeDirection(self.displayDirection)
		
		self.spriteTimer = 50
		self.STATE = "WALL_SLIDE"
		self.wall_hit_sound:play()
		return
	end
	
	if self.STATE == "CLING_CORNER" then
		if self.spriteCounter > 0 then
			self.spriteCounter = self.spriteCounter - 1
			self:move(self.strafeDirection, 3)
		else
			self.STATE = "FIND_WALL"
		end
		return
	end
	
	if self.STATE == "FIND_WALL" then
		
		if not map:canMove(self, "up", 16) then
			if not map:canMove(self, "left", 16) then
				if self.leftPressed then
					self.displayDirection = "right"
					self.STATE = "WALL_CLING"
					return
				else
					self.displayDirection = "down"
					self.STATE = "WALL_CLING"
					return
				end
			elseif not map:canMove(self, "right", 16) then
				if self.rightPressed then
					self.displayDirection = "left"
					self.STATE = "WALL_CLING"
					return
				else
					self.displayDirection = "down"
					self.STATE = "WALL_CLING"
					return
				end
			else
				self.displayDirection = "down"
				self.STATE = "WALL_CLING"
				return
			end
		end
		if not map:canMove(self, "down", 16) then
			if not map:canMove(self, "left", 16) then
				if self.leftPressed then
					self.displayDirection = "right"
					self.STATE = "WALL_CLING"
					return
				else
					self.displayDirection = "up"
					self.STATE = "WALL_CLING"
					return
				end
			elseif not map:canMove(self, "right", 16) then
				if self.rightPressed then
					self.displayDirection = "left"
					self.STATE = "WALL_CLING"
					return
				else
					self.displayDirection = "up"
					self.STATE = "WALL_CLING"
					return
				end
			else
				self.displayDirection = "up"
				self.STATE = "WALL_CLING"
				return
			end
		end
		if not map:canMove(self, "right", 16) then
			self.displayDirection = "left"
			self.STATE = "WALL_CLING"
			return
		end
		if not map:canMove(self, "left", 16) then
			self.displayDirection = "right"
			self.STATE = "WALL_CLING"
			return
		end
	end
	
	if self.STATE == "WALL_SLIDE" then
		
		if self.subtoolPressed then
			if not self.LUNGE_LOCK then
				local moveAngle = 0
				
				if self.displayDirection == "up" then
					if self.leftPressed then
						moveAngle = (3/4)*math.pi
					elseif self.rightPressed then
						moveAngle = (1/4)*math.pi
					else
						moveAngle = (1/2)*math.pi
					end
				elseif self.displayDirection == "right" then
					if self.upPressed then
						moveAngle = (1/4)*math.pi
					elseif self.downPressed then
						moveAngle = (7/4)*math.pi
					else
						moveAngle = 0
					end
				elseif self.displayDirection == "down" then
					if self.leftPressed then
						moveAngle = (5/4)*math.pi
					elseif self.rightPressed then
						moveAngle = (7/4)*math.pi
					else
						moveAngle = (3/2)*math.pi
					end
				else
					if self.upPressed then
						moveAngle = (3/4)*math.pi
					elseif self.downPressed then
						moveAngle = (5/4)*math.pi
					else
						moveAngle = math.pi
					end
				end
				
				
				self.LUNGE_DEST_X = self.x + self.LUNGE_RADIUS * math.cos(-moveAngle)
				self.LUNGE_DEST_Y = self.y + self.LUNGE_RADIUS * math.sin(-moveAngle)
					
				self.STATE = "LUNGE"
				self.LUNGE_TIMER_ONE = 0
				self.LUNGE_LOCK = true
				self.LUNGE_SPEED = self.LUNGE_COUNTER
				self.LUNGE_X = self.x
				self.LUNGE_Y = self.y
				return
			end
		else
			self.LUNGE_LOCK = false
		end
		
		-- ----
		if self.spriteTimer > 0 then
			self.spriteTimer = self.spriteTimer - 1
			if self.spriteTimer > 50 then
				return
			end
			if self.xSpeed == 0 and self.ySpeed == 0 then
				if self.altPressed then
					self.STATE = "WALL_CLING"
				else
					self.STATE = "STAND"
				end
			end
		else
		
			self.STATE = "STAND"
		end
		
		if self.xSpeed < 0 then
			if self.xSpeed + self.speed_step > 0 then
				self.xSpeed = 0
			else
				self.xSpeed = self.xSpeed + self.speed_step 
			end
		else
			if self.xSpeed - self.speed_step < 0 then
				self.xSpeed = 0
			else
				self.xSpeed = self.xSpeed - self.speed_step 
			end
		end
		
		if self.ySpeed < 0 then
			if self.ySpeed + self.speed_step > 0 then
				self.ySpeed = 0
			else
				self.ySpeed = self.ySpeed + self.speed_step 
			end
		else
			if self.ySpeed - self.speed_step < 0 then
				self.ySpeed = 0
			else
				self.ySpeed = self.ySpeed - self.speed_step 
			end
		end
		
		local quarter_xSpeed = self.xSpeed/4
		local quarter_ySpeed = self.ySpeed/4
		
		for i=1, 4 do
			local temp = true
			self:move("right", quarter_xSpeed)
			self:move("down", quarter_ySpeed)
			if map:canMove(self, self.strafeDirection, 16) then
				--[[
				local temp = self.xSpeed
				self.xSpeed = self.ySpeed
				self.ySpeed = temp
				--]]
				
				self.spriteTimer = 50
				
				self.spriteCounter = 15
				self.STATE = "CORNER_CLING_TWO"
				return
			end
		end
		
		
		--[[
		if map:canMove(self, self.strafeDirection, 16) then
			self.spriteCounter = 5
			--self.STATE = "CLING_CORNER"
			self.STATE = "CLING_CORNER_TWO"
			return
		end
		--]]
		
		
		return
	end
	
	if self.STATE == "WALL_CLING" then
		self.LUNGE_TIMER_ONE = 100
		self.LUNGE_TIMER_TWO = 100
		if not self.altPressed then
			self.xSpeed = 0
			self.ySpeed = 0
			self.STATE = "STAND"
			return
		end
		if self.subtoolPressed then
			if not self.LUNGE_LOCK then
				local moveAngle = 0
				
				if self.displayDirection == "up" then
					if self.leftPressed then
						moveAngle = (3/4)*math.pi
					elseif self.rightPressed then
						moveAngle = (1/4)*math.pi
					else
						moveAngle = (1/2)*math.pi
					end
				elseif self.displayDirection == "right" then
					if self.upPressed then
						moveAngle = (1/4)*math.pi
					elseif self.downPressed then
						moveAngle = (7/4)*math.pi
					else
						moveAngle = 0
					end
				elseif self.displayDirection == "down" then
					if self.leftPressed then
						moveAngle = (5/4)*math.pi
					elseif self.rightPressed then
						moveAngle = (7/4)*math.pi
					else
						moveAngle = (3/2)*math.pi
					end
				else
					if self.upPressed then
						moveAngle = (3/4)*math.pi
					elseif self.downPressed then
						moveAngle = (5/4)*math.pi
					else
						moveAngle = math.pi
					end
				end
				
				
				self.LUNGE_DEST_X = self.x + self.LUNGE_RADIUS * math.cos(-moveAngle)
				self.LUNGE_DEST_Y = self.y + self.LUNGE_RADIUS * math.sin(-moveAngle)
					
				self.STATE = "LUNGE"
				self.LUNGE_TIMER_ONE = 0
				self.LUNGE_LOCK = true
				self.LUNGE_SPEED = self.LUNGE_COUNTER
				self.LUNGE_X = self.x
				self.LUNGE_Y = self.y
				return
			end
		else
			self.LUNGE_LOCK = false
		end
		
		
		local stupid = 3
		self.strafeDirection = oppositeDirection(self.displayDirection)
		if self.displayDirection == "up" then
			if self.rightPressed then
		    	self:move("right", stupid)
		    	if map:canMove(self, "down", 16)then
					self.spriteCounter = 5
					self.displayDirection = "left"
			       	self.STATE = "CLING_CORNER"
			    end
		    elseif self.leftPressed then
		    	self:move("left", stupid)
		    	if map:canMove(self, "down", 16)then
					self.spriteCounter = 5
					self.displayDirection = "right"
			       	self.STATE = "CLING_CORNER"
			    end
		    end
		elseif self.displayDirection == "down" then
			if self.rightPressed then
		    	self:move("right", stupid)
		    	if map:canMove(self, "up", 16)then
					self.spriteCounter = 5
					self.displayDirection = "left"
			       	self.STATE = "CLING_CORNER"
			    end
		    elseif self.leftPressed then
		    	self:move("left", stupid)
		    	if map:canMove(self, "up", 16)then
					self.spriteCounter = 5
					self.displayDirection = "right"
			       	self.STATE = "CLING_CORNER"
			    end
		    end
		elseif self.displayDirection == "right" then
			if self.upPressed then
		    	self:move("up", stupid)
		    	if map:canMove(self, "left", 16)then
					self.spriteCounter = 5
					self.displayDirection = "down"
			       	self.STATE = "CLING_CORNER"
			    end
		    elseif self.downPressed then
		    	self:move("down", stupid)
		    	if map:canMove(self, "left", 16)then
					self.spriteCounter = 5
					self.displayDirection = "up"
			       	self.STATE = "CLING_CORNER"
			    end
		    end
		elseif self.displayDirection == "left" then
			if self.upPressed then
		    	self:move("up", stupid)
		    	if map:canMove(self, "right", 16)then
					self.spriteCounter = 5
					self.displayDirection = "down"
			       	self.STATE = "CLING_CORNER"
			    end
		    elseif self.downPressed then
		    	self:move("down", stupid)
		    	if map:canMove(self, "right", 16)then
					self.spriteCounter = 5
					self.displayDirection = "up"
			       	self.STATE = "CLING_CORNER"
			    end
		    end
		end
		return
	end
	
	--[[
	if self.LUNGE_TIMER_TWO < 100 then
		self.LUNGE_TIMER_TWO = self.LUNGE_TIMER_TWO + 0.5
	elseif self.LUNGE_TIMER_TWO > 100 then
		self.LUNGE_TIMER_TWO = 100
	end
	
	if self.LUNGE_TIMER_ONE < 100 and self.LUNGE_TIMER_TWO == 100 then
		self.LUNGE_TIMER_ONE = self.LUNGE_TIMER_ONE + 0.5
	elseif self.LUNGE_TIMER_ONE > 100 then
		self.LUNGE_TIMER_ONE = 100
	end
	--]]
	
	if self.STATE == "LUNGE" then
		
		local evenStupider = 7
		
		local stupid = 8
		if (self.upPressed or self.downPressed) and (self.leftPressed or self.rightPressed) then
			stupid = stupid / 1.4 
		end
		if self.upPressed then
			if map:canMove(self, "up", 16) then
				self.LUNGE_DEST_Y = self.LUNGE_DEST_Y - stupid
			else
				evenStupider = 0
			end
		end
		if self.leftPressed then
			if map:canMove(self, "left", 16) then
				self.LUNGE_DEST_X = self.LUNGE_DEST_X - stupid
			else
				evenStupider = 0
			end
		end
		if self.rightPressed then
			if map:canMove(self, "right", 16) then
				self.LUNGE_DEST_X = self.LUNGE_DEST_X + stupid
			else
				evenStupider = 0
			end
		end
		if self.downPressed then
			if map:canMove(self, "down", 16) then
				self.LUNGE_DEST_Y = self.LUNGE_DEST_Y + stupid
			else
				evenStupider = 0
			end
		end
		
		if self.subtoolPressed then
			local moveAngle = math.atan2(self.LUNGE_DEST_Y - self.y, self.LUNGE_DEST_X - self.x)
			self.LUNGE_DEST_X = self.LUNGE_DEST_X + evenStupider*math.cos(moveAngle)
			self.LUNGE_DEST_Y = self.LUNGE_DEST_Y + evenStupider*math.sin(moveAngle)
		end
		
		table.insert(map.effects, Dust(self.x-24, self.y))
		
		--[[
		if self.toolPressed and self.LUNGE_SPEED <= 0 then
			-- attack
			self.facingDirection = self.displayDirection
			self.freeze_direction = false
			--self.tool_timer = self.tool_timer_max*2
			self.tool_timer = 10
			self.STATE = "SWORD_SLASH"
			return
		end
		--]]
		
        --self.tool:use(self)
        
        local move_percent = 0.15
		local x_speed = move_percent*(self.LUNGE_DEST_X - self.x)
		local y_speed = move_percent*(self.LUNGE_DEST_Y - self.y)
        
		if self.LUNGE_SPEED > 0 then
			self.LUNGE_SPEED = self.LUNGE_SPEED - 1
            
			self:move("right", x_speed)
			self:move("down", y_speed)
		else
			local moveAngle = math.atan2(self.LUNGE_DEST_Y - self.y, self.LUNGE_DEST_X - self.x)
			if self.upPressed or self.rightPressed or self.downPressed or self.leftPressed then
				self.xSpeed = self.max_speed * math.cos(moveAngle)
				self.ySpeed = self.max_speed * math.sin(moveAngle)
			else
				self.xSpeed = 0
				self.ySpeed = 0
			end
			self.STATE = "STAND"
		end
		
		return
	end

    if self.STATE == "TOOL_USE" then
		local xspeed = self.xSpeed
		local yspeed = self.ySpeed
		
		if self.running then
	        xspeed = xspeed*2;
	        yspeed = yspeed*2;
	    end
	    
		local moveAngle = math.atan2(yspeed, xspeed)
		self:move("right", xspeed*math.abs(math.cos(moveAngle)))
		self:move("down", yspeed*math.abs(math.sin(moveAngle)))
    	
        self.freeze_direction = false
        
        if self.tool_timer > 0 then
            self.tool:use(self)
            self.tool_timer = self.tool_timer - 1
        else
            self.STATE = "STAND"
            self.tool_switch = 1
            self.tool_timer = 0
        end
        return
    end
    
    if self.STATE == "SWORD_SLASH" then
        self.tool_switch = 0
        if self.tool_timer > 0 then
            self.tool:use(self)
            self.tool_timer = self.tool_timer - 1
            if self.tool_timer == 28 then
                self:move(self.facingDirection, 4)
            end
            if self.tool_timer == 26 then
                self:move(self.facingDirection, 2)
            end
            if self.tool_timer == 24 then
                self:move(self.facingDirection, 2)
            end
        else
            self.STATE = "STAND"
            self.tool_timer = 0
        end
        return
    end
    
	if self.toolPressed then
		-- TALKING --
        if table.getn(map.npcs) > 0 then
			local speechSprite
			if self.facingDirection == "up" then
				speechSprite = Sprite(self.x, self.y-32, 32, 32)
			elseif self.facingDirection == "down" then
				speechSprite = Sprite(self.x, self.y+32, 32, 32)
			elseif self.facingDirection == "left" then
				speechSprite = Sprite(self.x-32, self.y, 32, 32)
			elseif self.facingDirection == "right" then
				speechSprite = Sprite(self.x+32, self.y, 32, 32)
			end
			for i,npc in pairs(map.npcs) do
				if speechSprite:collidesWith(npc) then
					npc:interact()
					self.toolPressed = false
					self.hasMoved = true
					return
				end
			end
			for i,shopkeeper in pairs(map.shopkeepers) do
				if speechSprite:collidesWith(shopkeeper) then
					shopkeeper:interact()
					self.toolPressed = false
					self.hasMoved = true
					return
				end
			end
		end
		-- ------- --
		
		-- USING TOOL --
		self.tool_switch = 1
        --[[
        if not (self.tool == nil) then
            if self.tool_switch == 0 then
            	if not self.shiftPressed then
            		self.displayDirection = self.facingDirection
            	end
                self.tool_timer = self.tool_timer_max
                self.tool:use(self)
                self.STATE = "TOOL_USE"
                self.tool_switch = 1
                if self.hasMoved then
                	self.slide_vel = self.xSpeed + 2
                else
                	self.slide_vel = 0
                end
            end
            
            if (not self.freeze_direction) and self.tool_switch == 1 then
                --self.freeze_direction = true
            end
		end
		
        if self.freeze_direction then
            self.tool:use(self)
        end
        --]]
		-- ----- ---- --
		
    else			-- self.toolPressed = false
		if self.freeze_direction then
			self.facingDirection = self.displayDirection
			self.freeze_direction = false
			
			--self.tool_timer = self.tool_timer_max*2
			self.tool_timer = 30
			self.STATE = "SWORD_SLASH"
			
			return
		end
		self.tool_switch = 0
	end
    
	if self.subtoolPressed then 
        if self.STATE == "STAND" and (self.LUNGE_TIMER_ONE == 100 or self.LUNGE_TIMER_TWO == 100) and not self.LUNGE_LOCK then
        	if self.LUNGE_TIMER_ONE < 100 and self.LUNGE_TIMER_TWO == 100 then
        		self.LUNGE_TIMER_ONE = 0
        		self.LUNGE_TIMER_TWO = 0
        	else
        		self.LUNGE_TIMER_ONE = 0
        		self.LUNGE_TIMER_TWO = 100
        	end
        	
			self.STATE = "LUNGE"
			self.LUNGE_LOCK = true
			self.LUNGE_SPEED = self.LUNGE_COUNTER
			self.LUNGE_X = self.x
			self.LUNGE_Y = self.y
			
			local moveAngle = math.atan2(self.ySpeed, self.xSpeed)
			if (self.xSpeed == 0 and self.ySpeed == 0) or self.shiftPressed then
				if self.facingDirection == "down" then
					moveAngle = (1/2)*math.pi
				elseif self.facingDirection == "left" then
					moveAngle = math.pi
				elseif self.facingDirection == "up" then
					moveAngle = (3/2)*math.pi
				else
					moveAngle = 0
				end
			end
			
			--self.LUNGE_DEST_X = self.x + self.LUNGE_RADIUS * math.cos(moveAngle)
			--self.LUNGE_DEST_Y = self.y + self.LUNGE_RADIUS * math.sin(moveAngle)
			self.LUNGE_DEST_X = self.x + self.LUNGE_RADIUS * math.cos(self.move_angle)
			self.LUNGE_DEST_Y = self.y + self.LUNGE_RADIUS * math.sin(-self.move_angle)
				
           	table.insert(map.effects, Dust(self.x-24, self.y+8))
			return
        end
        
        if not (self.subtool == nil) then
			self.subtool:use(self)
			self.subtoolPressed = false
		end
    else
    	if self.STATE == "STAND" then 
    		self.LUNGE_LOCK = false
    	end
    end

	if self.isGrabbing and self.grabbedEnemy.size == "large" then
		self.x = self.grabbedEnemy.x + math.abs(self.width - self.grabbedEnemy.width)/2
		self.y = self.grabbedEnemy.y + math.abs(self.height - self.grabbedEnemy.height)/2

		self.xPos = math.floor(self.x / 32)
		self.yPos = math.floor(self.y / 32)
		return
	elseif self.isGrabbing and self.grabbedEnemy.size == "small" then
		--do nothing?
	end
	
	local xspeed = self.xSpeed
	local yspeed = self.ySpeed
    
    --                         ***RUNNING***                          --
    --------------------------------------------------------------------
    if self.button_cooler > 0 then
        self.button_cooler = self.button_cooler - (1*dt)
    else
        if not self.double_tap_state == 3 then
            self.double_tap_state = 0
        end
    end
    
    if not self.running then
        if self.upPressed or self.leftPressed or self.rightPressed or self.downPressed then
            if self.button_cooler <= 0 and self.double_tap_state == 1 then
            	-- double tap failure
                self.double_tap_state = 3
                self.button_cooler = 0
            end
            if self.button_cooler <= 0 and self.double_tap_state == 0 then
            	-- double tap start
            	if self.upPressed then
            		self.double_tap_button = "up"
            	elseif self.downPressed then
            		self.double_tap_button = "down"
            	elseif self.leftPressed then
            		self.double_tap_button = "left"
            	elseif self.rightPressed then
            		self.double_tap_button = "right"
            	end
                self.button_cooler = 0.25
                self.double_tap_state = 1
            end
            if self.button_cooler > 0 and self.double_tap_state == 2 then
            	-- double tap success
            	if self.toolPressed or self.shiftPressed then
            	-- DOUBLE TAP STYLE DODGING??? --
	                self.double_tap_state = 3
	                self.button_cooler = 0
	                
					if (self.downPressed and self.double_tap_button == "down") or
					   (self.leftPressed and self.double_tap_button == "left") or
					   (self.upPressed and self.double_tap_button == "up") or
					   (self.rightPressed and self.double_tap_button == "right") then
					
						self.HOPPING = true
						if self.downPressed and self.double_tap_button == "down" then
							self.hop_dir = 1
						elseif self.leftPressed and self.double_tap_button == "left" then
							self.hop_dir = 2
						elseif self.upPressed and self.double_tap_button == "up" then
							self.hop_dir = 3
						elseif self.rightPressed and self.double_tap_button == "right" then
							self.hop_dir = 4
						end
						self.SKID_COUNT = 20
						self.slide_vel = 0
						self.HOP_SLOW = 0
						self.STATE = "SHORT DODGE"
            			table.insert(map.effects, Dust(self.x-24, self.y+8))
						return
					end
            	-- ------ --- ----- ---------- --
            	else
	            	if self.upPressed and self.double_tap_button == "up" or
	            		self.downPressed and self.double_tap_button == "down" or
	            		self.leftPressed and self.double_tap_button == "left" or
	            		self.rightPressed and self.double_tap_button == "right" then
	                	self.running = true
	                end
                end
            end
        end
    end
    
    if not (self.upPressed or self.leftPressed or self.rightPressed or self.downPressed) then
        if self.running == true then
            self.running = false
        end
        if self.button_cooler <= 0 then
            self.double_tap_state = 0
        end
        if self.double_tap_state == 1 and self.button_cooler > 0 then
            self.double_tap_state = 2
        end
    end
    
    if self.running then
        self.run_dust_counter = self.run_dust_counter + dt
        if self.run_dust_counter > .3 then
            table.insert(map.effects, Dust(self.x-24, self.y+8))
            
            self.run_dust_counter = 0
        end
        xspeed = xspeed*2;
        yspeed = yspeed*2;
    end
    --------------------------------------------------------------------
    --                      ***END OF RUNNING***                      --
    
	--if (self.upPressed or self.downPressed) and (self.leftPressed or self.rightPressed) then
	--	xspeed = xspeed / 1.4 -- ~sqrt(2)
	--	yspeed = yspeed / 1.4
	--end
    
    if self.freeze_direction then
        xspeed = xspeed / 4
        yspeed = yspeed / 4
    end
    
    local turn_step = math.pi/100
    --[[
	if self.upPressed or self.yAxis < 0 then
		self.hasMoved = true
        local lower_bound, higher_bound = 1/2, 3/2
        
        if self.leftPressed then
        	higher_bound = higher_bound + 1/4
        	lower_bound = lower_bound + 1/4
        elseif self.rightPressed then
        	higher_bound = higher_bound - 1/4
        	lower_bound = lower_bound - 1/4
        end
        
        if self.displayDirection == "down" then
        	if self.move_angle >= (3/2)*math.pi - math.pi/50 and self.move_angle <= (3/2)*math.pi + math.pi/50 then
				self.move_angle = (1/2)*math.pi
				self.speed = 0
			end
		else
		    if self.move_angle > lower_bound*math.pi and self.move_angle <= higher_bound*math.pi then
		     	self.move_angle = self.move_angle - turn_step
		    else
		      	if self.move_angle < lower_bound*math.pi then
		      		self.move_angle = self.move_angle + turn_step
		      	end
		      	if self.move_angle > higher_bound*math.pi then
		      		self.move_angle = self.move_angle + turn_step
		      	end
		      	if self.move_angle >= 2*math.pi then
		      		self.move_angle = 0
		      	end
		    end
	    end
        
        self.facingDirection = "up"
	elseif self.downPressed or self.yAxis > 0 then
		self.hasMoved = true
        local lower_bound, higher_bound = 1/2, 3/2
        
        if self.leftPressed then
        	higher_bound = higher_bound - 1/4
        	lower_bound = lower_bound - 1/4
        elseif self.rightPressed then
        	higher_bound = higher_bound + 1/4
        	lower_bound = lower_bound + 1/4
        end
        
        if self.displayDirection == "up" then
        	if self.move_angle >= (1/2)*math.pi - math.pi/50 and self.move_angle <= (1/2)*math.pi + math.pi/50 then
				self.move_angle = (3/2)*math.pi
				self.speed = 0
			end
		else
	        if self.move_angle < higher_bound*math.pi and self.move_angle >= lower_bound*math.pi then
	        	self.move_angle = self.move_angle + turn_step
	        else
		        if self.move_angle <= lower_bound*math.pi then
		        	self.move_angle = self.move_angle - turn_step
		        end
		        if self.move_angle <= 0 then
		        	self.move_angle = 2*math.pi
		        end
		        if self.move_angle >= higher_bound*math.pi then
		        	self.move_angle = self.move_angle - turn_step
		        end
	        end
        end
        
        self.facingDirection = "down"
	end
	
	if self.leftPressed  or self.xAxis < 0 then
		self.hasMoved = true
        self.facingDirection = "left"
        local lower_bound, higher_bound = 1, 1
        
        if self.upPressed then
        	higher_bound = higher_bound - 1/4
        	lower_bound = lower_bound - 1/4
        elseif self.downPressed then
        	higher_bound = higher_bound + 1/4
        	lower_bound = lower_bound + 1/4
        end
        
        if self.move_angle < lower_bound*math.pi then
        	self.move_angle = self.move_angle + turn_step
        elseif self.move_angle > higher_bound*math.pi then
        	self.move_angle = self.move_angle - turn_step
        end
	        
	elseif self.rightPressed or self.xAxis > 0 then
		self.hasMoved = true
        self.facingDirection = "right"
        
        if self.upPressed then
	        if self.move_angle > (1/4)*math.pi and self.move_angle <= (5/4)*math.pi then
	        	self.move_angle = self.move_angle - turn_step
	        elseif self.move_angle > (5/4)*math.pi and self.move_angle < 2*math.pi then
	        	self.move_angle = self.move_angle + turn_step
	        end
        elseif self.downPressed then
	        if self.move_angle > 0 and self.move_angle <= math.pi then
	        	self.move_angle = self.move_angle - turn_step
	        elseif self.move_angle > math.pi and self.move_angle < 2*math.pi then
	        	self.move_angle = self.move_angle + turn_step
	        end
        else
	        if self.move_angle > 0 and self.move_angle <= math.pi then
	        	self.move_angle = self.move_angle - turn_step
	        elseif self.move_angle > math.pi and self.move_angle < 2*math.pi then
	        	self.move_angle = self.move_angle + turn_step
	        end
        end
	end
	--]]
	
	if self.upPressed or self.yAxis < 0 then
		self.hasMoved = true
        self.facingDirection = "up"
	elseif self.downPressed or self.yAxis > 0 then
		self.hasMoved = true
        self.facingDirection = "down"
	end
	
	if self.leftPressed  or self.xAxis < 0 then
		self.hasMoved = true
        self.facingDirection = "left"
	elseif self.rightPressed or self.xAxis > 0 then
		self.hasMoved = true
        self.facingDirection = "right"
	end
	
	
	
	if self.hasMoved then
		if self.speed < self.max_speed then
			self.speed = self.speed + self.speed_step
		end
	end
	
	if self.speed > self.max_speed then
		self.speed = self.speed - self.speed_step
	end
	
	
	if self.hasMoved then
		if self.speed < self.max_speed then
			self.speed = self.speed + self.speed_step
		end
	else
		if self.speed > 0 then
			self.speed = self.speed - self.speed_step
		elseif self.speed <= 0 then
			self.speed = 0
		end
	end
	
	if self.move_angle_delay <= 0 then
		if self.hasMoved then
			self.move_angle_delay = self.move_angle_delay_max
		end
		local dest_angle = self.move_angle
		if self.upPressed and not self.downPressed and not self.leftPressed and not self.rightPressed then
			-- UP
			dest_angle = (1/2)*math.pi
		elseif not self.upPressed and self.downPressed and not self.leftPressed and not self.rightPressed then
			-- DOWN
			dest_angle = (3/2)*math.pi
		elseif not self.upPressed and not self.downPressed and self.leftPressed and not self.rightPressed then
			-- LEFT
			dest_angle = math.pi
		elseif not self.upPressed and not self.downPressed and not self.leftPressed and self.rightPressed then
			-- RIGHT
			if self.move_angle > 0 and self.move_angle <= math.pi then
				dest_angle = 0
			else
				dest_angle = 2*math.pi
			end
		elseif self.upPressed and not self.downPressed and not self.leftPressed and self.rightPressed then
			-- UP RIGHT
			dest_angle = (1/4)*math.pi
		elseif self.upPressed and not self.downPressed and self.leftPressed and not self.rightPressed then
			-- UP LEFT
			dest_angle = (3/4)*math.pi
		elseif not self.upPressed and self.downPressed and self.leftPressed and not self.rightPressed then
			-- DOWN LEFT
			dest_angle = (5/4)*math.pi
		elseif not self.upPressed and self.downPressed and not self.leftPressed and self.rightPressed then
			-- DOWN RIGHT
			dest_angle = (7/4)*math.pi
		end
		
		self.dest_angle = dest_angle
	else
		self.move_angle_delay = self.move_angle_delay - 1
	end
	
	if self.upPressed or self.downPressed or self.leftPressed or self.rightPressed then
		self.move_angle = newAngle(self.move_angle, self.dest_angle)
	end
	
	self:move("right", self.speed*math.cos(-self.move_angle))
	self:move("down", self.speed*math.sin(-self.move_angle))
	
	
	
	--[[
	local moveAngle = math.atan2(yspeed, xspeed)
	
	self:move("right", xspeed*math.abs(math.cos(moveAngle)))
	self:move("down", yspeed*math.abs(math.sin(moveAngle)))
	--]]
	
	if not self.freeze_direction and not self.shiftPressed then
		if self.upPressed and not (self.downPressed or self.leftPressed or self.rightPressed) then
			self.displayDirection = "up"
		elseif self.downPressed and not (self.upPressed or self.leftPressed or self.rightPressed) then
			self.displayDirection = "down"
		elseif self.leftPressed and not (self.downPressed or self.upPressed or self.rightPressed) then
			self.displayDirection = "left"
		elseif self.rightPressed and not (self.downPressed or self.leftPressed or self.upPressed) then
			self.displayDirection = "right"
		end
		if self.upPressed and self.downPressed then
			self.displayDirection = "up"
		end
		if self.leftPressed and self.rightPressed then
			self.displayDirection = "left"
		end
	end
	
	self.spriteTimer = self.spriteTimer + dt
	
    if self.running then
        -- RUNNING
        if self.hasMoved and self.spriteTimer > .08 then
            self.spriteCounter = self.spriteCounter + 1
            self.spriteTimer = 0
            
            if self.spriteCounter > 10 then
                self.spriteCounter = 1
            end
        end
    else
        -- WALKING
        if self.hasMoved and self.spriteTimer > .045 then
            self.spriteCounter = self.spriteCounter + 1
            self.spriteTimer = 0
            
            if self.spriteCounter > 13 then
                self.spriteCounter = 2
            end
        end
    end
    
    if self.HOPPING == true then
        self.spriteCounter = 5
    else
        if self.hasMoved == false then
            self.spriteCounter = 1
        end
    end
    
end

function Knight.move(self, direction, speed)

	local temp_dir = direction
	local temp_speed = speed
	
	if speed < 0 then
		temp_speed = temp_speed*-1
		temp_dir = oppositeDirection(temp_dir)
	end
	
	if self.STATE == "LUNGE" or self.speed > self.max_speed then
		
		if not map:canMove(self, temp_dir, temp_speed) then
		
			self.spriteTimer = 50
			self.strafeDirection = temp_dir
			self.STATE = "WALL_SLIDE"
			self.wall_hit_sound:play()
			
			self.displayDirection = oppositeDirection(temp_dir)
			
        	local move_percent = 0.15
        	self.xSpeed = self.speed*math.cos(self.move_angle)
        	self.ySpeed = self.speed*math.sin(self.move_angle)
			--self.xSpeed = move_percent*(self.LUNGE_DEST_X - self.x)
			--self.ySpeed = move_percent*(self.LUNGE_DEST_Y - self.y)
			
			local slide_speed_min = 10
			
			if self.ySpeed < 0 then
				if math.abs(self.ySpeed) < slide_speed_min then
					self.ySpeed = -slide_speed_min
				end
			elseif self.ySpeed == 0 then
				self.ySpeed = 0
			else
				if math.abs(self.ySpeed) < slide_speed_min then
					self.ySpeed = slide_speed_min
				end
			end
			
			if self.xSpeed < 0 then
				if math.abs(self.xSpeed) < slide_speed_min then
					self.xSpeed = -slide_speed_min
				end
			elseif self.xSpeed == 0 then
				self.xSpeed = 0
			else
				if math.abs(self.xSpeed) < slide_speed_min then
					self.xSpeed = slide_speed_min
				end
			end
			
			if temp_dir == "down" then
				self.ySpeed = 0
			elseif temp_dir == "left" then
				self.xSpeed = 0
			elseif temp_dir == "right" then
				self.xSpeed = 0
			elseif temp_dir == "up" then
				self.ySpeed = 0
			end
		end
	else
		if not map:canMove(self, temp_dir, temp_speed) then
			if self.altPressed then
				self.STATE = "FIND_WALL"
			end
			if self.STATE == "STAND" then
				self.LUNGE_TIMER_ONE = 100
				self.LUNGE_TIMER_TWO = 100
			end
		end
	end
	
	-- quarter steps like mario 64 lol
	local quarter_speed = temp_speed/4
	local temp = true
	
	for i=1, 4 do
		temp = Sprite.move(self, temp_dir, quarter_speed)
		if not temp then
			break
		end
		
	end
	
	return temp, temp_dir
end

function Knight.decrementSpeeds(self)

	if self.xSpeed < 0 then
		if self.xSpeed + self.speed_step > 0 then
			self.xSpeed = 0
		else
			self.xSpeed = self.xSpeed + self.speed_step 
		end
	else
		if self.xSpeed - self.speed_step < 0 then
			self.xSpeed = 0
		else
			self.xSpeed = self.xSpeed - self.speed_step 
		end
	end
	
	if self.ySpeed < 0 then
		if self.ySpeed + self.speed_step > 0 then
			self.ySpeed = 0
		else
			self.ySpeed = self.ySpeed + self.speed_step 
		end
	else
		if self.ySpeed - self.speed_step < 0 then
			self.ySpeed = 0
		else
			self.ySpeed = self.ySpeed - self.speed_step 
		end
	end
	return
end

function Knight.knockback(self, other, damage)
	
	if self.isGrabbing and self.grabbedEnemy.size == "large" then
		return
	end
	
	--self:move(oppositeDirection(self:determineDirection(other)), 16)
	
	local moveAngle = math.atan2(other.y - self.y, other.x - self.x)
	self.xSpeed = damage*math.cos(moveAngle + math.pi)
	self.ySpeed = damage*math.sin(moveAngle + math.pi)
	self.STATE = "KNOCKBACK"
	
	if self.invincibility_frames > 0 then
		return
	end
	
	self.invincibility_frames = 120

	self:damage(damage)
end

function Knight.damage(self, amount)
	self.health = self.health - amount

	if self.health <= 0 then
		self.health = 0
		self:die()
	end
end

function Knight.heal(self, amount)
	self.health = self.health + amount

	if self.health > 100 then
		self.health = 100
	end
end

function Knight.die(self)
	local necromancerPact = self.flags["necromancer"]

	if necromancerPact < 1 then
		toState = GameOver()
	elseif necromancerPact < 2 then
		camera.x = 400
		camera.y = 300
		toMap = maps["Nexus-001"]
		self.x = 11 * 32
		self.y = 10 * 32
		
		self.health = 100
	--elseif necromancerPact < 3 then
	else
		toMap = maps["Nexus-002"]
		self.x = 11 * 32
		self.y = 10 * 32
		
		self.health = 100
	end
end

function Knight.initializeTools(self)
	local tools = {}

	tools["sword"] = Sword()
	tools["glove"] = Glove()
	tools["shield"] = Shield()

	return tools
end

function Knight.initializeJournal(self)

	local journal = {}
	journal["blackbell"] = JournalEntry("blackbell", 0, 0, 0)
	journal["archer"] = JournalEntry("archer", 0, 0, 0)
	journal["slime"] = JournalEntry("slime", 0, 0, 0)
	journal["minispider"] = JournalEntry("minispider", 0, 0, 0)
	journal["bigslime"] = JournalEntry("bigslime", 0, 0, 0)
	journal["bat"] = JournalEntry("bat", 0, 0, 0)
	journal["potSpider"] = JournalEntry("potSpider", 0, 0, 0)
	journal["amphora"] = JournalEntry("amphora", 0, 0, 0)
	journal["aurin"] = JournalEntry("aurin", 0, 0, 0)
	journal["porol"] = JournalEntry("porol", 0, 0, 0)
	journal["Furotis"] = JournalEntry("Furotis", 0, 0, 0)
	journal["WallSpider"] = JournalEntry("WallSpider", 0, 0, 0)
	return journal
end

function Knight.initializeFlags(self)
	local flags = {}

	flags["game"] = 1
	flags["town"] = 1
	flags["necromancer"] = 0
	flags["yome"] = 1

	return flags
end

function newAngle(cur_angle, dest_angle)
	local temp = dest_angle - cur_angle
	local turn_amount = 0.2
	local new_angle = cur_angle
	
	if dest_angle <= cur_angle then
		if math.abs(temp) > math.pi then
			new_angle = cur_angle + (math.abs(temp)- math.pi)*turn_amount
		else
			new_angle = cur_angle - math.abs(temp)*turn_amount
		end
	elseif dest_angle > cur_angle then
		if temp > math.pi then
			new_angle = cur_angle - math.abs(temp - math.pi)*turn_amount
		else
			new_angle = cur_angle + math.abs(temp)*turn_amount
		end
	end
	
	if math.abs(temp) < math.pi + 0.1 and math.abs(temp) > math.pi - 0.1  then
			new_angle = dest_angle - math.pi*(3/4)
	end
	
	if new_angle < 0 then
		new_angle = new_angle + 2*math.pi
	end
	
	if new_angle > 2*math.pi then
		new_angle = new_angle - 2*math.pi
	end
	
	
	
	return new_angle
end








