local dummy = script.Parent
local hum = dummy:WaitForChild("Humanoid")
local healthDetector = dummy:WaitForChild("HealthDetector")
local color = healthDetector.Color
local rootPart = dummy:WaitForChild("HumanoidRootPart")
local debris = game:GetService("Debris")

hum.HealthChanged:Connect(function(health)
	healthDetector.Color = Color3.fromRGB(255, 0, 0)
	task.wait(0.2)
	healthDetector.Color = color
end)


local combo = 0
local isPunching = false
local punchCd = 0.5
local comboCD = 1.5
local onComboCd = false

local repStorage = game:GetService("ReplicatedStorage")
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



local function hitboxSpawn()
	local hitPlayers = {}
	
	local hitbox = Instance.new("Part")
	hitbox.Parent = workspace
	hitbox.CFrame = rootPart.CFrame * CFrame.new(0,0,-3.5)
	hitbox.Anchored = true
	hitbox.CanCollide = false
	hitbox.Transparency = 1
	hitbox.Color = Color3.fromRGB(255, 0, 0)
	hitbox.Size = Vector3.new(5,4,6)
	
	debris:AddItem(hitbox, 0.1)
	for _, parts in workspace:GetPartsInPart(hitbox) do
		local enemyChar = parts:FindFirstAncestorOfClass("Model")
		
		if not enemyChar then continue end
		
		local enemyHum = enemyChar:FindFirstChildOfClass("Humanoid")
		
		if not enemyHum or enemyHum.Health <= 0 then continue end
		
		local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart")
		
		if not enemyRoot then continue end
		
		if hitPlayers[enemyChar] == true then continue end
		
		if enemyHum and enemyHum ~= hum then
			enemyHum:TakeDamage(5)
			enemyChar:SetAttribute("Stunned", true)
			hitPlayers[enemyChar] = true
		end
		
		task.delay(0.1, function()
			enemyChar:SetAttribute("Stunned", false)
		end)
		
	end
end

m1Track:GetMarkerReachedSignal("Impact"):Connect(function()
	hitboxSpawn()
end)

m2Track:GetMarkerReachedSignal("Impact"):Connect(function()
	hitboxSpawn()
end)

m3Track:GetMarkerReachedSignal("Impact"):Connect(function()
	hitboxSpawn()
end)

m4Track:GetMarkerReachedSignal("Impact"):Connect(function()
	hitboxSpawn()
end)



while true do
	task.wait(0.01)
	if combo >= 4 then
		combo = 0
		onComboCd = true
		task.delay(comboCD, function()
			onComboCd = false
		end)
		continue
	end
	
	if isPunching then continue end
	if onComboCd then continue end
	
	combo += 1
	isPunching = true
	
	if combo == 1 then
		m1Track:Play(0.1)
	elseif combo == 2 then
		m2Track:Play(0.1)
	elseif combo == 3 then
		m3Track:Play(0.1)
	elseif combo == 4 then
		m4Track:Play(0.1)
	end
	
	task.delay(punchCd, function()
		isPunching = false
	end)

end
