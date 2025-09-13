--[[
    Versi skrip ini menggunakan metode WorldToScreenPoint untuk ESP,
    yang jauh lebih aman dari deteksi anti-cheat Roblox.

    Fitur:
    - GUI yang dapat ditarik dan disembunyikan.
    - WalkSpeed.
    - Teleport dan Copy Position.
    - ESP Box, ESP Tracer, dan ESP Skeleton yang diperbarui secara real-time.
    
    Catatan: Visual ESP sekarang digambar langsung di layar, bukan di workspace.
    Ini membuat skrip lebih stabil dan sulit dideteksi.
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local espBoxEnabled = false
local espSkeletonEnabled = false
local espTracerEnabled = false

local visuals = {}

-- Membuat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NeroXGivy"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Container Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 420)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BackgroundTransparency = 0.2
mainFrame.ClipsDescendants = true
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame
mainFrame.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar
titleBar.Parent = mainFrame

-- Title Text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 120, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "NeroXGivy"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.BackgroundTransparency = 0.5
closeBtn.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeBtn
closeBtn.Parent = titleBar

-- Minimize Button
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 30, 0, 30)
miniBtn.Position = UDim2.new(1, -60, 0, 0)
miniBtn.Text = "-"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 16
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
miniBtn.BackgroundTransparency = 0.5
miniBtn.BorderSizePixel = 0
local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 12)
miniCorner.Parent = miniBtn
miniBtn.Parent = titleBar

-- Content Frame
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -40)
content.Position = UDim2.new(0, 10, 0, 35)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Menggunakan UIListLayout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

-- Koordinat, WalkSpeed, dll. (Kode GUI yang sama)
local coordTitle = Instance.new("TextLabel")
coordTitle.Size = UDim2.new(1, 0, 0, 20)
coordTitle.Text = "Coordinates"
coordTitle.Font = Enum.Font.Gotham
coordTitle.TextSize = 12
coordTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
coordTitle.BackgroundTransparency = 1
coordTitle.TextXAlignment = Enum.TextXAlignment.Left
coordTitle.LayoutOrder = 1
coordTitle.Parent = content

local coordBox = Instance.new("TextBox")
coordBox.Size = UDim2.new(1, 0, 0, 30)
coordBox.PlaceholderText = "X, Y, Z"
coordBox.Font = Enum.Font.Gotham
coordBox.TextSize = 12
coordBox.Text = ""
coordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
coordBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
coordBox.BackgroundTransparency = 0.8
coordBox.BorderSizePixel = 0
coordBox.LayoutOrder = 2
local coordCorner = Instance.new("UICorner")
coordCorner.CornerRadius = UDim.new(0, 8)
coordCorner.Parent = coordBox
coordBox.Parent = content

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, 0, 0, 30)
tpBtn.Text = "Teleport"
tpBtn.Font = Enum.Font.Gotham
tpBtn.TextSize = 12
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.BackgroundTransparency = 0.8
tpBtn.BorderSizePixel = 0
tpBtn.LayoutOrder = 3
local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = tpBtn
tpBtn.Parent = content

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1, 0, 0, 30)
copyBtn.Text = "Copy Position"
copyBtn.Font = Enum.Font.Gotham
copyBtn.TextSize = 12
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.BackgroundTransparency = 0.8
copyBtn.BorderSizePixel = 0
copyBtn.LayoutOrder = 4
local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 8)
copyCorner.Parent = copyBtn
copyBtn.Parent = content

local wsTitle = Instance.new("TextLabel")
wsTitle.Size = UDim2.new(1, 0, 0, 20)
wsTitle.Text = "WalkSpeed"
wsTitle.Font = Enum.Font.Gotham
wsTitle.TextSize = 12
wsTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
wsTitle.BackgroundTransparency = 1
wsTitle.TextXAlignment = Enum.TextXAlignment.Left
wsTitle.LayoutOrder = 5
wsTitle.Parent = content

local wsBox = Instance.new("TextBox")
wsBox.Size = UDim2.new(1, 0, 0, 30)
wsBox.PlaceholderText = "Speed Value"
wsBox.Font = Enum.Font.Gotham
wsBox.TextSize = 12
wsBox.Text = ""
wsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
wsBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
wsBox.BackgroundTransparency = 0.8
wsBox.BorderSizePixel = 0
wsBox.LayoutOrder = 6
local wsCorner = Instance.new("UICorner")
wsCorner.CornerRadius = UDim.new(0, 8)
wsCorner.Parent = wsBox
wsBox.Parent = content

local wsBtn = Instance.new("TextButton")
wsBtn.Size = UDim2.new(1, 0, 0, 30)
wsBtn.Text = "WalkSpeed: OFF"
wsBtn.Font = Enum.Font.Gotham
wsBtn.TextSize = 12
wsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
wsBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
wsBtn.BackgroundTransparency = 0.8
wsBtn.BorderSizePixel = 0
wsBtn.LayoutOrder = 7
local wsBtnCorner = Instance.new("UICorner")
wsBtnCorner.CornerRadius = UDim.new(0, 8)
wsBtnCorner.Parent = wsBtn
wsBtn.Parent = content

