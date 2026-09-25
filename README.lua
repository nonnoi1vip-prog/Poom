--========================================================
-- UNIVERSAL SPEED CONTROLLER
-- Single LocalScript
-- สำหรับแมพของคุณเอง
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- SETTINGS
--========================================================

local DEFAULT_MULTIPLIER = 1
local MIN_MULTIPLIER = 0.01
local STEP = 0.1

local multiplier =
	Player:GetAttribute("SpeedMultiplier")
	or DEFAULT_MULTIPLIER

Player:SetAttribute(
	"SpeedMultiplier",
	multiplier
)

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "UniversalSpeedController"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(215, 130)
Main.Position = UDim2.new(0.5, -107, 0.7, -65)
Main.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
Main.BorderSizePixel = 0
Main.ClipsDescendants = false
Main.Active = true
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(65, 65, 75)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--========================================================
-- DRAG BAR
--========================================================

local DragBar = Instance.new("TextButton")
DragBar.Name = "DragBar"
DragBar.Size = UDim2.new(1, -45, 0, 38)
DragBar.Position = UDim2.fromOffset(0, 0)
DragBar.BackgroundTransparency = 1
DragBar.BorderSizePixel = 0
DragBar.Text = ""
DragBar.AutoButtonColor = false
DragBar.Active = true
DragBar.ZIndex = 20
DragBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "Speed Controller"
Title.TextColor3 = Color3.fromRGB(245,245,245)
Title.TextSize = 15
Title.Font = Enum.Font.GothamMedium
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Active = false
Title.ZIndex = 21
Title.Parent = DragBar

--========================================================
-- MINIMIZE
--========================================================

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Size = UDim2.fromOffset(30, 28)
Minimize.Position = UDim2.new(1, -38, 0, 5)
Minimize.BackgroundColor3 = Color3.fromRGB(45,45,55)
Minimize.BorderSizePixel = 0
Minimize.Text = "−"
Minimize.TextColor3 = Color3.fromRGB(255,255,255)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.ZIndex = 30
Minimize.Parent = Main

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0,8)
MinCorner.Parent = Minimize

--========================================================
-- SPEED DISPLAY
--========================================================

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "Speed"
SpeedLabel.Size = UDim2.new(1, -20, 0, 25)
SpeedLabel.Position = UDim2.fromOffset(10, 38)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 0.0 studs/s"
SpeedLabel.TextColor3 = Color3.fromRGB(170,215,255)
SpeedLabel.TextSize = 13
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.ZIndex = 5
SpeedLabel.Parent = Main

--========================================================
-- MINUS
--========================================================

local Minus = Instance.new("TextButton")
Minus.Name = "Minus"
Minus.Size = UDim2.fromOffset(42, 35)
Minus.Position = UDim2.fromOffset(12, 80)
Minus.BackgroundColor3 = Color3.fromRGB(48,48,58)
Minus.BorderSizePixel = 0
Minus.Text = "−"
Minus.TextColor3 = Color3.fromRGB(255,255,255)
Minus.TextSize = 18
Minus.Font = Enum.Font.GothamBold
Minus.ZIndex = 10
Minus.Parent = Main

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = UDim.new(0,8)
MinusCorner.Parent = Minus

--========================================================
-- INPUT
--========================================================

local InputBox = Instance.new("TextBox")
InputBox.Name = "Multiplier"
InputBox.Size = UDim2.fromOffset(90,35)
InputBox.Position = UDim2.fromOffset(62,80)
InputBox.BackgroundColor3 = Color3.fromRGB(42,42,50)
InputBox.BorderSizePixel = 0
InputBox.TextColor3 = Color3.fromRGB(255,255,255)
InputBox.PlaceholderColor3 = Color3.fromRGB(140,140,150)
InputBox.PlaceholderText = "ตัวคูณ"
InputBox.Text = tostring(multiplier)
InputBox.TextSize = 14
InputBox.Font = Enum.Font.GothamMedium
InputBox.ClearTextOnFocus = false
InputBox.TextXAlignment = Enum.TextXAlignment.Center
InputBox.ZIndex = 10
InputBox.Parent = Main

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0,8)
InputCorner.Parent = InputBox

