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


// utility functions

local function fire_noarg(input_)
    return function (entity)
        entity:Fire(input_)
    end 
end 


// toggle door - open and clase door

Interaction("Toggle door", "func_door", fire_noarg("toggle"))

Interaction("Toggle door", "prop_door_rotating", fire_noarg("toggle"))

Interaction("Toggle door", "func_door_rotating", fire_noarg("toggle"))


// press button -- press a button

Interaction("Press button", "func_button", fire_noarg("press"))

Interaction("Press button", "func_rot_button", fire_noarg("press"))

// Hide and unhide props

Interaction("Hide/Unhide props", "prop_dynamic", 
            fire_noarg("turnoff"), fire_noarg("turnon"))