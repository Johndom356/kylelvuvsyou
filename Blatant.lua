local Angle = 0
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")
local MainEvent = game:GetService("ReplicatedStorage").MainEvent
local Visualizer = {Instance.new("Part",workspace),{
  Anchored = true,
  CanCollide = false,
  Material = Enum.Material.ForceField,
  Transparency = 1,
  Size = Vector3.new(1,1,1),
  Color = Color3.fromRGB(255,0,0)
},Instance.new("Part",workspace),{
  Anchored = true,
  CanCollide = false,
  Material = Enum.Material.ForceField,
  Transparency = 0,
  Size = Vector3.new(0.25,0.25,0),
  Color = Color3.fromRGB(255,0,0)
}}
for Index,Value in pairs(Visualizer[2]) do
  Visualizer[1][Index] = Value
end
for Index,Value in pairs(Visualizer[4]) do
  Visualizer[3][Index] = Value
end
RunService.PostSimulation:Connect(function(DeltaTime)
  if Configuration[4][2][1] == true then
    for Index,Value in pairs(Players:GetPlayers()) do
      if Value ~= LocalPlayer then
        if Configuration[4][2][2][Value.UserId] == nil then
          local Character = Value.Character
          if Character then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if HumanoidRootPart then
              Configuration[4][2][2][Value.UserId] = {
                HumanoidRootPart.AssemblyLinearVelocity,
                HumanoidRootPart.Position
              }
            else
              Configuration[4][2][2][Value.UserId] = {
                Vector3.new(0,0,0),
                Vector3.new(0,0,0)
              }
            end
          else
            Configuration[4][2][2][Value.UserId] = {
              Vector3.new(0,0,0),
              Vector3.new(0,0,0)
            }
          end
        else
          local Character = Value.Character
          if Character then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if HumanoidRootPart then
              local Position = {
                HumanoidRootPart.Position,
                Configuration[4][2][2][Value.UserId][2]
              }
              local AssemblyLinearVelocity = (Position[1]-Position[2])/DeltaTime
              Configuration[4][2][2][Value.UserId][2] = Position[1]
              Configuration[4][2][2][Value.UserId][1] = Configuration[4][2][2][Value.UserId][1]*(1-math.clamp(AssemblyLinearVelocity.Magnitude/187,0.01,0.99))+((Position[1]-Position[2])/DeltaTime)*math.clamp(AssemblyLinearVelocity.Magnitude/187,0.01,0.99)
            end
          end
        end
      end
    end
    if Configuration[4][1] ~= nil then
      local Character = Configuration[4][1].Character
      if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart then
          local LocalCharacter = LocalPlayer.Character
          if LocalCharacter then
            local LocalHumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
            if LocalHumanoidRootPart then
              local AssemblyLinearVelocity = Configuration[4][2][2][Configuration[4][1].UserId][1]
              local Configuration__AssemblyLinearVelocity = {
                
              }
              local Magnitude = (HumanoidRootPart.Position-LocalHumanoidRootPart.Position).Magnitude
              local Nearest = {
                
              }
              for Index,Value in pairs(Configuration[1]) do
                local Difference = math.abs(Index-Magnitude)
                if Nearest[2] == nil then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                elseif Index < Nearest[2] then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                end
              end
              Configuration__AssemblyLinearVelocity[1] = Nearest[1]
              Nearest = {}
              for Index,Value in pairs(Configuration[2]) do
                local Difference = math.abs(Index-Magnitude)
                if Nearest[2] == nil then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                elseif Index < Nearest[2] then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                end
              end
              Configuration__AssemblyLinearVelocity[2] = Nearest[1]
              Nearest = {}
              for Index,Value in pairs(Configuration[3]) do
                local Difference = math.abs(Index-Magnitude)
                if Nearest[2] == nil then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                elseif Index < Nearest[2] then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                end
              end
              Configuration__AssemblyLinearVelocity[3] = Nearest[1]
              local Position = HumanoidRootPart.Position
              local MousePos = Vector3.new(Position.X+(AssemblyLinearVelocity.X*Configuration__AssemblyLinearVelocity[1]),Position.Y+(AssemblyLinearVelocity.Y*Configuration__AssemblyLinearVelocity[2]),Position.Z+(AssemblyLinearVelocity.Z*Configuration__AssemblyLinearVelocity[3]))
              local OverlapParameters = OverlapParams.new()
              local Excluded = {Visualizer[1],Visualizer[3]}
              for Index,Value in pairs(Players:GetPlayers()) do
                local Character = Value.Character
                if Character then
                  table.insert(Excluded,Character)
                end
              end
              OverlapParameters:AddToFilter(Excluded)
              local GetPartBoundsInBox = workspace:GetPartBoundsInBox(CFrame.new(MousePos),HumanoidRootPart.Size,OverlapParameters)
              if Configuration[5][1] == true then
                if table.getn(GetPartBoundsInBox) == 0 then
                  MainEvent:FireServer("UpdateMousePos",{
                    MousePos = MousePos,
                    Camera = MousePos
                  })
                  if Configuration[4][4] == true then
                    Angle = Angle+Configuration[5][3][1]*DeltaTime/Configuration[5][3][2]
                    LocalHumanoidRootPart.CFrame = CFrame.new(MousePos+Vector3.new(math.sin(Angle)*Configuration[5][3][2],Configuration[5][3][3],math.cos(Angle)*Configuration[5][3][2]),MousePos)
                  end
                  Visualizer[1].CFrame = CFrame.new(MousePos,MousePos+HumanoidRootPart.CFrame.LookVector)
                  Visualizer[1].Size = HumanoidRootPart.Size
                  if Configuration[4][3] == true then
                    local CurrentCamera = workspace.CurrentCamera
                    local DeltaTime = RunService.PreRender:Wait()
                    CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.lookAt(CurrentCamera.CFrame.Position,Position),Configuration[5][4]*DeltaTime)
                  end
                else
                  MousePos = Vector3.new(MousePos.X,Position.Y,MousePos.Z)
                  MainEvent:FireServer("UpdateMousePos",{
                    MousePos = MousePos,
                    Camera = MousePos
                  })
                  if Configuration[4][4] == true then
                    Angle = Angle+Configuration[5][3][1]*DeltaTime/Configuration[5][3][2]
                    LocalHumanoidRootPart.CFrame = CFrame.new(MousePos+Vector3.new(math.sin(Angle)*Configuration[5][3][2],Configuration[5][3][3],math.cos(Angle)*Configuration[5][3][2]),MousePos)
                  end
                  Visualizer[1].CFrame = CFrame.new(MousePos,MousePos+HumanoidRootPart.CFrame.LookVector)
                  Visualizer[1].Size = HumanoidRootPart.Size
                  if Configuration[4][3] == true then
                    local CurrentCamera = workspace.CurrentCamera
                    local DeltaTime = RunService.PreRender:Wait()
                    CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.lookAt(CurrentCamera.CFrame.Position,Position),Configuration[5][4]*DeltaTime)
                  end
                end
              else
                MainEvent:FireServer("UpdateMousePos",{
                  MousePos = MousePos,
                  Camera = MousePos
                })
                if Configuration[4][4] == true then
                  Angle = Angle+Configuration[5][3][1]*DeltaTime/Configuration[5][3][2]
                  LocalHumanoidRootPart.CFrame = CFrame.new(MousePos+Vector3.new(math.sin(Angle)*Configuration[5][3][2],Configuration[5][3][3],math.cos(Angle)*Configuration[5][3][2]),MousePos)
                end
                Visualizer[1].CFrame = CFrame.new(MousePos,MousePos+HumanoidRootPart.CFrame.LookVector)
                Visualizer[1].Size = HumanoidRootPart.Size
                if Configuration[4][3] == true then
                  local CurrentCamera = workspace.CurrentCamera
                  local DeltaTime = RunService.PreRender:Wait()
                  CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.lookAt(CurrentCamera.CFrame.Position,Position),Configuration[5][4]*DeltaTime)
                end
              end
            end
          end
        end
      end
    end
  else
    if Configuration[4][1] ~= nil then
      local Character = Configuration[4][1].Character
      if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart then
          local LocalCharacter = LocalPlayer.Character
          if LocalCharacter then
            local LocalHumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
            if LocalHumanoidRootPart then
              local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
              local Configuration__AssemblyLinearVelocity = {
                
              }
              local Magnitude = (HumanoidRootPart.Position-LocalHumanoidRootPart.Position).Magnitude
              local Nearest = {
                
              }
              for Index,Value in pairs(Configuration[1]) do
                local Difference = math.abs(Index-Magnitude)
                if Nearest[2] == nil then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                elseif Index < Nearest[2] then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                end
              end
              Configuration__AssemblyLinearVelocity[1] = Nearest[1]
              Nearest = {}
              for Index,Value in pairs(Configuration[2]) do
                local Difference = math.abs(Index-Magnitude)
                if Nearest[2] == nil then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                elseif Index < Nearest[2] then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                end
              end
              Configuration__AssemblyLinearVelocity[2] = Nearest[1]
              Nearest = {}
              for Index,Value in pairs(Configuration[3]) do
                local Difference = math.abs(Index-Magnitude)
                if Nearest[2] == nil then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                elseif Index < Nearest[2] then
                  Nearest[1] = Value
                  Nearest[2] = Difference
                end
              end
              Configuration__AssemblyLinearVelocity[3] = Nearest[1]
              local Position = HumanoidRootPart.Position
              local MousePos = Vector3.new(Position.X+(AssemblyLinearVelocity.X*Configuration__AssemblyLinearVelocity[1]),Position.Y+(AssemblyLinearVelocity.Y*Configuration__AssemblyLinearVelocity[2]),Position.Z+(AssemblyLinearVelocity.Z*Configuration__AssemblyLinearVelocity[3]))
              local OverlapParameters = OverlapParams.new()
              local Excluded = {Visualizer[1],Visualizer[3]}
              for Index,Value in pairs(Players:GetPlayers()) do
                local Character = Value.Character
                if Character then
                  table.insert(Excluded,Character)
                end
              end
              OverlapParameters:AddToFilter(Excluded)
              local GetPartBoundsInBox = workspace:GetPartBoundsInBox(CFrame.new(MousePos),HumanoidRootPart.Size,OverlapParameters)
              if Configuration[5][1] == true then
                if table.getn(GetPartBoundsInBox) == 0 then
                  MainEvent:FireServer("UpdateMousePos",{
                    MousePos = MousePos,
                    Camera = MousePos
                  })
                  if Configuration[4][4] == true then
                    Angle = Angle+Configuration[5][3][1]*DeltaTime/Configuration[5][3][2]
                    LocalHumanoidRootPart.CFrame = CFrame.new(MousePos+Vector3.new(math.sin(Angle)*Configuration[5][3][2],Configuration[5][3][3],math.cos(Angle)*Configuration[5][3][2]),MousePos)
                  end
                  Visualizer[1].CFrame = CFrame.new(MousePos,MousePos+HumanoidRootPart.CFrame.LookVector)
                  Visualizer[1].Size = HumanoidRootPart.Size
                  if Configuration[4][3] == true then
                    local CurrentCamera = workspace.CurrentCamera
                    local DeltaTime = RunService.PreRender:Wait()
                    CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.lookAt(CurrentCamera.CFrame.Position,MousePos),Configuration[5][4]*DeltaTime)
                  end
                else
                  MousePos = Vector3.new(MousePos.X,Position.Y,MousePos.Z)
                  MainEvent:FireServer("UpdateMousePos",{
                    MousePos = MousePos,
                    Camera = MousePos
                  })
                  if Configuration[4][4] == true then
                    Angle = Angle+Configuration[5][3][1]*DeltaTime/Configuration[5][3][2]
                    LocalHumanoidRootPart.CFrame = CFrame.new(MousePos+Vector3.new(math.sin(Angle)*Configuration[5][3][2],Configuration[5][3][3],math.cos(Angle)*Configuration[5][3][2]),MousePos)
                  end
                  Visualizer[1].CFrame = CFrame.new(MousePos,MousePos+HumanoidRootPart.CFrame.LookVector)
                  Visualizer[1].Size = HumanoidRootPart.Size
                  if Configuration[4][3] == true then
                    local CurrentCamera = workspace.CurrentCamera
                    local DeltaTime = RunService.PreRender:Wait()
                    CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.lookAt(CurrentCamera.CFrame.Position,MousePos),Configuration[5][4]*DeltaTime)
                  end
                end
              else
                MainEvent:FireServer("UpdateMousePos",{
                  MousePos = MousePos,
                  Camera = MousePos
                })
                if Configuration[4][4] == true then
                  Angle = Angle+Configuration[5][3][1]*DeltaTime/Configuration[5][3][2]
                  LocalHumanoidRootPart.CFrame = CFrame.new(MousePos+Vector3.new(math.sin(Angle)*Configuration[5][3][2],Configuration[5][3][3],math.cos(Angle)*Configuration[5][3][2]),MousePos)
                end
                Visualizer[1].CFrame = CFrame.new(MousePos,MousePos+HumanoidRootPart.CFrame.LookVector)
                Visualizer[1].Size = HumanoidRootPart.Size
                if Configuration[4][3] == true then
                  local CurrentCamera = workspace.CurrentCamera
                  local DeltaTime = RunService.PreRender:Wait()
                  CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.lookAt(CurrentCamera.CFrame.Position,MousePos),Configuration[5][4]*DeltaTime)
                end
              end
            end
          end
        end
      end
    end
  end
  if Configuration[4][5] == true then
    local Character = LocalPlayer.Character
    if Character then
      local Head = Character:FindFirstChild("Head")
      if Head then
        local BodyEffects = Character:FindFirstChild("BodyEffects")
        if BodyEffects then
          local MousePos = BodyEffects:FindFirstChild("MousePos")
          if MousePos then
            MousePos = MousePos.Value
            Visualizer[3].Size = Vector3.new(0.25,0.25,(Head.Position-MousePos).Magnitude)
            Visualizer[3].CFrame = CFrame.new(Head.Position,MousePos)*CFrame.new(0,0,-(Head.Position-MousePos).Magnitude/2)
            if Configuration[4][1] ~= nil then
              Character = Configuration[4][1].Character
              if Character then
                HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                  local OverlapParameters = OverlapParams.new()
                  OverlapParameters:AddToFilter({
                    Visualizer[1],
                    Visualizer[3]
                  })
                  local GetPartBoundsInBox = workspace:GetPartBoundsInBox(CFrame.new(MousePos),HumanoidRootPart.Size,OverlapParameters)
                  if #GetPartBoundsInBox >= 1 then
                    for Index,Value in pairs(GetPartBoundsInBox) do
                      if Value == HumanoidRootPart then
                        Visualizer[3].Color = Color3.fromRGB(0,255,0)
                        break
                      else
                        Visualizer[3].Color = Color3.fromRGB(255,0,0)
                      end
                    end
                  else
                    Visualizer[3].Color = Color3.fromRGB(255,0,0)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if Configuration[5][2] == true then
    local Character = LocalPlayer.Character
    if Character then
      for Index,Value in pairs(Character:GetChildren()) do
        if Value:IsA("Tool") then
          local Ammo = Value:FindFirstChild("Ammo")
          local MaxAmmo = Value:FindFirstChild("MaxAmmo")
          if Ammo and MaxAmmo then
            Ammo = Ammo.Value
            if Ammo == 0 then
              MainEvent:FireServer("Reload",Value)
            end
          end
        end
      end
    end
  end
  if Configuration[4][6] == true then
    local Character = LocalPlayer.Character
    if Character then
      local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
      if HumanoidRootPart then
        local Recorded = HumanoidRootPart.AssemblyLinearVelocity
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(1,1,1)*(2^14)
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame*CFrame.Angles(0,0.0001,0)
        RunService.PreRender:Wait()
        HumanoidRootPart.AssemblyLinearVelocity = Recorded
      end
    end
  end
