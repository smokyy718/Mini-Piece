local debris = game:GetService("Debris")
local repStorage = game:GetService("ReplicatedStorage")
local vfx = repStorage:WaitForChild("Vfx")
local slamfx = vfx:WaitForChild("GroundSlam")

local slamVfx = {}


function slamVfx.Apply(character)
	
	if not character then return end
	
	local hum = character:FindFirstChildOfClass("Humanoid")
	
	if not hum or hum.Health <= 0 then return end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	
	if not rootPart then return end
	
	local clone = slamfx:Clone()
	clone.Anchored = true
	clone.CanCollide = false
	clone.Transparency = 1
	clone.CanTouch = false
	clone.Parent = workspace
	clone.CFrame = rootPart.CFrame * CFrame.new(0,1,0)
	
	local attachment1 = clone:WaitForChild("Ground")
	local attachment2 = clone:WaitForChild("Air")
	
	for _, parts in attachment1:GetDescendants() do
		if parts:IsA("ParticleEmitter") then
			parts:Emit(2)
		end
	end
	
	for _, parts in attachment2:GetDescendants() do
		if parts:IsA("ParticleEmitter") then
			parts:Emit(15)
		end
	end
	
	debris:AddItem(clone, 1)
	
end

return slamVfx
