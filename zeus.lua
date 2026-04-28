local P, RS, U = game.Players.LocalPlayer, game:GetService("RunService"), game:GetService("UserInputService")
local C = P.Character or P.CharacterAdded:Wait()
local H = C:WaitForChild("Humanoid")
local G = Instance.new("ScreenGui", game.CoreGui) G.Name = "ZeusHub" G.IgnoreGuiInset = true

-- Главное меню
local M = Instance.new("Frame", G) M.Size = UDim2.new(0, 220, 0, 320) M.Position = UDim2.new(0.5, -110, 0.5, -160) M.BackgroundColor3 = Color3.fromRGB(20, 20, 20) M.Active = true M.Draggable = true
Instance.new("UICorner", M)

local T = Instance.new("TextLabel", M) T.Size = UDim2.new(1, 0, 0, 35) T.Text = "ZEUS ULTIMATE" T.TextColor3 = Color3.new(1, 0.8, 0) T.BackgroundTransparency = 1 T.TextSize = 18 T.Font = 3

local S = Instance.new("ScrollingFrame", M) S.Size = UDim2.new(1, -10, 1, -45) S.Position = UDim2.new(0, 5, 0, 40) S.BackgroundTransparency = 1 S.ScrollBarThickness = 2 S.CanvasSize = UDim2.new(0, 0, 2.2, 0)
Instance.new("UIListLayout", S).Padding = UDim.new(0, 5)

_G.Z = {}

function btn(t, f, cb)
    _G.Z[f] = false
    local b = Instance.new("TextButton", S) b.Size = UDim2.new(1, 0, 0, 30) b.Text = t .. ": OFF" b.BackgroundColor3 = Color3.fromRGB(40, 40, 40) b.TextColor3 = Color3.new(1, 1, 1) Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G.Z[f] = not _G.Z[f]
        b.Text = t .. (_G.Z[f] and ": ON" or ": OFF")
        b.BackgroundColor3 = _G.Z[f] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
        cb(_G.Z[f])
    end)
end

-- 1. ПОЛЕТ (WASD + МЫШЬ)
btn("FLY WASD", "f", function(v)
    if v then
        local bg = Instance.new("BodyGyro", C.HumanoidRootPart)
        local bv = Instance.new("BodyVelocity", C.HumanoidRootPart)
        bg.P, bg.maxTorque, bv.maxForce = 9e4, Vector3.new(9e9, 9e9, 9e9), Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while _G.Z.f do
                RS.RenderStepped:Wait()
                local cam = workspace.CurrentCamera.CFrame
                local dir = Vector3.new(0,0,0)
                if U:IsKeyDown("W") then dir = dir + cam.LookVector end
                if U:IsKeyDown("S") then dir = dir - cam.LookVector end
                if U:IsKeyDown("A") then dir = dir - cam.RightVector end
                if U:IsKeyDown("D") then dir = dir + cam.RightVector end
                bv.velocity = dir.Magnitude > 0 and dir.Unit * 100 or Vector3.new(0, 0.1, 0)
                bg.cframe = cam
                H.PlatformStand = true
            end
            bg:Destroy() bv:Destroy() H.PlatformStand = false
        end)
    end
end)

-- 2. МЕГА БЕГ (120)
btn("MEGA SPEED", "s", function(v)
    task.spawn(function() while _G.Z.s do H.WalkSpeed = 120 task.wait() end H.WalkSpeed = 16 end)
end)

-- 3. NOCLIP (СКВОЗЬ СТЕНЫ)
btn("NOCLIP", "n", function() end)
RS.Stepped:Connect(function()
    if _G.Z.n and C then for _, x in pairs(C:GetDescendants()) do if x:IsA("BasePart") then x.CanCollide = false end end end
end)

-- 4. ИНФИНИТИ ДЖАМП
btn("INF JUMP", "j", function() end)
U.JumpRequest:Connect(function() if _G.Z.j then H:ChangeState(3) end end)

-- 5. АВТО-КЛИКЕР
btn("AUTO CLICK", "ac", function(v)
    task.spawn(function() while _G.Z.ac do local t = C:FindFirstChildOfClass("Tool") if t then t:Activate() end task.wait(0.1) end end)
end)

-- 6. ESP (ВИДЕТЬ ВСЕХ)
btn("ESP", "e", function(v)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= P and p.Character then
            if v then Instance.new("Highlight", p.Character).Name = "ZH"
            elseif p.Character:FindFirstChild("ZH") then p.Character.ZH:Destroy() end
        end
    end
end)

-- 7. FULLBRIGHT (ЯРКОСТЬ)
btn("FULL BRIGHT", "fb", function(v) game.Lighting.Brightness = v and 2 or 1 end)

-- 8. FPS BOOST
btn("FPS BOOST", "fps", function() 
    for _, v in pairs(game:GetDescendants()) do if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end end 
end)

-- 9. ANTI-AFK
btn("ANTI AFK", "afk", function(v)
    if v then P.Idled:Connect(function() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end) end
end)

-- 10. NO FOG (БЕЗ ТУМАНА)
btn("NO FOG", "nf", function(v) game.Lighting.FogEnd = v and 1e5 or 1000 end)

-- 11. SUPER JUMP
btn("SUPER JUMP", "sj", function(v) H.JumpPower = v and 150 or 50 end)

-- 12. HIDE NICK (ИНВИЗ ИМЕНИ)
btn("HIDE NICK", "hn", function(v) H.DisplayDistanceType = v and 0 or 2 end)

-- 13. INSTANT RESET
local rb = Instance.new("TextButton", S) rb.Size = UDim2.new(1, 0, 0, 30) rb.Text = "RESET CHARACTER" rb.BackgroundColor3 = Color3.new(0.5, 0, 0) rb.TextColor3 = Color3.new(1, 1, 1) Instance.new("UICorner", rb)
rb.MouseButton1Click:Connect(function() H.Health = 0 end)

-- 14. DELETE GUI (ЗАКРЫТЬ МЕНЮ)
local cl = Instance.new("TextButton", S) cl.Size = UDim2.new(1, 0, 0, 30) cl.Text = "CLOSE MENU" cl.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3) cl.TextColor3 = Color3.new(1, 1, 1) Instance.new("UICorner", cl)
cl.MouseButton1Click:Connect(function() G:Destroy() end)

print("Zeus Complete Edition Loaded")
