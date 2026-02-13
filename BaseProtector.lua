--// 🛡 Sprizan Base Protector (REAL FIX)

if _G.SprizanLoaded then return end
_G.SprizanLoaded = true

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

------------------------------------------------
-- CHAT COMMAND SENDER (REAL AP EXECUTION)
------------------------------------------------

local chatEvent =
game:GetService("ReplicatedStorage")
:WaitForChild("DefaultChatSystemChatEvents")
:WaitForChild("SayMessageRequest")

local function AP(command,target)
	chatEvent:FireServer(":"..command.." "..target,"All")
end

local function spamPlayer(name)
	task.spawn(function()
		for i=1,5 do
			AP("balloon",name)
			AP("ragdoll",name)
			AP("rocket",name)
			AP("jumpscare",name)
			AP("inverse",name)
			task.wait(0.15)
		end
	end)
end

------------------------------------------------
-- UI
------------------------------------------------

local gui = Instance.new("ScreenGui",guiParent)
gui.ResetOnSpawn=false

-- SP BUTTON
local sp = Instance.new("TextButton",gui)
sp.Size=UDim2.new(0,60,0,60)
sp.Position=UDim2.new(0,20,0.5,-30)
sp.Text="SP"
sp.BackgroundColor3=Color3.fromRGB(140,0,255)
sp.TextColor3=Color3.new(1,1,1)
sp.Font=Enum.Font.GothamBold
sp.TextSize=20
Instance.new("UICorner",sp).CornerRadius=UDim.new(1,0)

-- MAIN UI
local frame=Instance.new("Frame",gui)
frame.Size=UDim2.new(0,300,0,150)
frame.Position=UDim2.new(0.5,-150,0.5,-75)
frame.BackgroundColor3=Color3.fromRGB(20,15,30)
Instance.new("UICorner",frame)

local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,40)
title.BackgroundTransparency=1
title.Text="🛡 Sprizan Base Protector"
title.TextColor3=Color3.new(1,1,1)
title.Font=Enum.Font.GothamBold
title.TextScaled=true

local dc=Instance.new("TextLabel",frame)
dc.Position=UDim2.new(0,0,0,35)
dc.Size=UDim2.new(1,0,0,20)
dc.BackgroundTransparency=1
dc.Text="discord.gg/DAA3d7BcPU"
dc.TextScaled=true
dc.TextColor3=Color3.fromRGB(200,200,255)

------------------------------------------------
-- DRAG MOBILE FIX
------------------------------------------------

local drag=false
local start,origin

frame.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch
	or i.UserInputType==Enum.UserInputType.MouseButton1 then
		drag=true
		start=i.Position
		origin=frame.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if drag and (iudo(i.UserInputType=="Touch") or i.UserInputType==Enum.UserInputType.MouseMovement) then
		local delta=i.Position-start
		frame.Position=UDim2.new(
			origin.X.Scale,
			origin.X.Offset+delta.X,
			origin.Y.Scale,
			origin.Y.Offset+delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function()
	drag=false
end)

------------------------------------------------
-- UI TOGGLE
------------------------------------------------

sp.MouseButton1Click:Connect(function()
	frame.Visible=not frame.Visible
end)

------------------------------------------------
-- AUTO PROTECT (DISTANCE DETECT)
------------------------------------------------

task.spawn(function()
	while task.wait(0.4) do
		for _,p in pairs(Players:GetPlayers()) do
			if p~=player and p.Character and player.Character then

				local hrp1=p.Character:FindFirstChild("HumanoidRootPart")
				local hrp2=player.Character:FindFirstChild("HumanoidRootPart")

				if hrp1 and hrp2 then
					local dist=(hrp1.Position-hrp2.Position).Magnitude

					-- someone rushing near you (steal attempt)
					if dist < 18 then
						spamPlayer(p.Name)
					end
				end
			end
		end
	end
end)

print("🛡 Sprizan Protector Loaded (REAL)")
