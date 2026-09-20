local ragdoll = {}

local ragdolledChars = {}

function ragdoll.Apply(character)
	
	if not character then return end
	
	local hum = character:FindFirstChildOfClass("Humanoid")
	
	if not hum or hum.Health <= 0 then return end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	
	if not rootPart then return end
	
	if ragdolledChars[character] == true then return end
	
	ragdolledChars[character] = true
	hum.AutoRotate = false
	hum.PlatformStand = true	
	hum.EvaluateStateMachine = false
	rootPart:SetNetworkOwner(nil)
	
	for _, joint in character:GetDescendants() do
		
		if joint:IsA("Motor6D") then
			if not joint.Part0 or not joint.Part1 then continue end
			if joint.Part0 == rootPart or joint.Part1 == rootPart then continue end
			
			local attachment0 = Instance.new("Attachment")
			attachment0.Name = "tempAttach"
			attachment0.Parent = joint.Part0
			attachment0.CFrame = joint.C0
			
			local attachment1 = Instance.new("Attachment")
			attachment1.Name = "tempAttach"
			attachment1.Parent = joint.Part1
			attachment1.CFrame = joint.C1
			
			local ballConstraint = Instance.new("BallSocketConstraint")
			ballConstraint.Name = "ballSocket"
			ballConstraint.Attachment0 = attachment0
			ballConstraint.Attachment1 = attachment1
			ballConstraint.TwistLimitsEnabled = true
			ballConstraint.LimitsEnabled = true
			ballConstraint.UpperAngle = 45
			ballConstraint.TwistLowerAngle = -45
			ballConstraint.TwistUpperAngle = 45
			ballConstraint.Parent = joint.Part0
			
			
			local noCollision = Instance.new("NoCollisionConstraint")
			noCollision.Name = "NoCollision"
			noCollision.Parent = joint.Part0
			noCollision.Part0 = joint.Part0
			noCollision.Part1 = joint.Part1
				
			joint.Enabled = false
		end
	end
	
	hum:ChangeState(Enum.HumanoidStateType.Physics)
	
	for _, parts in character:GetDescendants() do
		if parts:IsA("BasePart") and parts ~= rootPart then
			parts:SetAttribute("OgCollide", parts.CanCollide)
			
			if parts:FindFirstAncestorOfClass("Accessory") then continue end
			parts.CanCollide = true
			
			
		end
	end
	
end


function ragdoll.Remove(character)
	
	if not character then return end

	local hum = character:FindFirstChildOfClass("Humanoid")

	if not hum or hum.Health <= 0 then return end

	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if not rootPart then return end
	
	if ragdolledChars[character] == true then
		
		for _, joint in character:GetDescendants() do
			if joint:IsA("Attachment") and joint.Name == "tempAttach" then
				joint:Destroy()
			end

			if joint:IsA("BallSocketConstraint") and joint.Name == "ballSocket" then
				joint:Destroy()
			end

			if joint:IsA("NoCollisionConstraint") and joint.Name == "NoCollision" then
				joint:Destroy()
			end

			if joint:IsA("Motor6D") then
				joint.Enabled = true
			end

		end

		for _, parts in character:GetDescendants() do

			if parts:IsA("BasePart") and parts ~= rootPart then

				parts.CanCollide = parts:GetAttribute("OgCollide")

			end
		end

		hum.AutoRotate = true
		hum.PlatformStand = false
		hum.EvaluateStateMachine = true
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		rootPart:SetNetworkOwnershipAuto()

		ragdolledChars[character] = false

	end
		
	end


return ragdoll
