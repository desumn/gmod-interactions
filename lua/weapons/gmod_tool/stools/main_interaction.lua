TOOL.Category = "Interactions"
TOOL.Name = "Interactions"
TOOL.Command = nil 
TOOL.ConfigName = ""
TOOL.ClientConVar["interaction"] = ""
TOOL.ClientConVar["propagation"] = "false"

if CLIENT then 

    TOOL.Information = {
        {name = "info", stage = 1},
        { name = "left" },
        { name = "right"},
        { name = "reload" }
    }


    language.Add("tool.main_interaction.name", "Interactions")
    language.Add("tool.main_interaction.desc", "Interact with an entity")
    language.Add("tool.main_interaction.1", "Let you interact with entities.")

    language.Add("tool.main_interaction.left", "Interact with the entity you're looking at.")
    language.Add("tool.main_interaction.right", "Reverse the interaction you've done with the entity you're looking at.")
    language.Add("tool.main_interaction.reload", "Print the class of the entity you're looking at in chat.")

end


if CLIENT then

concommand.Add("set_interaction", function( ply, cmd, args, str )
    local cv = GetConVar("main_interaction_interaction")
    cv:SetString(args[1])
end)

concommand.Add("set_propagation", function( ply, cmd, args, str )
    local cv = GetConVar("main_interaction_propagation")
    cv:SetBool(args[1])
end)

end

function TOOL.BuildCPanel(CPanel)

    CPanel:Help("An interaction might act on multiple class of entities.")

    // list of interaction

    local interaction_list = vgui.Create("DListView")

    interaction_list:SetSize(CPanel:GetWide(), 128)

    interaction_list:AddColumn("Interaction")
    interaction_list:SetMultiSelect(false)

    for k, interaction in ipairs(Interaction.interactions) do
        interaction_list:AddLine(interaction)
    end

    CPanel:AddItem(interaction_list)

    function interaction_list:OnRowSelected(rowIndex, line)
        local interaction = line:GetValue(1)
        RunConsoleCommand("set_interaction", interaction)
    end
    
    CPanel:CheckBox("Propagate", "main_interaction_propagation")
    CPanel:ControlHelp("If propagate is checked, the select interaction will by applied to the first valid parent of the interacted entity.")

end


function TOOL:LeftClick(trace)
    local entity = trace.Entity
    local class = entity:GetClass()
    local interaction = self:GetClientInfo("interaction")
    local propagation = self:GetClientBool("propagation")

    if(propagation) then 
        while(IsValid(entity) and (not Interaction:IsValid(interaction, entity))) do
            entity = entity:GetParent()
        end 
    end

    if(IsValid(entity)) then 
        class = entity:GetClass()
        if(Interaction:IsValid(interaction, entity)) then 
            Interaction[interaction].actions[class](entity)
        end
    end

end 

function TOOL:RightClick(trace)
    local entity = trace.Entity
    local class = entity:GetClass()
    local interaction = self:GetClientInfo("interaction")
    local propagation = self:GetClientBool("propagation")

    if(propagation) then 
        while(IsValid(entity) and (not Interaction:IsReverseValid(interaction, entity))) do
            entity = entity:GetParent()
        end 
    end

    if(IsValid(entity)) then 
        class = entity:GetClass()
        if(Interaction:IsReverseValid(interaction, entity)) then 
            Interaction[interaction].reverse_actions[class](entity)
        end
    end
end 


function TOOL:PrintInfos(ply, entity)
    local interaction = self:GetClientInfo("interaction")
    if(IsValid(entity)) then 
        ply:ChatPrint("You're looking at a " .. entity:GetClass())    
    end 
    
    local info_str = "You may interact with: "
    if(interaction ~= "") then 
        for key, class in ipairs(Interaction:ValidClasses(interaction)) do
            info_str = info_str .. class .. " " 
        end
        ply:ChatPrint(info_str)
    end 
end

function TOOL:Reload(trace)
    local entity = trace.Entity
    if CLIENT then 
        self:PrintInfos(LocalPlayer, entity)
    elseif game.SinglePlayer() then 
        self:PrintInfos(Entity(1), entity)
    end
end