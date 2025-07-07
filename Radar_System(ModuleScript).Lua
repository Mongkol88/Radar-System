--This Script Can use in Roblox studio Only--
--place this ModuleScript in ServerScriptService
--you must require and call .New() function and call :Init function
--your must Set Tag in your Object if your not Set Tag there will not Working
local run = game:GetService("RunService")--Call RunService
local RayParms = RaycastParams.new()--call RaycastParms
RayParms.FilterType = Enum.RaycastFilterType.Include
local Target = {}--Collect Target
local Table1 = {}

--Utility
local function checkTable(tbl)
	local isEmpty = next(tbl) == nil


	if isEmpty then
		return nil
	else
		return tbl
	end
end

function removeDuplicateValues(dict)
	local seen = {}
	for k, v in pairs(dict) do
		if seen[v] then
			dict[k] = nil
		else
			seen[v] = true
		end
	end
end
--Utility


local System = {}
System.__index = System

function System.New(Model : Model)
	local self = setmetatable({}, System)
	self.Radar = Model
	return self
end


function System:Init()--
	self:FindTarget()
	self:Raycast()
end

function System:FindTarget()
	task.spawn(function()--create new thread
		local debounce = false --Debounce
		while task.wait() do
			local findlookvector = self.Radar.Rotation.CFrame.LookVector:Dot(Vector3.new(0, 0, -1))
			if findlookvector > 0.95 and debounce == false then
				if debounce == true then return end
				debounce = true
				local checktable = checkTable(Target)
				print(Target) --Debug Target
				if checktable then
                    --you can putt your code or function here to Run something if Radar was Detect something
				end
				table.clear(Target)
				task.delay(1, function()
					debounce = false
				end)
			end
		end
	end)
end

function System:Raycast()--Use Raycast to Detect Object in workspace
	for _, part in pairs(game:GetService("CollectionService"):GetTagged("Target")) do --Your Can change The name of tag here
		table.insert(Table1, part)
	end
	RayParms.FilterDescendantsInstances = Table1
	for _, Radar in pairs(game.Workspace.Radar1.Radar.Radar_Points:GetChildren()) do --set the raycast on RadarPoints
		if Radar then
			run.Stepped:Connect(function()
				local hitpos = Radar.CFrame.LookVector * 500
				local raycast = workspace:Raycast(Radar.Position, hitpos, RayParms)
				if raycast then
					hitpos = raycast.Position
				end
				if raycast then
					table.insert(Target, raycast.Instance)
					removeDuplicateValues(Target)
				end
				self:Debug(Radar, hitpos, raycast)
				task.wait()
			end)

		end
	end
end


function System:Debug(Part, hitPosition, raycast)--Debug the Raycast System
	if raycast then
		local part = Instance.new("Part", game.Workspace.Debug)
		part.Name = "Debug"
		part.Size = Vector3.new(0.1, 0.1, (hitPosition - Part.Position).Magnitude)
		part.CFrame = CFrame.new(Part.Position, hitPosition) * CFrame.new(0, 0, -part.Size.Z/2)
		part.Color = Color3.new(0, 1, 0) 
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.Material = Enum.Material.Neon
		game:GetService("Debris"):AddItem(part, 0.01)
	else
		
	end
end


return System