--put this Script into the part that you want RotationPart
local tween = game:GetService("TweenService")--Call TweenService
local tweeninfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true)--TweenInfo

game:GetService("RunService").Stepped:Connect(function()
	local tweenplay = tween:Create(script.Parent, tweeninfo, {
		CFrame = script.Parent.CFrame * CFrame.Angles(math.rad(10), math.rad(0), math.rad(0))--your can change rotation speed i recommend set 10
	})
	tweenplay:Play()
end)