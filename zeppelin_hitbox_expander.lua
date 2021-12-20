local players = game:GetService("Players")
local teams = game:GetService("Teams")
local localplayer = players.LocalPlayer

if localplayer.PlayerScripts:FindFirstChild("AntiHitBox") then
  localplayer.PlayerScripts.AntiHitBox:Destroy()
end

function disable_connections(player)
    local char = player.Character
    
    if not char then return end
    if player == localplayer then return end
    
    for i, body_part in pairs(char:GetChildren()) do
        for i, connection in pairs(getconnections(body_part.Changed)) do
            connection:Disable()
        end
    end
end

function expand_hitbox(player)
    local char = player.Character
    
    if not char then return end
    if not char:FindFirstChild("HumanoidRootPart") then return end
    if player == localplayer then return end
    if localplayer.Team == player.Team then return end
    
    char.HumanoidRootPart.Size = Vector3.new(30, 30, 30)
    char.HumanoidRootPart.Transparency = .5
    char.HumanoidRootPart.CanCollide = false
end

function expand_planehitbox(plane)
    wait(2)
    plane:WaitForChild("Cockpit", 10)
    
    if not plane:FindFirstChild("User") then return end
    if not plane:FindFirstChild("Cockpit") then return end
    if plane.User.Value == localplayer then return end
    if plane.User.Value and plane.User.Value:IsA("Player") then
        if plane.User.Value.Team == localplayer.Team then return end
    end

    plane.Cockpit.Size *= 6
    plane.Cockpit.Transparency = .5
    plane.Cockpit.Color = Color3.fromRGB(255,0,0)
end

function setup(player)
    disable_connections(player)
    expand_hitbox(player)

    player.CharacterAdded:Connect(function()
        wait(3)
        disable_connections(player)
        expand_hitbox(player)
    end)
end


-- connections
for i, player in pairs(players:GetPlayers()) do
    setup(player)
end

for i, plane in pairs(workspace:GetChildren()) do
    expand_planehitbox(plane)
end

players.PlayerAdded:Connect(setup)
workspace.ChildAdded:Connect(expand_planehitbox)
