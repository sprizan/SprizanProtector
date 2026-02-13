--// 🛡️ SPRIZAN BASE PROTECTOR (GOD++ VERSION)
--// Copypaste Ready

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "SprizanBaseProtector"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,300,0,150)
main.Position = UDim2.new(0.5,-150,0.5,-75)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
main.BorderSizePixel = 0

Instance.new("UICorner",main).CornerRadius=UDim.new(0,12)

local stroke = Instance.new("UIStroke",main)
stroke.Color = Color3.fromRGB(170,80,255)
stroke.Thickness = 2

-- TITLE
local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency=1
title.Text="🛡️ Sprizan Base Protector"
title.Font=Enum.Font.GothamBold
title.TextSize=16
title.TextColor3=Color3.new(1,1,1)

-- DISCORD
local dc = Instance.new("TextLabel",main)
dc.Position=UDim2.new(0,0,0,32)
dc.Size=UDim2.new(1,0,0,20)
dc.BackgroundTransparency=1
dc.Text="discord.gg/DAA3d7BcPU"
dc.Font=Enum.Font.Gotham
dc.TextSize=12
dc.TextColor3=Color3.fromRGB(200,170,255)

--------------------------------------------------
-- TOGGLE BUTTON
--------------------------------------------------

local toggle = Instance.new("TextButton",main)
toggle.Size=UDim2.new(0,140,0,40)
toggle.Position=UDim2.new(0.5,-70,0.5,-10)
toggle.Text="PROTECT: OFF"
toggle.Font=Enum.Font.GothamBold
toggle.TextSize=14
toggle.BackgroundColor3=Color3.fromRGB(40,40,50)
toggle.TextColor3=Color3.new(1,1,1)

Instance.new("UICorner",toggle).CornerRadius=UDim.new(0,8)

--------------------------------------------------
-- DRAGGABLE
--------------------------------------------------

local dragging=false
local dragStart,startPos

main.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=input.Position
		startPos=main.Position
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
		main.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)
	end
end)

--------------------------------------------------
-- NEON ANIMATION
--------------------------------------------------

task.spawn(function()
	while true do
		TweenService:Create(
			stroke,
			TweenInfo.new(1.2),
			{Color=Color3.fromRGB(200,120,255)}
		):Play()
		task.wait(1.2)
		TweenService:Create(
			stroke,
			TweenInfo.new(1.2),
			{Color=Color3.fromRGB(140,60,255)}
		):Play()
		task.wait(1.2)
	end
end)

--------------------------------------------------
-- ALERT EFFECT
--------------------------------------------------

local function alert()
	local flash=Instance.new("Frame",gui)
	flash.Size=UDim2.new(1,0,1,0)
	flash.BackgroundColor3=Color3.fromRGB(170,0,255)
	flash.BackgroundTransparency=0.7
	
	TweenService:Create(
		flash,
		TweenInfo.new(.4),
		{BackgroundTransparency=1}
	):Play()
	
	game:GetService("Debris"):AddItem(flash,.4)
end

--------------------------------------------------
-- ADMIN SPAM CORE
--------------------------------------------------

local TARGET_COMMANDS={
	"balloon",
	"ragdoll",
	"rocket",
	"jumpscare",
	"inverse"
}

local function findAdminPanel()
	return playerGui:FindFirstChild("AdminPanel",true)
end

local function click(btn)
	pcall(function()
		for _,c in pairs(getconnections(btn.MouseButton1Click)) do
			c:Fire()
		end
	end)
end

local function spamPlayer(target)
	local panel=findAdminPanel()
	if not panel then return end
	
	local playerBtn=nil
	
	for _,v in pairs(panel:GetDescendants()) do
		if v:IsA("TextButton") and v.Text:find(target.Name) then
			playerBtn=v
			break
		end
	end
	
	if not playerBtn then return end
	
	click(playerBtn)
	task.wait(.01)
	
	for _,v in pairs(panel:GetDescendants()) do
		if v:IsA("TextButton") then
			local txt=v.Text:lower()
			for _,cmd in pairs(TARGET_COMMANDS) do
				if txt:find(cmd) then
					click(v)
					task.wait(.01)
				end
			end
		end
	end
end

--------------------------------------------------
-- STEAL DETECTOR (FAST LOOP)
--------------------------------------------------

local enabled=false

toggle.MouseButton1Click:Connect(function()
	enabled=not enabled
	
	toggle.Text=enabled and "PROTECT: ON" or "PROTECT: OFF"
	toggle.BackgroundColor3=enabled
		and Color3.fromRGB(120,40,255)
		or Color3.fromRGB(40,40,50)
end)

task.spawn(function()
	while true do
		task.wait(.15) -- ultra fast scan
		
		if not enabled then continue end
		
		for _,plr in pairs(Players:GetPlayers()) do
			if plr~=player and plr.Character then
				
				-- detect grabbing animation/tools
				local tool=plr.Character:FindFirstChildOfClass("Tool")
				
				if tool then
					alert()
					spamPlayer(plr)
				end
			end
		end
	end
end)

print("🛡️ Sprizan Base Protector Loaded")