--========================================================
-- PLUS
--========================================================

local Plus = Instance.new("TextButton")
Plus.Name = "Plus"
Plus.Size = UDim2.fromOffset(42,35)
Plus.Position = UDim2.fromOffset(161,80)
Plus.BackgroundColor3 = Color3.fromRGB(48,48,58)
Plus.BorderSizePixel = 0
Plus.Text = "+"
Plus.TextColor3 = Color3.fromRGB(255,255,255)
Plus.TextSize = 18
Plus.Font = Enum.Font.GothamBold
Plus.ZIndex = 10
Plus.Parent = Main

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0,8)
PlusCorner.Parent = Plus

--========================================================
-- MULTIPLIER
--========================================================

local function setMultiplier(value)

	value = tonumber(value)

	if not value then
		InputBox.Text = tostring(multiplier)
		return
	end

	if value < MIN_MULTIPLIER then
		value = MIN_MULTIPLIER
	end

	multiplier = value

	Player:SetAttribute(
		"SpeedMultiplier",
		multiplier
	)

	InputBox.Text =
		tostring(multiplier)
end

InputBox.FocusLost:Connect(function()
	setMultiplier(InputBox.Text)
end)

Minus.Activated:Connect(function()

	setMultiplier(
		multiplier - STEP
	)

end)

Plus.Activated:Connect(function()

	setMultiplier(
		multiplier + STEP
	)

end)

--========================================================
-- CHARACTER
--========================================================

local function getCharacter()
	return Player.Character
end

local function getHumanoid()

	local Character = getCharacter()

	if not Character then
		return nil
	end

	return Character:FindFirstChildOfClass("Humanoid")
end

--========================================================
-- VEHICLE
--========================================================

local function getVehicle()

	local Humanoid = getHumanoid()

	if not Humanoid then
		return nil
	end

	local Seat = Humanoid.SeatPart

	if not Seat then
		return nil
	end

	return Seat:FindFirstAncestorOfClass("Model")
end

--========================================================
-- SPEED DETECTION
--========================================================

local function getSpeed()

	local Character = getCharacter()

	if not Character then
		return 0
	end

	local Humanoid = getHumanoid()

	if Humanoid and Humanoid.SeatPart then

		local Seat = Humanoid.SeatPart

		if Seat:IsA("BasePart") then
			return Seat.AssemblyLinearVelocity.Magnitude
		end

	end

	local Root =
		Character:FindFirstChild("HumanoidRootPart")

	if Root then
		return Root.AssemblyLinearVelocity.Magnitude
	end

	return 0
end

--========================================================
-- CHARACTER SPEED
--========================================================

local function applyCharacter()

	local Humanoid = getHumanoid()

	if not Humanoid then
		return
	end

	if Humanoid.SeatPart then
		return
	end

	if Humanoid:GetAttribute("OriginalWalkSpeed") == nil then

		Humanoid:SetAttribute(
			"OriginalWalkSpeed",
			Humanoid.WalkSpeed
		)

	end

	local Original =
		Humanoid:GetAttribute("OriginalWalkSpeed")

	if typeof(Original) ~= "number" then
		Original = 16
	end

	Humanoid.WalkSpeed =
		Original * multiplier
end

--========================================================
-- VEHICLE SPEED
--========================================================

local function applyVehicle()

	local Vehicle = getVehicle()

	if not Vehicle then
		return
	end

	local Names = {
		"MaxSpeed",
		"Speed",
		"TopSpeed",
		"VehicleSpeed"
	}

	-- NumberValue
	for _, Name in ipairs(Names) do

		local Object =
			Vehicle:FindFirstChild(Name, true)

		if Object and Object:IsA("NumberValue") then

			if Object:GetAttribute("OriginalSpeed") == nil then

				Object:SetAttribute(
					"OriginalSpeed",
					Object.Value
				)

			end

			local Original =
				Object:GetAttribute("OriginalSpeed")

			Object.Value =
				Original * multiplier

			return
		end

	end

	-- Attributes
	for _, Name in ipairs(Names) do

		local Current =
			Vehicle:GetAttribute(Name)

		if typeof(Current) == "number" then

			local OriginalName =
				"_Original_" .. Name

			local Original =
				Vehicle:GetAttribute(OriginalName)

			if typeof(Original) ~= "number" then

				Original = Current

				Vehicle:SetAttribute(
					OriginalName,
					Original
				)

			end

			Vehicle:SetAttribute(
				Name,
				Original * multiplier
			)

			return
		end

	end
