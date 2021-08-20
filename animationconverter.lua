local toolbar = plugin:CreateToolbar("anim converter")
local newScriptButton = toolbar:CreateButton("convert", "convert", "rbxassetid://7224540926")
newScriptButton.ClickableWhenViewportHidden = true

local selection = game:GetService("Selection")

newScriptButton.Click:Connect(function()
	local selected = selection:Get()[1]
	if selected:IsA("KeyframeSequence") then
		local kframes = {}
		local tweenTime = 0
		local ns = Instance.new("Script")
		ns.Name = selected.Name
		ns.Source = ""
		for i,v in pairs(selected:GetDescendants()) do
			if v:IsA("Keyframe") then
				kframes[i] = v
			end
		end
		for i,v in pairs(selected:GetDescendants()) do
		if v:IsA("Keyframe") then
			if i < #kframes then
				pcall(function() tweenTime = kframes[i+1].Time - kframes[i].Time end)
			end
			ns.Source = ns.Source.."\nwait("..v.Time..")"
		elseif v:IsA("Pose") then
				if v.Name ~= "HumanoidRootPart" then
					ns.Source = ns.Source.."\ntween(welds[\""..v.Name.."\"],"..tweenTime..","..tostring(v.EasingStyle)..","..tostring(v.EasingDirection)..",default[\""..v.Name.."\"]*CFrame.new("..tostring(v.CFrame).."))"
				end
			end
		end
		ns.Parent = game:GetService("ServerScriptService")
	else
		warn("anim converter: Selected object is not of class KeyframeSequence")
	end
end)
