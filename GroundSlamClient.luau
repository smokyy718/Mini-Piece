local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local repStorage = game:GetService("ReplicatedStorage")


local events = repStorage:WaitForChild("Events")
local slamEvent = events:WaitForChild("slam")

local modules = repStorage:WaitForChild("Modules")
local shake = require(modules:WaitForChild("CameraShake"))
local slamVfx = require(modules:WaitForChild("SlamVfxHandler"))


local sounds = repStorage:WaitForChild("Sounds")
local windSound = sounds:WaitForChild("windup")
windSound.Looped = false
local slamSound = sounds:WaitForChild("GroundSlam")
slamSound.Looped = false

local vfx = repStorage:WaitForChild("Vfx")

local anims = repStorage:WaitForChild("Anims")
local combatAnims = anims:WaitForChild("Combat")
local slamAnim = combatAnims:WaitForChild("slam")

local plr = players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local animator = hum:WaitForChild("Animator")
local slamTrack = animator:LoadAnimation(slamAnim)
slamTrack.Looped = false


local moveCD = 3
local isSlamming = false

slamTrack:GetMarkerReachedSignal("Impact"):Connect(function()
	slamEvent:FireServer()
	shake.Apply(1, 0.2, 6)
end)

uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.Z then
		if isSlamming then return end

		isSlamming = true
		windSound:Play(015)
		slamVfx.Apply(char)
		slamTrack:Play(0.15)
		char:SetAttribute("Slamming", true)
		shake.Apply(1.8, 0.25, 4)
		
		task.delay(0.15, function()
			slamSound:Play()
		end)
		
		task.delay(1, function()
			char:SetAttribute("Slamming", false)
		end)
		
		task.delay(moveCD, function()
			isSlamming = false
		end)
	end
end)
