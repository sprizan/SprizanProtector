-- 🛡️ Sprizan Base Protector (REAL FIXED VERSION)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

--------------------------------------------------
-- SETTINGS
--------------------------------------------------

local ENABLED = true
local BASE_RADIUS = 35

--------------------------------------------------
-- UI
--------------------------------------------------

local gui = Instance.new("ScreenGui",player.PlayerGui)
gui.ResetOnSpawn=false

local frame = Instance.new("Frame",gui)
frame.Size=UDim2.new(0,260,0,120)
frame.Position=UDim2.new(.5,-130,.7,0)
frame.BackgroundColor3=Color3.fromRGB(20,20,28)
frame.Active=true
Instance.new("UICorner",frame)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,35)
title.BackgroundTransparency=1
title.Text="🛡️ Sprizan Base Protector"
title.Font=Enum.Font.GothamBold
title.TextScaled=true
title.TextColor3=Color3.new(1,1,1)

local dc=Instance.new("TextLabel",frame)
dc.Position=UDim2.new(0,0,0,30)
dc.Size=UDim2.new(1,0,0,18)
dc.BackgroundTransparency=1
dc.Text="discord.gg/DAA3d7BcPU"
dc.Font=Enum.Font.Gotham
dc.TextScaled=true
dc.TextColor3=Color3.fromRGB(170,150,255)

local toggle=Instance.new("TextButton",frame)
toggle.Size=UDim2.new(.6,0,0,35)
toggle.Position=UDim2.new(.2,0,.6,0)
toggle.Text="PROTECTOR: ON"
toggle.BackgroundColor3=Color3.fromRGB(140,0,255)
toggle.TextScaled=true
Instance.new("UICorner",toggle)

toggle.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	toggle.Text = ENABLED and "PROTECTOR: ON" or "PROTECTOR: OFF"
end)

--------------------------------------------------
-- MOBILE DRAG (REAL FIX)
--------------------------------------------------

local dragging=false
local dragStart,startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Touch
	or input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=input.Position
		startPos=frame.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging then
		local delta=input.Position-dragStart
		frame.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function()
	dragging=false
end)

--------------------------------------------------
-- ADMIN PANEL CLICK ENGINE
--------------------------------------------------

local function click(btn)
	pcall(function()
		btn:Activate()
		for _,c in pairs(getconnections(btn.Activated)) do
			c:Fire()
		end
	end)
end

local function getCommands()
	local cmds={}
	for _,v in pairs(player.PlayerGui:GetDescendants()) do
		if v:IsA("TextButton") then
			local t=(v.Text or ""):lower()

			if t:find("balloon")
			or t:find("ragdoll")
			or t:find("rocket")
			or t:find("jumpscare")
			or t:find("inverse") then
				table.insert(cmds,v)
			end
		end
	end
	return cmds
end

local attacking=false

local function attack()
	if attacking then return end
	attacking=true

	task.spawn(function()
		local cmds=getCommands()

		for i=1,8 do
			for _,cmd in pairs(cmds) do
				click(cmd)
			end
			task.wait(0.04)
		end

		task.wait(1)
		attacking=false
	end)
end

--------------------------------------------------
-- STEAL DETECTION (REAL PART)
--------------------------------------------------

local function monitorPrompt(prompt)

	if not prompt:IsA("ProximityPrompt") then return end

	prompt.PromptButtonHoldBegan:Connect(function(plr)

		if not ENABLED then return end
		if plr == player then return end
		if not player.Character then return end

		local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
		local obj = prompt.Parent

		if myHRP and obj:IsA("BasePart") then
			local dist = (obj.Position - myHRP.Position).Magnitude

			-- someone tries stealing near your base
			if dist < BASE_RADIUS then
				print("⚠️ STEAL DETECTED:",plr.Name)
				attack()
			end
		end
	end)
end

-- existing prompts
for _,v in pairs(workspace:GetDescendants()) do
	if v:IsA("ProximityPrompt") then
		monitorPrompt(v)
	end
end

-- new prompts
workspace.DescendantAdded:Connect(function(v)
	if v:IsA("ProximityPrompt") then
		monitorPrompt(v)
	end
end)

print("🛡️ Sprizan Base Protector LOADED")
