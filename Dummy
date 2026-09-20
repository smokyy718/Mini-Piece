local dummy = script.Parent
local hum = dummy:WaitForChild("Humanoid")
local healthDetector = dummy:WaitForChild("HealthDetector")
local color = healthDetector.Color

hum.HealthChanged:Connect(function(health)
	healthDetector.Color = Color3.fromRGB(255, 0, 0)
	task.wait(0.2)
	healthDetector.Color = color
end)
