local players = game:GetService("Players")
local repStorage = game:GetService("ReplicatedStorage")
local debris = game:GetService("Debris")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local modules = repStorage:WaitForChild("Modules")
local trails = require(modules:WaitForChild("Trails"))
local shake = require(modules:WaitForChild("CameraShake"))


local plr = players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local sounds = repStorage:WaitForChild("Sounds")
local dashSound = sounds:WaitForChild("dash")
dashSound.Looped = false
local walkSound = sounds:WaitForChild("Walk")
walkSound.Looped = false

local animsFolder = repStorage:WaitForChild("Anims")
local movementAnimsFolder = animsFolder:WaitForChild("Movement")
local idleAnim = movementAnimsFolder:WaitForChild("Idle")
local walkAnim = movementAnimsFolder:WaitForChild("Walk")
local runAnim = movementAnimsFolder:WaitForChild("Run")

local forwardAnim = movementAnimsFolder:WaitForChild("ForwardDash")
local backAnim = movementAnimsFolder:WaitForChild("BackDash")
local rightAnim = movementAnimsFolder:WaitForChild("RightDash")
local leftAnim = movementAnimsFolder:WaitForChild("LeftDash")

local animator = humanoid:WaitForChild("Animator")

local idleTrack = animator:LoadAnimation(idleAnim)
idleTrack.Looped = true
local walkTrack = animator:LoadAnimation(walkAnim)
walkTrack.Looped = true
local runTrack = animator:LoadAnimation(runAnim)
runTrack.Looped = true

local fDashTrack = animator:LoadAnimation(forwardAnim)
fDashTrack.Looped = false
local bDashTrack = animator:LoadAnimation(backAnim)
bDashTrack.Looped = false
local rDashTrack = animator:LoadAnimation(rightAnim)
rDashTrack.Looped = false
local lDashTrack = animator:LoadAnimation(leftAnim)
lDashTrack.Looped = false


local function stopAnims()
	idleTrack:Stop(0.1)
	walkTrack:Stop(0.4)
	runTrack:Stop(0.4)
end


local playerState = {}
local isRunning = false
local normalSpeed = 10
local runSpeed = 25

local isDashing = false
local speed = 150
local duration = 0.3


walkTrack:GetMarkerReachedSignal("Impact"):Connect(function()
	local state = humanoid:GetState()

	if state == Enum.HumanoidStateType.Jumping
		or state == Enum.HumanoidStateType.Freefall then
		return
	end

	walkSound:Play()
end)

runTrack:GetMarkerReachedSignal("Impact"):Connect(function()
	local state = humanoid:GetState()

	if state == Enum.HumanoidStateType.Jumping
		or state == Enum.HumanoidStateType.Freefall then
		return
	end

	walkSound:Play()
end)

-- input detector to set isrunning to true // detects if ctrl is down or up
uis.InputBegan:Connect(function(input, gpe)
	
	if gpe then return end
	if isRunning then return end
	if char:GetAttribute("Geppo") == true then return end
	if char:GetAttribute("Stunned") == true then return end
	
	if uis:IsKeyDown(Enum.KeyCode.LeftControl) then
	
		isRunning = true
		
	end
	
	
end)

uis.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftControl then
		isRunning = false
	end
end)


-- state detector
-- holds idle run and walking states // plays anims
runService.Heartbeat:Connect(function()
	
	if char:GetAttribute("Geppo") == true then stopAnims() return end
	
	local moveSpeed = humanoid.MoveDirection.Magnitude
	local moveDir = humanoid.MoveDirection
	
	if playerState[char] == "Dashing" then return end
	
	if moveSpeed <= 0.01 then
		if playerState[char] == "Idle" then return end
		
		playerState[char] = "Idle"
		stopAnims()
		idleTrack:Play(0.15)
		walkSound:Stop()

	elseif moveSpeed >= 0.01 and isRunning then
		if playerState[char] == "Running" then return end
		
		playerState[char] = "Running"
		stopAnims()
		runTrack:Play(0.2)
		humanoid.WalkSpeed = runSpeed

		
	elseif moveSpeed >= 0.01 and playerState ~= "Running" then
		if playerState[char] == "Walking" then return end
		
		playerState[char] = "Walking"
		stopAnims()
		walkTrack:Play(0.2)
		humanoid.WalkSpeed = normalSpeed

	end
end)

char:GetAttributeChangedSignal("Geppo"):Connect(function()
	if char:GetAttribute("Geppo") == false then
		playerState[char] = nil
	end
end)


----- dashing // player velocity
uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.Q then
		if isDashing then return end
		if char:GetAttribute("Geppo") == true or char:GetAttribute("Punching") == true then return end
		if char:GetAttribute("Stunned") == true then return end
		if char:GetAttribute("Slamming") == true then return end
		
		isDashing = true
		playerState[char] = "Dashing"
		dashSound:Play()
		char:SetAttribute("Dashing", true)
		trails.Apply(char)
		shake.Apply(0.65, 0.2, 5)

		
		local now = os.clock()
		
		local moveDir = humanoid.MoveDirection
		local moveSpeed = moveDir.Magnitude
		local forward = moveDir:Dot(rootPart.CFrame.LookVector)
		local right = moveDir:Dot(rootPart.CFrame.RightVector)
		local direction = nil
		
		if moveSpeed <= 0.01 then
			direction = "forward"
		elseif forward >= 0.01 then
			direction = "forward"
		elseif forward <= -0.01 then
			direction = "Backward"
		elseif right >= 0.01 then 
			direction = "Right"
		elseif right <= -0.01 then
			direction = "Left"
		end
		
		if direction == "forward" then
			direction = rootPart.CFrame.LookVector
			fDashTrack:Play(0.2)
		elseif direction == "Backward" then
			direction = -rootPart.CFrame.LookVector
			bDashTrack:Play(0.2)
		elseif direction == "Right" then
			direction = rootPart.CFrame.RightVector
			rDashTrack:Play(0.2)
		elseif direction == "Left" then
			direction = -rootPart.CFrame.RightVector
			lDashTrack:Play(0.2)
		end
		
		while os.clock() - now <= duration do
			local elapsed = os.clock() - now
			local progress = elapsed / duration
			local currentSpeed = speed * (1 - progress)
			direction = direction
			local velocity = direction * currentSpeed
			
			rootPart.AssemblyLinearVelocity = velocity
			
			task.wait()
		end
		
		
		
		task.delay(0.3, function()
			playerState[char] = ""
			char:SetAttribute("Dashing", false)
		end)
		
		task.delay(1, function()
			isDashing = false
		end)
	end
end)
