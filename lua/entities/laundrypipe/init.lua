AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

function ENT:SpawnFunction(ply, tr, cn)
  local ang = ply:GetAngles()
  local ent = ents.Create(cn)
  ent:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,20))
  ent:SetAngles(Angle(0, ang.y, 0) - Angle(270, 270, 0))
  ent:Spawn()

  return ent
end

function ENT:Initialize()
	self:SetModel("models/props_pipes/pipe03_90degree01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
 
  local phys = self:GetPhysicsObject()
  if IsValid(phys) then
      phys:EnableMotion(false)
  end
end

function ENT:MakeLaundry(stage, color)
	self:EmitSound("buttons/lever5.wav")
	timer.Simple(1, function()
		local pos = self:LocalToWorld(self:OBBCenter())
		local ang = self:GetAngles()

		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)

		local cloth = ents.Create("laundryitem_dirty")
		if not cloth:IsValid() then return end
		cloth:SetPos(pos + (ang:Up() * 25))
		cloth:SetAngles(self:GetAngles())
		cloth:SetStage(stage)
		if color then
			cloth:SetColor(color)
		end
		cloth:Spawn()  
    end)
end

function ENT:Use(act, caller)
	if self.PipeUse and self.PipeUse > CurTime() then
		return
	end
	self.PipeUse = CurTime() + 1.2
	if SimpleLaundryTeam(caller) then return end
	self:MakeLaundry(0, Color(127, 95, 0))
end