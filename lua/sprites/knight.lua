require("lua/sprites/sprite")
require("lua/sprites/hud")
require("lua/journalentry")
require("lua/sprites/tools/sword")
require("lua/sprites/tools/glove")
require("lua/sprites/tools/shield")

require("lua/sprites/effects/dust")

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
	
	self.tool = nil
	self.toolPressed = false
	self.subtool = nil
	self.subtoolPressed = false	
    self.tool_timer = 0
    self.tool_timer_max = 9
    self.tool_switch = 0

	self.speed = 4
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
	self.SKID_COUNT_MAX = 40
	self.SKID_COUNT = self.SKID_COUNT_MAX
	self.dodgeDirection = 0
	
	-- save data
	self.money = 0
	self.area = 0
	self.tools = self:initializeTools()
	self.journal = self:initializeJournal()
	self.flags = self:initializeFlags()
	
    -- test text
	--self.testText = "This is a test message to show how text can be produced one character at a time."
	--self.testTextCounter = 0
	--self.testTextTimer = 0
    
end

function Knight.draw(self)
    
	if options.debug then
		love.graphics.setColor(255, 0, 0, 128)
		love.graphics.rectangle("fill", self.x-32, self.y-32, 32, 32)
	end
	
	
	love.graphics.setColor(0, 100, 100, 128)		-- makeshift shadow
	love.graphics.ellipse("fill", self.x-16, self.y, 16, 4)
	
	
	if self.invincibility_frames > 0 then			
		love.graphics.setColor(255, 255, 255, 127)	-- draw char at half opacity if recently hit
	else
		love.graphics.setColor(255, 255, 255, 255)
	end
	local sprites = images:getImage(self.spriteName)
    
    
	if not (self.tool == nil) then
		self.tool:draw()
	end
    
    if self.running and (self.facingDirection == "left" or self.facingDirection == "right") then
        if self.spriteCounter > 10 then
            love.graphics.draw(sprites["image"], sprites["quads"]["run_"..self.facingDirection][10], (self.x)-48, (self.y)-64)
        else
            love.graphics.draw(sprites["image"], sprites["quads"]["run_"..self.facingDirection][self.spriteCounter], (self.x)-48, (self.y)-64)
        end
    else
        if self.STATE == "SWORD_SLASH"  then			
            love.graphics.draw(sprites["image"], sprites["quads"]["tool_use"][self.displayDirection][1], (self.x)-32, (self.y)-64)
        elseif self.STATE == "TOOL_USE" then
            if self.tool_timer > self.tool_timer_max*(2/3) and self.tool_timer <= self.tool_timer_max then
                love.graphics.draw(sprites["image"], sprites["quads"]["tool_use"][self.displayDirection][1], (self.x)-32, (self.y)-64)
            elseif self.tool_timer > self.tool_timer_max/3  and self.tool_timer <= self.tool_timer_max*(2/3)  then
                love.graphics.draw(sprites["image"], sprites["quads"]["tool_use"][self.displayDirection][2], (self.x)-32, (self.y)-64)
            elseif self.tool_timer >= 0 and self.tool_timer <= self.tool_timer_max/3  then
                love.graphics.draw(sprites["image"], sprites["quads"]["tool_use"][self.displayDirection][3], (self.x)-32, (self.y)-64)
            end
        else
            if self.spriteCounter > 7 then
                self.spriteCounter = 7
            end
			if self.freeze_direction then			
				if (self.STATE == "DODGE" or self.STATE == "SHORT DODGE") and self.HOP_OFFSET >= 0 then
					--love.graphics.draw(sprites["image"], sprites["quads"][self.displayDirection][self.spriteCounter], (self.x)-32, (self.y)-64-self.HOP_OFFSET)
					local dodge_dir = 1
					
					if self.hop_dir == 1 or self.hop_dir == 2 or self.hop_dir == 5 or self.hop_dir == 6 then
						if self.displayDirection == "down" or self.displayDirection == "up" then
							dodge_dir = 2
						end
					end
					if self.hop_dir == 3 or self.hop_dir == 4 or self.hop_dir == 6 or self.hop_dir == 7 then
						if self.displayDirection == "left" or self.displayDirection == "right" then
							dodge_dir = 2
						end
					end
					
					love.graphics.draw(sprites["image"], sprites["quads"]["dodge"][self.displayDirection][dodge_dir], (self.x)-32, (self.y)-64-self.HOP_OFFSET)
				else
					love.graphics.draw(sprites["image"], sprites["quads"][self.displayDirection][self.spriteCounter], (self.x)-32, (self.y)-64)
				end
			else
				love.graphics.draw(sprites["image"], sprites["quads"][self.displayDirection][self.spriteCounter], (self.x)-32, (self.y)-64)
			end
		end
    end
    
    
    --[[
    if self.HOPPING then
        love.graphics.print("true", 300, 200)
    else
        love.graphics.print("false", 300, 200)
    end
    
    love.graphics.print(self.HOP_SPEED, 300, 220)
    --]]
    
    -- test text
    --[[
    love.graphics.printf(string.sub(self.testText, 0, self.testTextCounter), 100, 200, 300, 'left')
    
	if self.testTextTimer > 4 then
		self.testTextTimer = 0
	else
		self.testTextTimer = self.testTextTimer + 1
	end
	
	if self.testTextCounter < string.len(self.testText) and self.testTextTimer == 4 then
		self.testTextCounter = self.testTextCounter + 1
	end
    --]]
	
    love.graphics.push("all")
	love.graphics.translate(math.floor(camera.x-400), math.floor(camera.y-300))
	self.hud:draw(self)
    love.graphics.pop("all")
