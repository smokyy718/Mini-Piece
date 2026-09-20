local players = game:GetService("Players")
local uis = game:GetService("UserInputService")
local repStorage = game:GetService("ReplicatedStorage")

local modulesFolder = repStorage:WaitForChild("Modules")
local shake = require(modulesFolder:WaitForChild("CameraShake"))

local sounds = repStorage:WaitForChild("Sounds")
local swingSound = sounds:WaitForChild("Swing")
swingSound.Looped = false


local plr = players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local anims = repStorage:WaitForChild("Anims")
local combatAnims = anims:WaitForChild("Combat")
local m1Anim = combatAnims:WaitForChild("m1")
local m2Anim = combatAnims:WaitForChild("m2")
local m3Anim = combatAnims:WaitForChild("m3")
local m4Anim = combatAnims:WaitForChild("m4")

local animator = hum:WaitForChild("Animator")

local m1Track = animator:LoadAnimation(m1Anim)
m1Track.Looped = false
local m2Track = animator:LoadAnimation(m2Anim)
m2Track.Looped = false
local m3Track = animator:LoadAnimation(m3Anim)
m3Track.Looped = false
local m4Track = animator:LoadAnimation(m4Anim)
m4Track.Looped = false

local events = repStorage:WaitForChild("Events")
local hitEvent = events:WaitForChild("Hit")

local sounds = repStorage:WaitForChild("Sounds")


local combo = 0
local onComboCd = false
local punchCd = 0.33
local comboCD = 0.6
local isPunching = false
local resetDuration = 2
local now = 0
local ogSpeed = hum.WalkSpeed

m1Track:GetMarkerReachedSignal("Impact"):Connect(function()
	hitEvent:FireServer()
end)

m2Track:GetMarkerReachedSignal("Impact"):Connect(function()
	hitEvent:FireServer()
end)

m3Track:GetMarkerReachedSignal("Impact"):Connect(function()
	hitEvent:FireServer()
end)

m4Track:GetMarkerReachedSignal("Impact"):Connect(function()
	hitEvent:FireServer("Fourth")
end)



uis.InputBegan:Connect(function(input, gpe)
	
	if gpe then return end
	if char:GetAttribute("Geppo") == true or char:GetAttribute("Dashing") == true then return end
	if char:GetAttribute("Stunned") == true then return end
	if char:GetAttribute("Slamming") == true then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if onComboCd then return end
		if isPunching then return end
		
		if combo >= 4 then 
			onComboCd = true
			combo = 0
			
			task.delay(comboCD, function()
				onComboCd = false
			end)
			return
		end
		
		if os.clock() - now >= resetDuration then
			combo = 0
		end
		
		isPunching = true
		char:SetAttribute("Punching", true)
		now = os.clock()
		combo += 1
		shake.Apply(0.15, 0.35, 5)
		hum.WalkSpeed = 1
		
		task.delay(0.09, function()
			swingSound:Play(0.15)
		end)
		
		if combo == 1 then
			m1Track:Play(0.15)
          
		elseif combo == 2 then
			m2Track:Play(0.15)

		elseif combo == 3 then
			m3Track:Play(0.15)

		elseif combo == 4 then
			m4Track:Play(0.15)

		end
		
		
		task.delay(punchCd, function()
			isPunching = false
			char:SetAttribute("Punching", false)
			hum.WalkSpeed = ogSpeed
		end)
		
		
	end
end)