end)
local Tools = {{Instance.new("Tool",LocalPlayer.Backpack),{
  RequiresHandle = false,
  Name = "Blatant (1)"
}},{Instance.new("Tool",LocalPlayer.Backpack),{
  RequiresHandle = false,
  Name = "Blatant (2)"
}},{Instance.new("Tool",LocalPlayer.Backpack),{
  RequiresHandle = false,
  Name = "Blatant (3)"
}},{Instance.new("Tool",LocalPlayer.Backpack),{
  RequiresHandle = false,
  Name = "Blatant (4)"
}},{Instance.new("Tool",LocalPlayer.Backpack),{
  RequiresHandle = false,
  Name = "Blatant (5)"
}},{Instance.new("Tool",LocalPlayer.Backpack),{
  RequiresHandle = false,
  Name = "Blatant (6)"
}}}
LocalPlayer.CharacterRemoving:Connect(function()
  for Index,Value in pairs(Tools) do
    Value[1].Parent = LocalPlayer.Backpack
  end
end)
for Index,Value1 in pairs(Tools) do
  for Index,Value2 in pairs(Value1[2]) do
    Value1[1][Index] = Value2
  end
end
Tools[1][1].Activated:Connect(function()
  if Configuration[4][1] == nil then
    local Position = Mouse.Hit.Position
    local Nearest = {
      {}
    }
    for Index,Value in pairs(Players:GetPlayers()) do
      if Value ~= LocalPlayer then
        local Character = Value.Character
        if Character then
          local HumanoidRootPart = Character:FindFirstCh