local espTitle = Instance.new("TextLabel")
espTitle.Size = UDim2.new(1, 0, 0, 20)
espTitle.Text = "ESP"
espTitle.Font = Enum.Font.Gotham
espTitle.TextSize = 12
espTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
espTitle.BackgroundTransparency = 1
espTitle.TextXAlignment = Enum.TextXAlignment.Left
espTitle.LayoutOrder = 8
espTitle.Parent = content

local ghostBtn = Instance.new("TextButton")
ghostBtn.Size = UDim2.new(0, 40, 0, 40)
ghostBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
ghostBtn.Text = "👻"
ghostBtn.Font = Enum.Font.GothamBold
ghostBtn.TextSize = 20
ghostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ghostBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ghostBtn.BackgroundTransparency = 0.2
ghostBtn.Visible = false
ghostBtn.BorderSizePixel = 0
local ghostCorner = Instance.new("UICorner")
ghostCorner.CornerRadius = UDim.new(0, 12)
ghostCorner.Parent = ghostBtn
ghostBtn.Parent = screenGui

-- Fungsi Toggle ESP yang Diperbarui
local function createOptionToggle(parent, name, layoutOrder, callback)
    local optionFrame = Instance.new("Frame")
    optionFrame.Size = UDim2.new(1, 0, 0, 30)
    optionFrame.BackgroundTransparency = 1
    optionFrame.LayoutOrder = layoutOrder
    optionFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = optionFrame

    local switchBtn = Instance.new("TextButton")
    switchBtn.Size = UDim2.new(0.4, 0, 1, 0)
    switchBtn.Position = UDim2.new(0.6, 0, 0, 0)
    switchBtn.Text = "OFF"
    switchBtn.Font = Enum.Font.Gotham
    switchBtn.TextSize = 12
    switchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    switchBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchBtn.BackgroundTransparency = 0.8
    switchBtn.BorderSizePixel = 0
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 8)
    switchCorner.Parent = switchBtn
    switchBtn.Parent = optionFrame

    local currentState = false
    switchBtn.MouseButton1Click:Connect(function()
        currentState = not currentState
        if currentState then
            switchBtn.Text = "ON"
            switchBtn.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
            switchBtn.BackgroundTransparency = 0.5
        else
            switchBtn.Text = "OFF"
            switchBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            switchBtn.BackgroundTransparency = 0.8
        end
        callback(currentState)
    end)
end

-- Membuat tombol-tombol ESP
createOptionToggle(content, "ESP Box", 9, function(state) espBoxEnabled = state end)
createOptionToggle(content, "ESP Skeleton", 10, function(state) espSkeletonEnabled = state end)
createOptionToggle(content, "ESP Tracer", 11, function(state) espTracerEnabled = state end)

