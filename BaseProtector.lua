-- 🛡️ Sprizan Base Protector (REAL AUTO VERSION)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--------------------------------------------------
-- SETTINGS
--------------------------------------------------

local ENABLED = true
local PROTECT_RADIUS = 20 -- studs around your base

--------------------------------------------------
-- SIMPLE UI (Mobile Drag)
--------------------------------------------------

local gui = Instance.new("ScreenGui",player.PlayerGui)
gui.ResetOnSpawn=false

local frame = Instance.new("Frame",gui)
frame.Size=UDim2.new(0,240,0,110)
frame.Position=UDim2.new(.5,-120,.7,0)
frame.BackgroundColor3=Color3.fromRGB(18,18,25)
Instance.new("UICorner",frame)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,35)
title.BackgroundTransparency=1
title.Text="🛡️ Sprizan Base Protector"
title.TextScaled=true
title.Font=Enum.Font.GothamBold
title.TextColor3=Color3.new(1,1,1)

local dc=Instance.new("TextLabel",frame)
dc.Position=UDim2.new(0,0,0,28)
dc.Size=UDim2.new(1,0,0,18)
dc.BackgroundTransparency=1
dc.Text="discord.gg/DAA3d7BcPU"
dc.TextScaled=true
dc.Font=Enum.Font.Gotham
dc.TextColor3=Color3.fromRGB(170,150,255)

local toggle=Instance.new("TextButton",frame)
toggle.Size=UDim2.new(.7,0,0,35)
toggle.Position=UDim2.new(.15,0,.55,0)
toggle.Text="ON"
toggle.BackgroundColor3=Color3.fromRGB(140,0,255)
toggle.TextScaled=true
Instance.new("UICorner",toggle)

toggle.MouseButton1Click:Connect(function()
	ENABLED=not ENABLED
	toggle.Text=ENABLED and "ON" or "OFF"
end)

--------------------------------------------------
-- MOBILE DRAG
--------------------------------------------------

local UIS=game:GetService("UserInputService")
local dragging=false
local dragStart,startPos

frame.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch
	or i.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=i.Position
		startPos=frame.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging then
		local delta=i.Position-dragStart
		frame.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)
	end
end)

--------------------------------------------------
-- ADMIN CLICK ENGINE (REAL FIX)
--------------------------------------------------

local function click(btn)
	pcall(function()
		btn:Activate()
		for _,c in pairs(getconnections(btn.Activated)) do
			c:Fire()
		end
	end)
end

local function getCommandButtons()
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

--------------------------------------------------
-- AUTO DEFENSE
--------------------------------------------------

local lastAttack={}

local function attackPlayer(target)
	if lastAttack[target] and tick()-lastAttack[target]<2 then
		return
	end
	lastAttack[target]=tick()

	task.spawn(function()
		local cmds=getCommandButtons()

		for i=1,6 do
			for _,cmd in pairs(cmds) do
				click(cmd)
			end
			task.wait(.05)
		end
	end)
end

--------------------------------------------------
-- DETECT STEAL ATTEMPT
--------------------------------------------------

local function monitorCharacter(char,plr)

	if plr==player then return end

	local hrp=char:WaitForChild("HumanoidRootPart",5)
	if not hrp then return end

	while char.Parent do
		task.wait(.15)

		if not ENABLED then continue end
		if not player.Character then continue end

		local myHRP=player.Character:FindFirstChild("HumanoidRootPart")
		if not myHRP then continue end

		local dist=(hrp.Position-myHRP.Position).Magnitude

		-- someone enters your base area
		if dist<PROTECT_RADIUS then
			attackPlayer(plr)
		end
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		monitorCharacter(char,plr)
	end)
end)

for _,plr in pairs(Players:GetPlayers()) do
	if plr~=player and plr.Character then
		task.spawn(monitorCharacter,plr.Character,plr)
	end
	plr.CharacterAdded:Connect(function(c)
		monitorCharacter(c,plr)
	end)
end

print("🛡️ Sprizan Base Protector ACTIVE")
