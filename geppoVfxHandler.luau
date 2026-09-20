local repStorage = game:GetService("ReplicatedStorage")
local debris = game:GetService("Debris")
local vfx = repStorage:WaitForChild("Vfx")
local geppoFx = vfx:WaitForChild("GeppoVfx")

local geppoVfx = {}


function geppoVfx.Apply(character)
	
	if not character then return end
	
	local hum = character:FindFirstChildOfClass("Humanoid")
	
	if not hum or hum.Health <= 0 then return end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	
	if not rootPart then return end
	
	local clone = geppoFx:Clone()
	clone.Anchored = true
	clone.CanCollide = false
	clone.Parent = workspace
	clone.CFrame = rootPart.CFrame * CFrame.new(0,-3,0)
	clone.CanTouch = false
	clone.CanQuery = false
	clone.Transparency = 1
	
	for _, parts in clone:GetDescendants() do
		if parts:IsA("ParticleEmitter") then
			parts:Emit(1)
		end
	end
	
	debris:AddItem(clone, 0.5)
	debris:AddItem(highlight, 0.2)
	
end


return geppoVfx