end

function Knight.keypressed(self, key)
	if key == keyBindings:getUp() then
		self.upPressed = true
		self.facingDirection = "up"
	end
	if key == keyBindings:getLeft() then
		self.leftPressed = true
		self.facingDirection = "left"
	end
	if key == keyBindings:getDown() then
		self.downPressed = true
		self.facingDirection = "down"
	end
	if key == keyBindings:getRight() then
		self.rightPressed = true
		self.facingDirection = "right"
	end
	if key == keyBindings:getTool() then
		self.toolPressed = true
	end
	if key == keyBindings:getSubtool() then
		self.subtoolPressed = true
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
end

function Knight.resetKeys(self)
	self.upPressed = false
	self.downPressed = false
	self.leftPressed = false
	self.rightPressed = false
end

function Knight.skid(self, skid_speed)
    
	self.HOP_SLOW = self.HOP_SLOW + 0.11
	
    local hop_speed = skid_speed - self.HOP_SLOW
    
    if self.KICK_BOOST then
    	hop_speed = (skid_speed + 1) - self.HOP_SLOW
    end
    
    local hop_speed_diag = hop_speed/1.4
    if self.hop_dir == 1 then
        self:move("down", hop_speed)
    elseif self.hop_dir == 2 then
        self:move("left", hop_speed)
    elseif self.hop_dir == 3 then
        self:move("up", hop_speed)
    elseif self.hop_dir == 4 then
        self:move("right", hop_speed)
    elseif self.hop_dir == 5 then
        self:move("down", hop_speed_diag)
        self:move("left", hop_speed_diag)
    elseif self.hop_dir == 6 then
        self:move("up", hop_speed_diag)
        self:move("left", hop_speed_diag)
    elseif self.hop_dir == 7 then
        self:move("up", hop_speed_diag)
        self:move("right", hop_speed_diag)
    elseif self.hop_dir == 8 then
        self:move("down", hop_speed_diag)
        self:move("right", hop_speed_diag)
    end
end