end

--========================================================
-- RESPAWN
--========================================================

Player.CharacterAdded:Connect(function(Character)

	local Humanoid =
		Character:WaitForChild("Humanoid")

	task.wait(0.3)

	local Saved =
		Player:GetAttribute("SpeedMultiplier")

	if typeof(Saved) == "number" then
		multiplier = Saved
	end

	InputBox.Text =
		tostring(multiplier)

	applyCharacter()
end)

--========================================================
-- UPDATE
--========================================================

RunService.RenderStepped:Connect(function()

	SpeedLabel.Text =
		"Speed: "
		.. string.format("%.1f", getSpeed())
		.. " studs/s"

	applyCharacter()
	applyVehicle()

end)

--========================================================
-- DRAG SYSTEM
--========================================================

local Dragging = false
local DragStart = nil
local StartPosition = nil
local DragInput = nil

DragBar.InputBegan:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseButton1 then

		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position

		if Input.UserInputType == Enum.UserInputType.Touch then
			DragInput = Input
		end
	end

end)

DragBar.InputChanged:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseMovement
		or Input.UserInputType == Enum.UserInputType.Touch then

		DragInput = Input
	end

end)

UserInputService.InputChanged:Connect(function(Input)

	if not Dragging then
		return
	end

	if Input ~= DragInput
		and Input.UserInputType ~= Enum.UserInputType.MouseMovement
		and Input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local Delta =
		Input.Position - DragStart

	Main.Position = UDim2.new(
		StartPosition.X.Scale,
		StartPosition.X.Offset + Delta.X,

		StartPosition.Y.Scale,
		StartPosition.Y.Offset + Delta.Y
	)

end)

UserInputService.InputEnded:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.Touch
		or Input.UserInputType == Enum.UserInputType.MouseButton1 then

		Dragging = false
		DragInput = nil

	end

end)

--========================================================
-- MINIMIZE
--========================================================

local Minimized = false

Minimize.Activated:Connect(function()

	Minimized = not Minimized

	if Minimized then

		Main.Size =
			UDim2.fromOffset(58,58)

		Title.Visible = false
		SpeedLabel.Visible = false
		Minus.Visible = false
		InputBox.Visible = false
		Plus.Visible = false

		Minimize.Size =
			UDim2.fromOffset(38,38)

		Minimize.Position =
			UDim2.fromOffset(10,10)

		Minimize.Text = "+"

	else

		Main.Size =
			UDim2.fromOffset(215,130)

		Title.Visible = true
		SpeedLabel.Visible = true
		Minus.Visible = true
		InputBox.Visible = true
		Plus.Visible = true

		Minimize.Size =
			UDim2.fromOffset(30,28)

		Minimize.Position =
			UDim2.new(1,-38,0,5)

		Minimize.Text = "−"

	end

end)

--========================================================
-- THREE FINGER RESET
--========================================================

local ActiveTouches = {}

local function resetAll()

	multiplier = DEFAULT_MULTIPLIER

	Player:SetAttribute(
		"SpeedMultiplier",
		multiplier
	)

	InputBox.Text = "1"

	Main.Position =
		UDim2.new(0.5,-107,0.7,-65)

end

UserInputService.TouchStarted:Connect(function(Touch)

	ActiveTouches[Touch] = true

	local Count = 0

	for _ in pairs(ActiveTouches) do
		Count += 1
	end

	if Count >= 3 then
		resetAll()
	end

end)

UserInputService.TouchEnded:Connect(function(Touch)

	ActiveTouches[Touch] = nil

end)

--========================================================
-- START
--========================================================

InputBox.Text =
	tostring(multiplier)

applyCharacter()
applyVehicle()
