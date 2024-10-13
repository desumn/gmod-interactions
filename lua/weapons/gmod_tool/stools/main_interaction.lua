TOOL.Category = "Interactions"
TOOL.Name = "Interactions"
TOOL.Command = nil 
TOOL.ConfigName = ""
TOOL.ClientConVar["interaction_class"] = ""
TOOL.ClientConVar["interaction"] = ""
TOOL.ClientConVar["propagation"] = "false"

if CLIENT then 

    TOOL.Information = {
        {name = "info", stage = 1},
        { name = "left" },
        { name = "reload" }
    }


    language.Add("tool.main_interaction.name", "Interactions")
    language.Add("tool.main_interaction.desc", "Interact with an entity")
    language.Add("tool.main_interaction.1", "Let you interact with entities.")

    language.Add("tool.main_interaction.left", "Interact with the entity you're looking at.")
    language.Add("tool.main_interaction.reload", "Print the class of the entity you're looking at in chat.")

end


if CLIENT then

concommand.Add("set_interaction_class", function( ply, cmd, args, str )
    local cv = GetConVar("main_interaction_interaction_class")
    cv:SetString(args[1])
end)

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

    CPanel:Help("A certain class of entity might have a list of interaction.\n Selecting a class let you select an interaction.")

    // list of classes

    local class_list = vgui.Create("DListView")

    class_list:SetSize(CPanel:GetWide(), 128)

    class_list:AddColumn("Class")
    class_list:SetMultiSelect(false)

    for k, class in ipairs(Interaction.valid_classes) do
        class_list:AddLine(class)
    end

    CPanel:AddItem(class_list)

    // list of interactions, depends on the class selected in class_list

    local combo, label = CPanel:ComboBox("Interaction", "main_interaction_interaction")
    combo:AddChoice("Please select a class", "", true)

    // defined after combo, as it depends on it
    function class_list:OnRowSelected(rowIndex, line)
        local class = line:GetValue(1)
        line:SetValue(1, class)
        RunConsoleCommand("set_interaction_class", class)
        combo:Clear()
        for name, interaction in pairs(Interaction[class]) do
            combo:AddChoice(name, name)
        end
    end
    
    
    CPanel:CheckBox("Propagate", "main_interaction_propagation")
    CPanel:ControlHelp("If propagate is checked, the select interaction will by applied to the first valid parent of the interacted entity.")

end


function TOOL:LeftClick(trace)
    local entity = trace.Entity
    local class = self:GetClientInfo("interaction_class")
    local propagation = self:GetClientBool("propagation")

    if(propagation) then
        while (IsValid(entity) and entity:GetClass() ~= class) do
            entity = entity:GetParent()        
        end
    end 

    if(IsValid(entity) and entity:GetClass() == class) then 
        local interaction = self:GetClientInfo("interaction")
        if(interaction ~= "") then 
            Interaction[class][interaction].action(entity)
        end
    end

end 

function TOOL:Reload(trace)
    local entity = trace.Entity
    if(IsValid(entity)) then 
        if CLIENT then 
            LocalPlayer:ChatPrint("You're looking at a " .. entity:GetClass())
        elseif game.SinglePlayer() then 
            Entity(1):ChatPrint("You're looking at a " .. entity:GetClass())    
        end
    end 
end