--// ===============================
-- SPRIZAN BASE PROTECTOR (REAL FIX)
-- ===============================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("⚡ Sprizan Protector Started")

------------------------------------------------
-- UI
------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,260,0,140)
main.Position = UDim2.new(0.5,-130,0.5,-70)
main.BackgroundColor3 = Color3.fromRGB(15,10,25)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(170,0,255)
stroke.Thickness = 2

-- title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "🛡 Sprizan Base Protector"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(220,180,255)

-- discord
local dc = Instance.new("TextLabel", main)
dc.Position = UDim2.new(0,0,0,30)
dc.Size = UDim2.new(1,0,0,18)
dc.BackgroundTransparency = 1
dc.Text = "discord.gg/DAA3d7BcPU"
dc.Font = Enum.Font.Gotham
dc.TextScaled = true
dc.TextColor3 = Color3.fromRGB(140,140,140)

-- toggle
local toggle = Instance.new("TextButton", main)
toggle.Size = UDim2.new(0.7,0,0,45)
toggle.Position = UDim2.new(0.15,0,0.55,0)
toggle.BackgroundColor3 = Color3.fromRGB(120,0,255)
toggle.Text = "PROTECTOR OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextScaled = true
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,10)

------------------------------------------------
-- ✅ FIXED DRAGGING (WORKS 100%)
------------------------------------------------

local dragging = false
local dragStart
local startPos

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
-- ADMIN PANEL FINDER (REAL ONE)
------------------------------------------------

local function findAdminPanel()
	for _,v in pairs(playerGui:GetChildren()) do
		if v.Name:lower():find("admin") then
			return v
		end
	end
end

local function fireButton(btn)
	pcall(function()
		for _,c in pairs(getconnections(btn.MouseButton1Click)) do
			c:Fire()
		end
	end)
end

local COMMANDS = {
	"balloon",
	"ragdoll",
	"rocket",
	"jumpscare",
	"inverse"
}

local function punish(target)
	local panel = findAdminPanel()
	if not panel then
		warn("Admin panel not found")
		return
	end

	local playerBtn

	-- find player button
	for _,v in pairs(panel:GetDescendants()) do
		if v:IsA("TextButton") then
			if v.Text:lower():find(target.DisplayName:lower())
			or v.Text:lower():find(target.Name:lower()) then
				playerBtn = v
				break
			end
		end
	end

	if not playerBtn then
		warn("Player button not found")
		return
	end

	fireButton(playerBtn)
	task.wait(0.05)

	for _,v in pairs(panel:GetDescendants()) do
		if v:IsA("TextButton") then
			for _,cmd in pairs(COMMANDS) do
				if v.Text:lower():find(cmd) then
					fireButton(v)
					task.wait(0.03)
				end
			end
		end
	end

	print("⚡ Protected against", target.Name)
end

------------------------------------------------
-- ✅ REAL STEAL DETECTION (EVENT BASED)
------------------------------------------------

local enabled = false

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggle.Text = enabled and "PROTECTOR ON" or "PROTECTOR OFF"
end)

local function watchCharacter(char, plr)
	char.ChildAdded:Connect(function(obj)
		if not enabled then return end

		if obj:IsA("Tool") then
			print("🚨 Brainrot detected:", plr.Name)
			task.wait(0.1)
			punish(plr)
		end
	end)
end

for _,plr in pairs(Players:GetPlayers()) do
	if plr ~= player then
		if plr.Character then
			watchCharacter(plr.Character, plr)
		end

		plr.CharacterAdded:Connect(function(char)
			watchCharacter(char, plr)
		end)
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		watchCharacter(char, plr)
	end)
end)
