function log(str)

    print("[Shared] Interactions ==>", str)

end 

log("shared autorun executing")

// definition of the Interaction class
// Interacting are actions taken on an entity

Interaction = {}
Interaction.valid_classes = {}
Interaction.__index = Interaction

function Interaction:new(name, class, action)
	local BasicInteraction = {
        // action(entity) will be invoked when an entity is interacted with
        action = action or (function (entity)

        end)
	}

    if(Interaction[class] == nil) then 
        table.insert(Interaction.valid_classes, class)
        Interaction[class] = {}
        Interaction[class][name] = BasicInteraction
    else 
        Interaction[class][name] = BasicInteraction
    end

	setmetatable(BasicInteraction, Interaction)
end

setmetatable( Interaction, {__call = Interaction.new } )

Interaction("Toggle door", "func_door", function (entity)
    
    entity:Fire("toggle")
    
end)

Interaction("Press button", "func_button", function (entity)
    
    entity:Fire("press")
    
end)