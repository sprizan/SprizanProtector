--// ==============================
-- SPRIZAN BASE PROTECTOR (FIXED)
-- ==============================

if not game:IsLoaded() then
	game.Loaded:Wait()
end

repeat task.wait() until game.Players.LocalPlayer

print("⚡ Sprizan Base Protector Loaded")

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------------------------------------------------
-- UI
------------------------------------------------

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "SprizanProtector"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,150)
main.Position = UDim2.new(0.5,-130,0.5,-75)
main.BackgroundColor3 = Color3.fromRGB(15,10,25)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(170,0,255)
stroke.Thickness = 2

-- animated glow
task.spawn(function()
	while true do
		TweenService:Create(stroke,TweenInfo.new(2),{Transparency=0.2}):Play()
		task.wait(2)
		TweenService:Create(stroke,TweenInfo.new(2),{Transparency=0.6}):Play()
		task.wait(2)
	end
end)

-- title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "🛡 Sprizan Base Protector"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(210,170,255)

-- discord
local dc = Instance.new("TextLabel", main)
dc.Position = UDim2.new(0,0,0,30)
dc.Size = UDim2.new(1,0,0,18)
dc.BackgroundTransparency = 1
dc.Text = "discord.gg/DAA3d7BcPU"
dc.Font = Enum.Font.Gotham
dc.TextScaled = true
dc.TextColor3 = Color3.fromRGB(140,140,140)

-- toggle button
local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0.7,0,0,45)
toggle.Position = UDim2.new(0.15,0,0.55,0)
toggle.BackgroundColor3 = Color3.fromRGB(170,0,255)
toggle.Text = "PROTECTOR: OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextScaled = true
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,12)

------------------------------------------------
-- DRAG SYSTEM (FIXED)
------------------------------------------------

local dragging, dragStart, startPos

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

------------------------------------------------
-- ADMIN COMMAND EXECUTOR
------------------------------------------------

local COMMANDS = {
	"balloon",
	"ragdoll",
	"rocket",
	"jumpscare",
	"inverse"
}

local function findAdminPanel()
	return playerGui:FindFirstChild("AdminPanel")
end

local function click(btn)
	for _,c in pairs(getconnections(btn.MouseButton1Click)) do
		c:Fire()
	end
end

local function punishPlayer(target)
	local panel = findAdminPanel()
	if not panel then return end

	for _,v in pairs(panel:GetDescendants()) do
		if v:IsA("TextButton") and v.Text:lower():find(target.Name:lower()) then
			click(v)
			task.wait(0.05)

			for _,cmd in pairs(panel:GetDescendants()) do
				if cmd:IsA("TextButton") then
					for _,name in pairs(COMMANDS) do
						if cmd.Text:lower():find(name) then
							click(cmd)
							task.wait(0.03)
						end
					end
				end
			end
			break
		end
	end
end

------------------------------------------------
-- STEAL DETECTION (REAL FIX)
------------------------------------------------

local enabled = false

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggle.Text = enabled and "PROTECTOR: ON" or "PROTECTOR: OFF"
end)

task.spawn(function()
	while true do
		if enabled then
			for _,plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character then
					for _,tool in pairs(plr.Character:GetChildren()) do
						if tool:IsA("Tool") then
							-- brainrot detected
							punishPlayer(plr)
						end
					end
				end
			end
		end
		task.wait(0.15) -- instant reaction
	end
end)
