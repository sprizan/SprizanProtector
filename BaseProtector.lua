--🛡️ SPRIZAN BASE PROTECTOR GOD++

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "SprizanProtector"

--------------------------------------------------
-- OPEN BUTTON
--------------------------------------------------

local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0,60,0,60)
open.Position = UDim2.new(0,20,0.5,-30)
open.Text="🛡️"
open.TextScaled=true
open.BackgroundColor3=Color3.fromRGB(140,0,255)
Instance.new("UICorner",open).CornerRadius=UDim.new(0,14)

--------------------------------------------------
-- MAIN FRAME
--------------------------------------------------

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,300,0,170)
main.Position = UDim2.new(.5,-150,.5,-85)
main.Visible=false
main.BackgroundColor3=Color3.fromRGB(15,15,20)
Instance.new("UICorner",main)

local stroke=Instance.new("UIStroke",main)
stroke.Color=Color3.fromRGB(170,80,255)
stroke.Thickness=2

-- animated neon
task.spawn(function()
	while true do
		TweenService:Create(stroke,TweenInfo.new(1.5),{
			Color=Color3.fromRGB(210,120,255)
		}):Play()
		task.wait(1.5)
		TweenService:Create(stroke,TweenInfo.new(1.5),{
			Color=Color3.fromRGB(170,80,255)
		}):Play()
		task.wait(1.5)
	end
end)

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title=Instance.new("TextLabel",main)
title.Size=UDim2.new(1,0,0,40)
title.BackgroundTransparency=1
title.Text="🛡️ Sprizan Base Protector"
title.Font=Enum.Font.GothamBold
title.TextScaled=true
title.TextColor3=Color3.new(1,1,1)

local dc=Instance.new("TextLabel",main)
dc.Position=UDim2.new(0,0,0,35)
dc.Size=UDim2.new(1,0,0,20)
dc.BackgroundTransparency=1
dc.Text="discord.gg/DAA3d7BcPU"
dc.TextScaled=true
dc.Font=Enum.Font.Gotham
dc.TextColor3=Color3.fromRGB(170,140,255)

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

local enabled=false

local toggle=Instance.new("TextButton",main)
toggle.Size=UDim2.new(.7,0,0,45)
toggle.Position=UDim2.new(.15,0,.55,0)
toggle.Text="PROTECT OFF"
toggle.TextScaled=true
toggle.BackgroundColor3=Color3.fromRGB(40,40,50)
Instance.new("UICorner",toggle)

toggle.MouseButton1Click:Connect(function()
	enabled=not enabled
	toggle.Text=enabled and "PROTECT ON" or "PROTECT OFF"
	toggle.BackgroundColor3=enabled
		and Color3.fromRGB(140,0,255)
		or Color3.fromRGB(40,40,50)
end)

--------------------------------------------------
-- MOBILE DRAG (REAL)
--------------------------------------------------

local dragging=false
local dragStart,startPos

main.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Touch
	or input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=input.Position
		startPos=main.Position

		input.Changed:Connect(function()
			if input.UserInputState==Enum.UserInputState.End then
				dragging=false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType==Enum.UserInputType.Touch
		or input.UserInputType==Enum.UserInputType.MouseMovement) then

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
-- OPEN/CLOSE
--------------------------------------------------

open.MouseButton1Click:Connect(function()
	main.Visible=not main.Visible
end)

--------------------------------------------------
-- ADMIN PANEL SCANNER (SMART)
--------------------------------------------------

local COMMANDS={"balloon","ragdoll","rocket","jumpscare","inverse"}

local function spamAdmin()
	for _,v in pairs(game:GetDescendants()) do
		if v:IsA("TextButton") then
			local txt=(v.Text or ""):lower()

			for _,cmd in pairs(COMMANDS) do
				if txt:find(cmd) then
					pcall(function()
						for _,c in pairs(getconnections(v.MouseButton1Click)) do
							c:Fire()
						end
					end)
				end
			end
		end
	end
end

--------------------------------------------------
-- INSTANT STEAL DETECTOR
--------------------------------------------------

local function watchCharacter(char,plr)
	char.ChildAdded:Connect(function(obj)

		if not enabled then return end

		local n=obj.Name:lower()

		-- detects carried brainrot objects
		if obj:IsA("Model") or obj:IsA("Part") then
			if n:find("brain") or n:find("steal") then

				-- instant spam burst
				for i=1,6 do
					spamAdmin()
					task.wait(0.15)
				end
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

print("🛡️ Sprizan Base Protector Loaded")
