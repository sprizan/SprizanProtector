--// 🛡 SPRIZAN BASE PROTECTOR GOD++
// Works Mobile + PC
-- Auto protects when someone steals from YOUR base

if _G.SprizanProtectorLoaded then return end
_G.SprizanProtectorLoaded = true

--------------------------------------------------
-- SERVICES
--------------------------------------------------

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- SETTINGS
--------------------------------------------------

local PROTECT_ENABLED = true
local COMMAND_WHITELIST = {
	rocket = true,
	balloon = true,
	ragdoll = true,
	jumpscare = true,
	inverse = true
}

--------------------------------------------------
-- UI ROOT
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "SprizanBaseProtector"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--------------------------------------------------
-- SP TOGGLE BUTTON (ALWAYS VISIBLE)
--------------------------------------------------

local spBtn = Instance.new("TextButton")
spBtn.Size = UDim2.new(0,60,0,60)
spBtn.Position = UDim2.new(0,15,0.5,-30)
spBtn.Text = "SP"
spBtn.Font = Enum.Font.GothamBold
spBtn.TextSize = 20
spBtn.TextColor3 = Color3.new(1,1,1)
spBtn.BackgroundColor3 = Color3.fromRGB(120,40,255)
spBtn.Parent = gui

Instance.new("UICorner",spBtn).CornerRadius = UDim.new(1,0)

--------------------------------------------------
-- MAIN UI
--------------------------------------------------

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,320,0,180)
frame.Position = UDim2.new(0.5,-160,0.5,-90)
frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
frame.Parent = gui

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,14)

local stroke = Instance.new("UIStroke",frame)
stroke.Color = Color3.fromRGB(170,70,255)
stroke.Thickness = 2

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "🛡 Sprizan Base Protector"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

local dc = Instance.new("TextLabel")
dc.Size = UDim2.new(1,0,0,20)
dc.Position = UDim2.new(0,0,0,35)
dc.BackgroundTransparency = 1
dc.Text = "discord.gg/DAA3d7BcPU"
dc.Font = Enum.Font.Gotham
dc.TextSize = 12
dc.TextColor3 = Color3.fromRGB(200,200,255)
dc.Parent = frame

--------------------------------------------------
-- STATUS
--------------------------------------------------

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,0,0,40)
status.Position = UDim2.new(0,0,0,70)
status.BackgroundTransparency = 1
status.Font = Enum.Font.GothamBold
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(0,255,140)
status.Text = "PROTECTION: ON"
status.Parent = frame

--------------------------------------------------
-- ENABLE BUTTON
--------------------------------------------------

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.6,0,0,40)
toggle.Position = UDim2.new(0.2,0,1,-50)
toggle.Text = "ON / OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(140,40,255)
toggle.Parent = frame

Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,10)

toggle.MouseButton1Click:Connect(function()
	PROTECT_ENABLED = not PROTECT_ENABLED
	status.Text =
		PROTECT_ENABLED and "PROTECTION: ON" or "PROTECTION: OFF"
end)

--------------------------------------------------
-- SP BUTTON SHOW/HIDE UI
--------------------------------------------------

spBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

--------------------------------------------------
-- MOBILE + PC DRAG SYSTEM
--------------------------------------------------

local dragging=false
local dragInput,startPos,dragStart

local function update(input)
	local delta=input.Position-dragStart
	frame.Position=UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset+delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset+delta.Y
	)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1
	or input.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		dragStart=input.Position
		startPos=frame.Position

		input.Changed:Connect(function()
			if input.UserInputState==Enum.UserInputState.End then
				dragging=false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseMovement
	or input.UserInputType==Enum.UserInputType.Touch then
		dragInput=input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input==dragInput and dragging then
		update(input)
	end
end)

--------------------------------------------------
-- ADMIN PANEL FINDER
--------------------------------------------------

local function getAdminButtons()
	local buttons={}
	local ap=playerGui:FindFirstChild("AdminPanel")
	if not ap then return buttons end

	for _,v in pairs(ap:GetDescendants()) do
		if v:IsA("TextButton") then
			local txt=v.Text:lower()
			for cmd in pairs(COMMAND_WHITELIST) do
				if txt:find(cmd) then
					table.insert(buttons,v)
				end
			end
		end
	end
	return buttons
end

local function click(btn)
	pcall(function()
		for _,c in pairs(getconnections(btn.MouseButton1Click)) do
			c:Fire()
		end
	end)
end

--------------------------------------------------
-- SPAM EXECUTION
--------------------------------------------------

local function protectPlayer(target)
	task.spawn(function()

		local ap=playerGui:FindFirstChild("AdminPanel")
		if not ap then return end

		local buttons=getAdminButtons()
		if #buttons==0 then return end

		for i=1,6 do
			for _,b in pairs(buttons) do
				click(b)
				task.wait(0.05)
			end
		end
	end)
end

--------------------------------------------------
-- AUTO STEAL DETECTOR (REAL FIX)
--------------------------------------------------

local function watchCharacter(char,plr)

	char.ChildAdded:Connect(function(obj)
		if not PROTECT_ENABLED then return end

		-- game gives tool/object instantly when stolen
		if obj:IsA("Tool") or obj.Name:lower():find("brain") then
			if plr~=player then
				status.Text="⚠️ THIEF: "..plr.Name
				status.TextColor3=Color3.fromRGB(255,60,60)
				protectPlayer(plr)
			end
		end
	end)
end

for _,p in pairs(Players:GetPlayers()) do
	if p~=player then
		if p.Character then
			watchCharacter(p.Character,p)
		end
		p.CharacterAdded:Connect(function(c)
			watchCharacter(c,p)
		end)
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function(c)
		watchCharacter(c,p)
	end)
end)

print("🛡 Sprizan Base Protector GOD++ Loaded")
