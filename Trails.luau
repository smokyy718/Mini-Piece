local debris = game:GetService("Debris")
local repStorage = game:GetService("ReplicatedStorage")
local vfxFolder = repStorage:WaitForChild("Vfx")
local dodgeTrail = vfxFolder:WaitForChild("DodgeTrail")

local trail = {}

function trail.Apply(character)
	if not character then return end
	
	local hum = character:FindFirstChildOfClass("Humanoid")
	
	if not hum or hum.Health <= 0 then return end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	
	if not rootPart then return end
	
	local rArm = character:FindFirstChild("Right Arm")
	local lArm = character:FindFirstChild("Left Arm")
	
	local clone1 = dodgeTrail:Clone()
	clone1.Anchored = false
	clone1.CanCollide = false
	clone1.CanTouch = false
	clone1.Transparency = 1
	clone1.Parent = rArm
	clone1.CFrame = rArm.CFrame

	
	local weld1 = Instance.new("WeldConstraint")
	weld1.Parent = clone1
	weld1.Part0 = rArm
	weld1.Part1 = clone1
	
	local clone2 = dodgeTrail:Clone()
	clone2.Anchored = false
	clone2.CanCollide = false
	clone2.CanTouch = false
	clone2.Transparency = 1
	clone2.Parent = lArm
	clone2.CFrame = lArm.CFrame


	local weld2 = Instance.new("WeldConstraint")
	weld2.Parent = clone2
	weld2.Part0 = lArm
	weld2.Part1 = clone2
	
	debris:AddItem(clone1, 0.42)
	debris:AddItem(weld1, 0.42)
	debris:AddItem(clone2, 0.42)
	debris:AddItem(weld2, 0.42)
end


return trail
