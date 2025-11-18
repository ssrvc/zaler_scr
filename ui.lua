-- ส่วนที่ 1: ตั้งค่าเริ่มต้น
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimeLastStandUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui
ScreenGui.DisplayOrder = 999999

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local isFullscreen = false
local normalSize = UDim2.new(0, 500, 0, 350)
local normalPosition = UDim2.new(0.5, -250, 0.5, -175)

-- สร้างปุ่ม Toggle ZALER
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ZalerToggle"
ToggleButton.Size = UDim2.new(0, 44, 0, 44)
ToggleButton.Position = UDim2.new(1, -62, 0, 4)
ToggleButton.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = ""
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ZIcon = Instance.new("TextLabel")
ZIcon.Size = UDim2.new(1, 0, 1, 0)
ZIcon.BackgroundTransparency = 1
ZIcon.Text = "Z"
ZIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
ZIcon.TextSize = 18
ZIcon.Font = Enum.Font.GothamBold
ZIcon.TextYAlignment = Enum.TextYAlignment.Center
ZIcon.Parent = ToggleButton

-- ส่วนที่ 2: ปุ่ม Check Position
local CheckButton = Instance.new("TextButton")
CheckButton.Name = "CheckButton"
CheckButton.Size = UDim2.new(0, 100, 0, 35)
CheckButton.Position = UDim2.new(0.5, -50, 0.5, -17)
CheckButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
CheckButton.BorderSizePixel = 0
CheckButton.Text = "Check Position"
CheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckButton.TextSize = 14
CheckButton.Font = Enum.Font.GothamBold
CheckButton.Parent = ScreenGui

local CheckCorner = Instance.new("UICorner")
CheckCorner.CornerRadius = UDim.new(0, 8)
CheckCorner.Parent = CheckButton

local PositionLabel = Instance.new("TextLabel")
PositionLabel.Name = "PositionLabel"
PositionLabel.Size = UDim2.new(0, 300, 0, 100)
PositionLabel.Position = UDim2.new(0.5, -150, 0.5, 50)
PositionLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
PositionLabel.BorderSizePixel = 0
PositionLabel.Text = "Drag the Z button\nthen click Check Position"
PositionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PositionLabel.TextSize = 14
PositionLabel.Font = Enum.Font.Gotham
PositionLabel.TextWrapped = true
PositionLabel.Visible = true
PositionLabel.Parent = ScreenGui

local PositionCorner = Instance.new("UICorner")
PositionCorner.CornerRadius = UDim.new(0, 10)
PositionCorner.Parent = PositionLabel

-- ระบบลากปุ่ม Toggle
local draggingToggle = false
local dragInput
local dragStart
local startPos

ToggleButton.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 draggingToggle = true
 dragStart = input.Position
 startPos = ToggleButton.Position
 
 TweenService:Create(ToggleButton, TweenInfo.new(0.2), ate(ToggleButton, TweenInfo.new(0.2), {
 BackgroundColor3 = Color3.fromRGB(0, 170, 255)
 }):Play()
 
 input.Changed:Connect(function()
 if input.UserInputState == Enum.UserInputState.End then
 draggingToggle = false
 TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
 BackgroundColor3 = Color3.fromRGB(41, 41, 41)
 }):Play()
 end
 end)
 end
end)

ToggleButton.InputChanged:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
 dragInput = input
 end
end)

UserInputService.InputChanged:Connect(function(input)
 if input == dragInput and draggingToggle then
 local delta = input.Position - dragStart
 ToggleButton.Position = UDim2.new(
 startPos.X.Scale,
 startPos.X.Offset + delta.X,
 startPos.Y.Scale,
 startPos.Y.Offset + delta.Y
 )
 end
end)

-- ส่วนที่ 3: ฟังก์ชัน Check Position
CheckButton.MouseButton1Click:Connect(function()
    local pos = ToggleButton.Position
    local viewportSize = workspace.CurrentCamera.ViewportSize
    
    local xPixel = pos.X.Scale * viewportSize.X + pos.X.Offset
    local yPixel = pos.Y.Scale * viewportSize.Y + pos.Y.Offset
    
    local positionText = string.format(
        "📍 Current Position:\n\n" ..
        "Scale: %.3f, %.3f\n" ..
        "Offset: %d, %d\n\n" ..
        "Pixel: %.0f, %.0f\n" ..
        "Screen: %.0fx%.0f\n\n" ..
        "Code:\nUDim2.new(%.3f, %d, %.3f, %d)",
        pos.X.Scale, pos.Y.Scale,
        pos.X.Offset, pos.Y.Offset,
        xPixel, yPixel,
        viewportSize.X, viewportSize.Y,
        pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset
    )
    
    PositionLabel.Text = positionText
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "Position Checked!";
        Text = string.format("X: %.0f, Y: %.0f", xPixel, yPixel);
        Duration = 3;
    })
    
    print("========== TOGGLE BUTTON POSITION ==========")
    print("Position Code: UDim2.new(" .. pos.X.Scale .. ", " .. pos.X.Offset .. ", " .. pos.Y.Scale .. ", " .. pos.Y.Offset .. ")")
    print("Pixel Position: X=" .. math.floor(xPixel) .. ", Y=" .. math.floor(yPixel))
    print("Viewport Size: " .. viewportSize.X .. "x" .. viewportSize.Y)
    print("===========================================")
    
    TweenService:Create(CheckButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    }):Play()
    wait(0.2)
    TweenService:Create(CheckButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    }):Play()
end)

-- Hover Effects
ToggleButton.MouseEnter:Connect(function()
    if not draggingToggle then
        TweenService:Create(ToggleButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(58, 58, 58)
        }):Play()
    end
end)

ToggleButton.MouseLeave:Connect(function()
    if not draggingToggle then
        TweenService:Create(ToggleButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(41, 41, 41)
        }):Play()
    end
end)

CheckButton.MouseEnter:Connect(function()
    TweenService:Create(CheckButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    }):Play()
end)

CheckButton.MouseLeave:Connect(function()
    TweenService:Create(CheckButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    }):Play()
end)

print("✅ Position Checker Loaded!")
print("📍 Drag the Z button and click Check Position")

-- ส่วนที่ 4: เสร็จสิ้น
print("✅ All parts loaded successfully!")
print("Instructions:")
print("1. Drag the Z button to where you want it")
print("2. Click 'Check Position' button")
print("3. Check the console (F9) for the position code")
print("4. Send the code to developer")
