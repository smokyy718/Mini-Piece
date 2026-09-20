local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local slamEvent = events:WaitForChild("slam")
local debris = game:GetService("Debris")

local modules = repStorage:WaitForChild("Modules")
local ragdoll = require(modules:WaitForChild("Ragdoll"))

local sounds = repStorage:WaitForChild("Sounds")

local vfx = repStorage:WaitForChild("Vfx")

local hitPlayers = {}

local speed = 45
local duration = 0.2

slamEvent.OnServerEvent:Connect(function(player)
	
	local char = player.Character
	
	if not char then return end 
	
	local hum = char:FindFirstChildOfClass("Humanoid")
	
	if not hum or hum.Health <= 0 then return end
	
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	
	if not rootPart then return end
	
	local hitbox = Instance.new("Part")
	hitbox.Anchored = true
	hitbox.CanCollide = false
	hitbox.Parent = workspace
	hitbox.CFrame = rootPart.CFrame
	hitbox.Size = Vector3.new(15,10,15)
	hitbox.Color = Color3.fromRGB(255, 0, 0)
	hitbox.Transparency = 1
	
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
			
			hitPlayers[enemyChar] = true
			ragdoll.Apply(enemyChar)
			enemyHum:TakeDamage(10)
			local now = os.clock()
			
			task.delay(1.5, function()
				ragdoll.Remove(enemyChar)
			end)
			
			local attachment0 = Instance.new("Attachment")
			attachment0.Parent = enemyRoot
			
			local linearVelocity = Instance.new("LinearVelocity")
			linearVelocity.Attachment0 = attachment0
			linearVelocity.Parent = rootPart
			linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
			linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
			linearVelocity.ForceLimitsEnabled = false
			
			while os.clock() - now <= duration do
				local elapsed = os.clock() - now
				local progress = elapsed / duration
				local currentSpeed = speed * (1 - progress)
				local direction = Vector3.new(0,0.6,0)
				local velocity = direction * speed
				
				linearVelocity.VectorVelocity = velocity
				
				
				task.wait()
			end
			
			debris:AddItem(attachment0, duration)
			debris:AddItem(linearVelocity, duration)
		end
		
		task.delay(0.1, function()
			hitPlayers[enemyChar] = false
		end)
	end
	
	
end)
