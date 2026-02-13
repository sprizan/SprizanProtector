--// 💜 Sprizan Base Protector - Neon Edition

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-------------------------------------------------
-- SETTINGS
-------------------------------------------------

local ENABLED_COMMANDS = {
	balloon=true,
	ragdoll=true,
	rocket=true,
	jumpscare=true,
	inverse=true,
}

local enabled = false
local cooldown = false

-------------------------------------------------
-- UI (NEON)
-------------------------------------------------

local gui = Instance.new("ScreenGui",playerGui)
gui.ResetOnSpawn=false
gui.Name="SprizanProtector"

local frame = Instance.new("Frame",gui)
frame.Size=UDim2.new(0,270,0,145)
frame.Position=UDim2.new(0.5,-135,0.5,-70)
frame.BackgroundColor3=Color3.fromRGB(10,10,15)
frame.BorderSizePixel=0

Instance.new("UICorner",frame).CornerRadius=UDim.new(0,14)

local stroke=Instance.new("UIStroke",frame)
stroke.Color=Color3.fromRGB(170,60,255)
stroke.Thickness=2

-- NEON PULSE
RunService.RenderStepped:Connect(function()
	local t=tick()*2
	stroke.Transparency=(math.sin(t)+1)/4
end)

-- TITLE
local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,32)
title.BackgroundTransparency=1
title.Font=Enum.Font.GothamBold
title.Text="🛡️ Sprizan Base Protector"
title.TextColor3=Color3.fromRGB(220,200,255)
title.TextSize=15

-- DISCORD
local dc=Instance.new("TextLabel",frame)
dc.Position=UDim2.new(0,0,0,30)
dc.Size=UDim2.new(1,0,0,16)
dc.BackgroundTransparency=1
dc.Font=Enum.Font.Gotham
dc.Text="discord.gg/DAA3d7BcPU"
dc.TextSize=11
dc.TextColor3=Color3.fromRGB(180,140,255)

-- STATUS
local status=Instance.new("TextLabel",frame)
status.Position=UDim2.new(0,0,0,55)
status.Size=UDim2.new(1,0,0,20)
status.BackgroundTransparency=1
status.Font=Enum.Font.GothamBold
status.Text="Status: OFF"
status.TextColor3=Color3.fromRGB(255,80,80)
status.TextSize=13

-- TOGGLE
local toggle=Instance.new("TextButton",frame)
toggle.Size=UDim2.new(0,130,0,36)
toggle.Position=UDim2.new(0.5,-65,1,-45)
toggle.BackgroundColor3=Color3.fromRGB(220,38,38)
toggle.Text="OFF"
toggle.Font=Enum.Font.GothamBold
toggle.TextColor3=Color3.new(1,1,1)
toggle.TextSize=14

Instance.new("UICorner",toggle).CornerRadius=UDim.new(0,10)

local glow=Instance.new("UIStroke",toggle)
glow.Color=Color3.fromRGB(170,60,255)
glow.Thickness=2

RunService.RenderStepped:Connect(function()
	local t=tick()*4
	glow.Transparency=(math.sin(t)+1)/3
end)

-------------------------------------------------
-- DRAG
-------------------------------------------------

local dragging,dragStart,startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=input.Position
		startPos=frame.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
		local delta=input.Position-dragStart
		frame.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)
	end
end)

-------------------------------------------------
-- TOGGLE LOGIC
-------------------------------------------------

toggle.MouseButton1Click:Connect(function()
	enabled=not enabled

	if enabled then
		toggle.Text="ON"
		toggle.BackgroundColor3=Color3.fromRGB(34,197,94)
		status.Text="Status: ACTIVE"
		status.TextColor3=Color3.fromRGB(120,255,160)
	else
		toggle.Text="OFF"
		toggle.BackgroundColor3=Color3.fromRGB(220,38,38)
		status.Text="Status: OFF"
		status.TextColor3=Color3.fromRGB(255,80,80)
	end
end)

-------------------------------------------------
-- ADMIN PANEL HELPERS
-------------------------------------------------

local function findPanel()
	return playerGui:FindFirstChild("AdminPanel")
end

local function fire(btn)
	pcall(function()
		for _,c in pairs(getconnections(btn.MouseButton1Click)) do
			c:Fire()
		end
	end)
end

local function getCommands()
	local list={}
	local panel=findPanel()
	if not panel then return list end

	for _,v in pairs(panel:GetDescendants()) do
		if v:IsA("TextButton") then
			local txt=v.Text:lower()
			for cmd,_ in pairs(ENABLED_COMMANDS) do
				if txt:find(cmd) then
					table.insert(list,v)
				end
			end
		end
	end
	return list
end

local function findPlayerButton(target)
	local panel=findPanel()
	if not panel then return end

	for _,v in pairs(panel:GetDescendants()) do
		if v:IsA("TextButton") and
			(v.Text:find(target.Name) or v.Text:find(target.DisplayName)) then
			return v
		end
	end
end

-------------------------------------------------
-- ⚡ INSTANT PROTECTION
-------------------------------------------------

local function punish(plr)
	if cooldown then return end
	cooldown=true

	task.spawn(function()

		local pbtn=findPlayerButton(plr)
		if not pbtn then cooldown=false return end

		fire(pbtn)

		local cmds=getCommands()
		for _,cmd in ipairs(cmds) do
			fire(cmd) -- instant chain fire
		end

		task.wait(2)
		cooldown=false
	end)
end

-------------------------------------------------
-- DETECT PICKUP (FAST)
-------------------------------------------------

local function watchCharacter(char,plr)

	char.DescendantAdded:Connect(function(obj)
		if not enabled then return end
		if plr==player then return end

		if obj:IsA("Tool") then
			local n=obj.Name:lower()

			if n:find("brain") or n:find("steal") then
				punish(plr)
			end
		end
	end)
end

for _,plr in pairs(Players:GetPlayers()) do
	if plr~=player then
		if plr.Character then
			watchCharacter(plr.Character,plr)
		end
		plr.CharacterAdded:Connect(function(c)
			watchCharacter(c,plr)
		end)
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(c)
		watchCharacter(c,plr)
	end)
end)

print("💜 Sprizan Neon Base Protector Loaded")
