local players = game:GetService("Players")
local repStorage = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local debris = game:GetService("Debris")

local modules = repStorage:WaitForChild("Modules")
local geppoVfx = require(modules:WaitForChild("GeppoVfxHandler"))
local shake = require(modules:WaitForChild("CameraShake"))


local plr = players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local sounds = repStorage:WaitForChild("Sounds")
local geppoSound = sounds:WaitForChild("Geppo")
geppoSound.Looped = false

local isJumping = false
local geppoCd = 0.4
local speed = 60
local duration = 0.2
local geppos = 0
local endCD = 2
local onCd = false

local anims = repStorage:WaitForChild("Anims")
local movementAnims = anims:WaitForChild("Movement")
local geppoAnim = movementAnims:WaitForChild("Geppo")

local animator = humanoid:WaitForChild("Animator")

local geppoTrack = animator:LoadAnimation(geppoAnim)
geppoTrack.Looped = false


uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if onCd then return end
	if char:GetAttribute("Dashing") == true or char:GetAttribute("Punching") == true then return end
	if isJumping then return end
	if char:GetAttribute("Stunned") == true then return end
	if char:GetAttribute("Slamming") == true then return end
	
	local state = humanoid:GetState()
	
	if state == Enum.HumanoidStateType.Freefall then
		
		if input.KeyCode == Enum.KeyCode.Space then
			if geppos >= 5 then 
				onCd = true
				geppos = 0
				task.delay(endCD, function()
					onCd = false
				end)
				return
			end
			
			local now = os.clock()
			char:SetAttribute("Geppo", true)
			isJumping = true
			geppoTrack:Play(0.15)
			geppos += 1
			geppoVfx.Apply(char)
			geppoSound:Play(0.1)
			shake.Apply(0.5, 0.2, 5)
			
			local attachment0 = Instance.new("Attachment")
			attachment0.Parent = rootPart
			
			local linearVelocity = Instance.new("LinearVelocity")
			linearVelocity.Parent = rootPart
			linearVelocity.Attachment0 = attachment0
			linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
			linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
			linearVelocity.ForceLimitsEnabled = false
			
			while os.clock() - now <= duration do
				
				local elapsed = os.clock() - now
				local progress = elapsed / duration
				local currentSpeed = speed * (1 - progress)
				local direction = Vector3.new(0,2,0)
				
				linearVelocity.VectorVelocity = direction * currentSpeed
				
				debris:AddItem(linearVelocity, 0.1)
				debris:AddItem(attachment0, 0.1)
				
				task.wait()
			end
			
			task.delay(0.2, function()
				isJumping = false
				char:SetAttribute("Geppo", false)
			end)
			
		end
	end
end)
