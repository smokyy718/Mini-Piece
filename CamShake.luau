local runService = game:GetService("RunService")

local cameraShake = {}

local shakeStrength = 0
local shakeDuration = 0
local shakeSpeed = 0
local timeLeft = 0

function cameraShake.Apply(strength, duration, speed)
	
	shakeStrength = strength
	shakeDuration = duration
	timeLeft = duration
	shakeSpeed = speed
	
	
end

runService:BindToRenderStep("Shake", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)
	
	local cam = workspace.CurrentCamera
	timeLeft = math.max(timeLeft - deltaTime, 0)
	
	if timeLeft <= 0 then
		return
	end
	
	local fade = timeLeft / shakeDuration
	local elapsed = shakeDuration - timeLeft
	local noiseTime = elapsed * shakeSpeed
	
	local x = math.noise(noiseTime, 0) * shakeStrength * fade
	local y = math.noise(0, noiseTime) * shakeStrength * fade
	
	cam.CFrame = cam.CFrame * CFrame.new(x,y,0)
	
end)



return cameraShake