function Knight.update(self, dt)
	
	if self.invincibility_frames > 0 then
		self.invincibility_frames = self.invincibility_frames - 1
    end
    
	self.hud:update(dt, self)

	if not (self.tool == nil) then
		self.tool:update(dt)
	end

	if not (self.subtool == nil) then
		self.subtool:update(dt)
	end

    if self.STATE == "TOOL_USE" then
    	self:move(self.facingDirection, self.slide_vel)
    	if self.slide_vel > 0 then
    		self.slide_vel = self.slide_vel - 1
    	end
    	
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
    
    if self.STATE == "RUN_SLIDE" then
        if self.SKID_COUNT > 0 then
            self.SKID_COUNT = self.SKID_COUNT - 1
            if self.facingDirection == "down" then
                self:move("down", 3)
            elseif self.facingDirection == "left" then
                self:move("left", 3)
            elseif self.facingDirection == "up" then
                self:move("up", 3)
            elseif self.facingDirection == "right" then
                self:move("right", 3)
            end
        else
            --self.SKID_COUNT = 0
            --self.HOP_SPEED = self.HOP_SPEED_MAX
            self.STATE = "STAND"
        end
        return
    end
    
    if self.STATE == "DODGE" or self.STATE == "SHORT DODGE" then
        self.tool:use(self)
        if not self.HOPPING and (math.abs(self.SKID_COUNT)%5) == 1 then
            table.insert(map.effects, Dust(self.x-24, self.y+8))
        end
        
        local hop_speed = self.HOP_SPEED_MAX
        
        if self.KICK_BOOST then
        	hop_speed = hop_speed + 2
        end
        
		if self.HOP_SPEED >= -hop_speed and self.HOPPING then
			self.HOP_SPEED = self.HOP_SPEED - 1
			self.HOP_OFFSET = self.HOP_OFFSET + self.HOP_SPEED
		end
        
        if self.HOP_SPEED == -hop_speed - 1 then
            self.HOPPING = false
            self.HOP_SPEED = hop_speed
            self.HOP_OFFSET = 0
        end
        
		if self.STATE == "SHORT DODGE" then 
			if self.SKID_COUNT > 0 then
				self.SKID_COUNT = self.SKID_COUNT - 1
	            self:skid(5)
			end 
		else
        -- LONG SKIDDING --
			if self.hop_dir == 0 and self.KICK_BOOST and self.SKID_COUNT <= self.SKID_COUNT_MAX/2 then
	            self.HOP_SPEED = hop_speed
	   			if self.hop_dir ~= 0 then
	   				self.KICK_BOOST = false
	   			end
   				self.HOPPING = false
	            self.STATE = "STAND"
	        	return
			end
			
			if self.SKID_COUNT > 0 then
	            self.SKID_COUNT = self.SKID_COUNT - 1
	            if self.HOP_OFFSET == 0 then
					if self.SKID_COUNT <= self.SKID_COUNT_MAX/5 then
						if not self.toolPressed then
							self.facingDirection = self.displayDirection
							self.freeze_direction = false
							--self.tool_timer = self.tool_timer_max*2
							self.tool_timer = 30
							self.STATE = "SWORD_SLASH"
							return
						end
					end
					
					local skid_portion = (1/2)
					if self.KICK_BOOST then
						skid_portion = (2/3)
					end
					
					if self.SKID_COUNT <= self.SKID_COUNT_MAX*skid_portion then
						if self.slide_vel <= 3 and (self.leftPressed or self.rightPressed or self.upPressed or self.downPressed) then
							self.slide_vel = self.slide_vel + 0.25
						end
				    end
				    
					if self.leftPressed then
						if self.hop_dir == 4 or self.hop_dir == 1 or self.hop_dir == 3 or 
						   self.hop_dir == 7  or self.hop_dir == 8 then
							self:move("left", self.slide_vel)
						end
					end
					if self.rightPressed then
						if self.hop_dir == 2 or self.hop_dir == 1 or self.hop_dir == 3 or 
						   self.hop_dir == 6  or self.hop_dir == 5  then
							self:move("right", self.slide_vel)
						end
					end
					if self.upPressed then
						if self.hop_dir == 1 or self.hop_dir == 2 or self.hop_dir == 4 or 
						   self.hop_dir == 5  or self.hop_dir == 8  then
							self:move("up", self.slide_vel)
						end
					end
					if self.downPressed then
						if self.hop_dir == 3 or self.hop_dir == 2 or self.hop_dir == 4 or 
						   self.hop_dir == 6  or self.hop_dir == 7  then
							self:move("down", self.slide_vel)
						end
					end
			    end
	            self:skid(7)
	        end
	    end
	    --
	    
        if self.SKID_COUNT <= 0 then
            self.HOP_SPEED = self.HOP_SPEED_MAX
   			if self.hop_dir ~= 0 then
   				self.KICK_BOOST = false
   			end
   			self.HOPPING = false
            self.STATE = "STAND"
        	return
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
        if not (self.tool == nil) then
            if self.tool_switch == 0 then
            	self.displayDirection = self.facingDirection
                self.tool_timer = self.tool_timer_max
                self.tool:use(self)
                self.STATE = "TOOL_USE"
                self.tool_switch = 1
                if self.hasMoved then
                	self.slide_vel = self.speed
                else
                	self.slide_vel = 0
                end
            end
            
            if (not self.freeze_direction) and self.tool_switch == 1 then
                self.freeze_direction = true
            end
		end
		
        if self.freeze_direction then
            self.tool:use(self)
        end
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
        if self.STATE == "STAND" and self.freeze_direction then
            self.HOPPING = true
            
            if not (self.downPressed or self.upPressed or self.rightPressed or self.leftPressed) then
                self.hop_dir = 0
                self.KICK_BOOST = true
            else
                if (self.downPressed) and not self.upPressed and not self.rightPressed and not self.leftPressed then
                    self.hop_dir = 1
                elseif (self.leftPressed) and not self.upPressed and not self.rightPressed and not self.downPressed then
                    self.hop_dir = 2
                elseif (self.upPressed) and not self.leftPressed and not self.rightPressed and not self.downPressed then
                    self.hop_dir = 3
                elseif (self.rightPressed) and not self.leftPressed and not self.upPressed and not self.downPressed then
                    self.hop_dir = 4
                elseif (self.downPressed and self.leftPressed) and not self.rightPressed and not self.upPressed then
                    self.hop_dir = 5
                elseif (self.upPressed and self.leftPressed) and not self.rightPressed and not self.downPressed then
                    self.hop_dir = 6
                elseif (self.upPressed and self.rightPressed) and not self.leftPressed and not self.downPressed then
                    self.hop_dir = 7
                elseif (self.downPressed and self.rightPressed) and not self.leftPressed and not self.upPressed then
                    self.hop_dir = 8
                end
            end
            
			if self.KICK_BOOST then
				self.SKID_COUNT = self.SKID_COUNT_MAX + 20
			else
				self.SKID_COUNT = self.SKID_COUNT_MAX
			end
			self.slide_vel = 0
			--soundEffects:playSoundEffect("jump")
			self.HOP_SLOW = 0
			self.STATE = "DODGE"
            return
        end
        
        if not (self.subtool == nil) then
			self.subtool:use(self)
			self.subtoolPressed = false
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

	local speed = self.speed
    
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
            	if self.toolPressed then
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
            self.STATE = "RUN_SLIDE"
            self.SKID_COUNT = 5
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
        speed = speed*2;
    end
    --------------------------------------------------------------------
    
	if (self.upPressed or self.downPressed) and (self.leftPressed or self.rightPressed) then
		speed = speed / 1.4 -- ~sqrt(2)
	end
    
    if self.freeze_direction then
        speed = speed / 2
    end
    
	if self.upPressed then
		self:move("up", speed)
		self.hasMoved = true
        self.facingDirection = "up"
	elseif self.downPressed then
		self:move("down", speed)
		self.hasMoved = true
        self.facingDirection = "down"
	end
	if self.leftPressed then
		self:move("left", speed)
		self.hasMoved = true
        self.facingDirection = "left"
	elseif self.rightPressed then
		self:move("right", speed)
		self.hasMoved = true
        self.facingDirection = "right"
	end
	
	if not self.freeze_direction then
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
        if self.hasMoved and self.spriteTimer > .15 then
            self.spriteCounter = self.spriteCounter + 1
            self.spriteTimer = 0
            
            if self.spriteCounter > 7 then
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

function Knight.knockback(self, other, damage)
	
	if self.isGrabbing and self.grabbedEnemy.size == "large" then
		return
	end
	
	self:move(self:determineDirection(other), -16)
	
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
