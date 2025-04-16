TOOL.Category = "Render"
TOOL.Name = "#tool.oneway.name"
TOOL.ClientConVar[ "channel" ] = 1

if CLIENT then
    language.Add("tool.oneway.name", "One Way")
    language.Add("tool.oneway.desc", "One Way material")
    language.Add("tool.oneway.0", "Left Click to apply one way.")
end

function TOOL:LeftClick(trace)
    if not IsValid(trace.Entity) then return false end
    if CLIENT then return true end

    local owner = self:GetOwner()
    local ent1 = trace.Entity

    -- Only allow the material to be applied to 'prop_physics' entities
    if ent1:GetClass() ~= "prop_physics" then return false end

    if IsValid(ent1.AttachedEntity) then ent1 = ent1.AttachedEntity end

    -- Apply transparent overlay material directly
    ent1:SetMaterial("vgui/screens/vgui_overlay")
    ent1:SetColor(Color(0, 0, 0, 1))
    ent1:SetRenderMode(RENDERMODE_TRANSALPHA)

    -- Trace forward to find second prop
    local startPos = trace.HitPos + trace.Normal * 1
    local endPos = startPos + trace.Normal * 100

    local filter = { owner, ent1 }
    local secondTrace = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = filter
    })

    if IsValid(secondTrace.Entity) then
        local ent2 = secondTrace.Entity

        -- Only apply the glow effect if the second entity is also a 'prop_physics'
        if ent2:GetClass() == "prop_physics" then
            if IsValid(ent2.AttachedEntity) then ent2 = ent2.AttachedEntity end

            -- Apply world glow effect to second prop
            ent2:SetColor(Color(255, 255, 255, 255))
            ent2:SetRenderMode(RENDERMODE_WORLDGLOW)
        end
    end

    return true
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header", { Description = "Double Stack your prop and Left Click the one you want to see through." })
end
