function log(str)

    print("[Shared] Interactions ==>", str)

end 

log("shared autorun executing")

// definition of the Interaction class
// Interacting are actions taken on an entity

Interaction = {}
Interaction.interactions = {}
Interaction.__index = Interaction

function Interaction:new(name, class, action, reverse_action)
	
    if(Interaction[name] == nil) then 
        table.insert(Interaction.interactions, name)
        local BasicInteraction = {
            // action[class](entity) will be invoked when an entity is interacted with
            actions = {},
            reverse_actions = {}
        }
        Interaction[name] = BasicInteraction
    end

    Interaction[name].actions[class] = action
    if(reverse_action ~= nil) then 
        Interaction[name].reverse_actions[class] = reverse_action
    end

end

function Interaction:IsValid(interaction, entity)
    local class = entity:GetClass()
    return Interaction[interaction].actions[class] ~= nil
end

function Interaction:IsReverseValid(interaction, entity)
    local class = entity:GetClass()
    return Interaction[interaction].reverse_actions[class] ~= nil
end


function Interaction:ValidClasses(interaction)
    local class_tab = {}
    for class, f in pairs(Interaction[interaction].actions) do
        table.insert(class_tab, class)
    end
    return class_tab
end

setmetatable( Interaction, {__call = Interaction.new } )




// toggle door - open and clase door

Interaction("Toggle door", "func_door", function (entity)
    
    entity:Fire("toggle")
    
end)

Interaction("Toggle door", "prop_door_rotating", function (entity)
    
    entity:Fire("toggle")
    
end)

// press button -- press a button

Interaction("Press button", "func_button", function (entity)
    
    entity:Fire("press")
    
end)

Interaction("Press button", "func_rot_button", function (entity)
    
    entity:Fire("press")
    
end)

// Hide and unhide props

Interaction("Hide", "prop_dynamic", function (entity)
    
    entity:Fire("turnoff")
    
end, function (entity)
    
    entity:Fire("turnon")
    
end)