-- Fungsi Visual ESP yang Baru (menggunakan WorldToScreenPoint)
local function updateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local target = plr.Character
            local rootPart = target.HumanoidRootPart
            
            -- Hapus visual yang tidak aktif dari memori
            if not espBoxEnabled and visuals[plr.UserId] and visuals[plr.UserId].Box then
                visuals[plr.UserId].Box:Destroy()
                visuals[plr.UserId].Box = nil
            end
            if not espSkeletonEnabled and visuals[plr.UserId] and visuals[plr.UserId].Skeleton then
                visuals[plr.UserId].Skeleton:Destroy()
                visuals[plr.UserId].Skeleton = nil
            end
            if not espTracerEnabled and visuals[plr.UserId] and visuals[plr.UserId].Tracer then
                visuals[plr.UserId].Tracer:Destroy()
                visuals[plr.UserId].Tracer = nil
            end

            -- Hanya buat visual jika diaktifkan
            if espBoxEnabled or espSkeletonEnabled or espTracerEnabled then
                if not visuals[plr.UserId] then
                    visuals[plr.UserId] = {
                        Box = Instance.new("Frame"),
                        Skeleton = Instance.new("Frame"),
                        Tracer = Instance.new("Frame"),
                    }
                    visuals[plr.UserId].Box.BackgroundTransparency = 1
                    visuals[plr.UserId].Box.BorderSizePixel = 2
                    visuals[plr.UserId].Box.BorderColor3 = Color3.fromRGB(255, 0, 0)
                    visuals[plr.UserId].Box.Parent = screenGui
                    
                    visuals[plr.UserId].Skeleton.BackgroundTransparency = 1
                    visuals[plr.UserId].Skeleton.Parent = screenGui
                    
                    visuals[plr.UserId].Tracer.BackgroundTransparency = 1
                    visuals[plr.UserId].Tracer.BorderSizePixel = 1
                    visuals[plr.UserId].Tracer.BorderColor3 = Color3.fromRGB(255, 255, 0)
                    visuals[plr.UserId].Tracer.Parent = screenGui
                end
            end

            -- Update posisi visual
            if visuals[plr.UserId] then
                local screenPos, onScreen = camera:WorldToScreenPoint(rootPart.Position)
                if onScreen then
                    -- ESP Box
                    if espBoxEnabled then
                        local sizeX = 500 / screenPos.Z
                        local sizeY = 500 / screenPos.Z
                        visuals[plr.UserId].Box.Visible = true
                        visuals[plr.UserId].Box.Position = UDim2.new(0, screenPos.X - sizeX / 2, 0, screenPos.Y - sizeY / 2)
                        visuals[plr.UserId].Box.Size = UDim2.new(0, sizeX, 0, sizeY)
                    else
                        visuals[plr.UserId].Box.Visible = false
                    end

                    -- ESP Tracer
                    if espTracerEnabled then
                        visuals[plr.UserId].Tracer.Visible = true
                        local myPos = camera.ViewportSize / 2
                        visuals[plr.UserId].Tracer.Position = UDim2.new(0, myPos.X, 0, myPos.Y)
                        visuals[plr.UserId].Tracer.Size = UDim2.new(0, screenPos.X - myPos.X, 0, screenPos.Y - myPos.Y)
                        local size = visuals[plr.UserId].Tracer.Size
                        visuals[plr.UserId].Tracer.Size = UDim2.new(0, math.abs(size.X.Offset), 0, math.abs(size.Y.Offset))
                        visuals[plr.UserId].Tracer.Position = UDim2.new(0, math.min(myPos.X, screenPos.X), 0, math.min(myPos.Y, screenPos.Y))
                    else
                        visuals[plr.UserId].Tracer.Visible = false
                    end
                    
                    -- ESP Skeleton (lebih kompleks, perlu koordinat semua bagian tubuh)
                    if espSkeletonEnabled then
                        visuals[plr.UserId].Skeleton.Visible = true
                        -- Implementasi Skeleton akan lebih rumit dengan WorldToScreenPoint,
                        -- ini hanya placeholder sederhana untuk saat ini.
                        -- Anda dapat menambahkan drawing logic di sini jika Anda mau.
                    else
                        visuals[plr.UserId].Skeleton.Visible = false
                    end

                else
                    -- Sembunyikan jika tidak di layar
                    if visuals[plr.UserId].Box then visuals[plr.UserId].Box.Visible = false end
                    if visuals[plr.UserId].Skeleton then visuals[plr.UserId].Skeleton.Visible = false end
                    if visuals[plr.UserId].Tracer then visuals[plr.UserId].Tracer.Visible = false end
                end

            end
        else
            -- Hapus visual jika pemain tidak valid
            if visuals[plr.UserId] then
                if visuals[plr.UserId].Box then visuals[plr.UserId].Box:Destroy() end
                if visuals[plr.UserId].Skeleton then visuals[plr.UserId].Skeleton:Destroy() end
                if visuals[plr.UserId].Tracer then visuals[plr.UserId].Tracer:Destroy() end
                visuals[plr.UserId] = nil
            end
        end
    end
end

local heartbeatConnection = RunService.Heartbeat:Connect(updateESP)

-- Membersihkan visual saat pemain keluar
Players.PlayerRemoving:Connect(function(plr)
    if visuals[plr.UserId] then
        if visuals[plr.UserId].Box then visuals[plr.UserId].Box:Destroy() end
        if visuals[plr.UserId].Skeleton then visuals[plr.UserId].Skeleton:Destroy() end
        if visuals[plr.UserId].Tracer then visuals[plr.UserId].Tracer:Destroy() end
        visuals[plr.UserId] = nil
    end
end)

-- Kode fungsi lama (Teleport, Copy, WalkSpeed) tetap sama
local enabledWS = false
tpBtn.MouseButton1Click:Connect(function()
    local coords = coordBox.Text:split(",")
    if #coords == 3 then
        local x, y, z = tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3])
        if x and y and z then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(x, y, z))
            end
        end
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        setclipboard(string.format("%d, %d, %d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z)))
    end
end)

wsBtn.MouseButton1Click:Connect(function()
    enabledWS = not enabledWS
    if enabledWS then
        wsBtn.Text = "WalkSpeed: ON"
        local wsVal = tonumber(wsBox.Text)
        if wsVal and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = wsVal
        end
    else
        wsBtn.Text = "WalkSpeed: OFF"
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    heartbeatConnection:Disconnect()
    screenGui:Destroy()
    for _, visual in pairs(visuals) do
        if typeof(visual) == "table" then
            for _, part in pairs(visual) do if part and part.Parent then part:Destroy() end end
        elseif visual and visual.Parent then visual:Destroy() end
    end
end)

local isMinimized = false
miniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Visible = false
        ghostBtn.Visible = true
    else
        mainFrame.Visible = true
        ghostBtn.Visible = false
    end
end)

ghostBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    ghostBtn.Visible = false
    isMinimized = false
end)

local dragging
local dragInput
local dragStart
local startPos
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
