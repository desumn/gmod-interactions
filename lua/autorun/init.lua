function log(str)

    print("[Shared] Interactions ==>", str)

end 

log("shared autorun executing")

// definition of the Interaction class
// Interacting are actions taken on an entity

Interaction = {}
Interaction.interactions = {}
Interaction.__index = Interaction

function Interaction:new(name, class, action)
	
    if(Interaction[name] == nil) then 
        table.insert(Interaction.interactions, name)
        local BasicInteraction = {
            // action[class](entity) will be invoked when an entity is interacted with
            actions = {}
        }
        BasicInteraction.actions[class] = action    

        Interaction[name] = BasicInteraction
    else 
        Interaction[name].actions[class] = action
    end

end

function Interaction:IsValid(interaction, entity)
    local class = entity:GetClass()
    return Interaction[interaction].actions[class] ~= nil
end


setmetatable( Interaction, {__call = Interaction.new } )

Interaction("Toggle door", "func_door", function (entity)
    
    entity:Fire("toggle")
    
end)

Interaction("Toggle door", "prop_door_rotating", function (entity)
    
    entity:Fire("toggle")
    
end)



Interaction("Press button", "func_button", function (entity)
    
    entity:Fire("press")
    
end)