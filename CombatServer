local repStorage = game:GetService("ReplicatedStorage")
local debris = game:GetService("Debris")

local sounds = repStorage:WaitForChild("Sounds")
local hitSound = sounds:WaitForChild("Punch")
hitSound.Looped = false

local events = repStorage:WaitForChild("Events")
local hitEvent = events:WaitForChild("Hit")

local modules = repStorage:WaitForChild("Modules")
local ragdoll = require(modules:WaitForChild("Ragdoll"))

local hitPlayers = {}
local stunIndexes = {}

local anims = repStorage:WaitForChild("Anims")
local enemyAnims = anims:WaitForChild("Enemy")
local stun1Anim = enemyAnims:WaitForChild("Stun1")
local stun2Anim = enemyAnims:WaitForChild("Stun2")
local stun3Anim = enemyAnims:WaitForChild("Stun3")

hitEvent.OnServerEvent:Connect(function(player, Fourth)
	
	local char = player.Character
	
	if not char then return end
	
	local hum = char:FindFirstChildOfClass("Humanoid")
	
	if not hum or hum.Health <= 0 then return end
	
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	
	if not rootPart then return end
	
	local duration = 0.3
	local direction = rootPart.CFrame.LookVector
	local normSpeed = 15
	local fourthSpeed = 55
	
	print("Recieved")
	
	local hitbox = Instance.new("Part")
	hitbox.Parent = workspace
	hitbox.Size = Vector3.new(5,4,6)
	hitbox.Transparency = 1
	hitbox.CFrame = rootPart.CFrame * CFrame.new(0,0,-3.5)
	hitbox.CanCollide = false
	hitbox.Anchored = true
	hitbox.Color = Color3.fromRGB(255, 0, 0)

	debris:AddItem(hitbox, 0.1)
	
	for _, parts in workspace:GetPartsInPart(hitbox) do
		
		local enemyChar = parts:FindFirstAncestorOfClass("Model")
		
		if not enemyChar then continue end
		
		local enemyHum = enemyChar:FindFirstChildOfClass("Humanoid")
		
		if not enemyHum or enemyHum.Health <= 0 then continue end
		
		local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart")
		
		if not enemyRoot then continue end
		
		if hitPlayers[enemyChar] == true then continue end
		
		local enemyAnimator = enemyHum:FindFirstChildOfClass("Animator")
		
		if not enemyAnimator then
			local animator = Instance.new("Animator")
			animator.Parent = enemyHum
		end
		
		local stunTracks = {
			
			enemyAnimator:LoadAnimation(stun1Anim),
			enemyAnimator:LoadAnimation(stun2Anim),
			enemyAnimator:LoadAnimation(stun3Anim)
			
		}
		
		
		if enemyHum and enemyHum ~= hum then
			
			local stunTrack = (stunIndexes[enemyChar] or 0) + 1
			
			if stunTrack > #stunTracks then
				stunTrack = 1
			end
			
			stunIndexes[enemyChar] = stunTrack
			local now = os.clock()
			
			if Fourth then
				
				hitPlayers[enemyChar] = true
				enemyHum:TakeDamage(3)
				hitSound:Play()
				stunTracks[stunTrack]:Play()
				enemyChar:SetAttribute("Stunned", true)
				ragdoll.Apply(enemyChar)
				
				task.delay(1, function()
					ragdoll.Remove(enemyChar)
				end)
				
				while os.clock() - now <= duration do
					local elapsed = os.clock() - now
					local progress = elapsed / duration
					local currentSpeed = fourthSpeed * (1 - progress)
					local direction = direction
					local velocity = direction * currentSpeed
					
					enemyRoot.AssemblyLinearVelocity = velocity
					
					task.wait()
				end
			
			else
				
				hitPlayers[enemyChar] = true
				enemyHum:TakeDamage(1)
				hitSound:Play()
				stunTracks[stunTrack]:Play()
				enemyChar:SetAttribute("Stunned", true)
				
				while os.clock() - now <= duration do
					local elapsed = os.clock() - now
					local progress = elapsed / duration
					local currentSpeed = normSpeed * (1 - progress)
					local direction = direction
					local velocity = direction * currentSpeed

					enemyRoot.AssemblyLinearVelocity = velocity
					
					task.wait()
				end
				
			end
		end
		
		task.delay(0.1, function()
			hitPlayers[enemyChar] = false
			enemyChar:SetAttribute("Stunned", false)
		end)
		
		
	end
	
end)
