local buttons = {}

local function registerButton(resourcePrefix, point, w, h, callback, tooltip, badge)
    local button = Hyperspace.Button()
    button:OnInit(resourcePrefix, point)
    button.hitbox.x = button.position.x
    button.hitbox.y = button.position.y
    button.hitbox.w = w
    button.hitbox.h = h
    table.insert(buttons, {
        internal = button,
        callback = callback,
        tooltip = tooltip,
        badge = badge
    })
end

local function isHovering(hitbox, mousePos)
    return hitbox.x <= mousePos.x and mousePos.x < hitbox.x + hitbox.w and
        hitbox.y <= mousePos.y and mousePos.y < hitbox.y + hitbox.h
end

local function render_hud_elements()
    local mousePos = Hyperspace.Mouse.position

    -- Render buttons on HUD
    for _, button in pairs(buttons) do
        local oldHover = button.internal.bHover
        button.internal.bHover = isHovering(button.internal.hitbox, mousePos)
        if button.internal.bHover then
            Hyperspace.Mouse:SetTooltip(button.tooltip)
        end
        if oldHover == false and button.internal.bHover == true then
            Hyperspace.Sounds:PlaySoundMix("hoverBeep", -1, false)
        end
        button.internal:OnRender()
        if button.badge ~= nil and button.badge.value > 0 then
            local color = "354B59"
            if button.badge.color ~= nil then color = button.badge.color end

            Graphics.freetype.easy_printRightAlign(13, button.internal.position.x + button.internal.hitbox.w - 12,
                button.internal.position.y + button.internal.hitbox.h - 26,
                "[style[color:" .. color .. "]]" .. button.badge.value .. "[[/style]]")
        end
    end
end

local function render_top_elements()
    local mousePos = Hyperspace.Mouse.position

    -- Debug display in top right corner
    if mods.FTLAP.debug.debugDisplay then
        local baseX = 1271
        local baseY = 16
        info = {
            "Mouse position: " .. mousePos.x .. ", " .. mousePos.y,
            "Current sector: " .. Hyperspace.App.world.starMap.currentSector.level,
            "Current location: " .. Hyperspace.App.world.starMap.currentLoc.loc.x .. ", " ..
            Hyperspace.App.world.starMap.currentLoc.loc.y,
        }
        if Hyperspace.App.world.starMap.potentialLoc ~= nil then
            table.insert(info, "Potential location: " .. Hyperspace.App.world.starMap.potentialLoc.loc.x .. ", " ..
                Hyperspace.App.world.starMap.potentialLoc.loc.y)
        end

        if Hyperspace.App.world.starMap.hoverLoc ~= nil then
            table.insert(info, "Hover location: " .. Hyperspace.App.world.starMap.hoverLoc.loc.x .. ", " ..
                Hyperspace.App.world.starMap.hoverLoc.loc.y)
        end

        for i, line in ipairs(info) do
            Graphics.freetype.easy_printRightAlign(10, baseX, baseY + (i - 1) * 14, line)
        end
    end
end

local function on_ui_click(x, y)
    for _, button in pairs(buttons) do
        if button.internal.bHover then
            button.callback()
        end
    end
end


local BASE_BUTTON_W = 55
local BASE_BUTTON_H = 55
registerButton("statusUI/ftlap_storage", Hyperspace.Point(1206, 601), BASE_BUTTON_W, BASE_BUTTON_H,
    function() end,
    "Open a menu to view and accept received items from Archipelago.", {
        value = 15
    })

-- Debug button
registerButton("statusUI/ftlap_debug", Hyperspace.Point(1206, 601 - BASE_BUTTON_H), BASE_BUTTON_W, BASE_BUTTON_H,
    mods.FTLAP.debug.openDebugMenu,
    "Archipelago Debug Menu", nil)


script.on_render_event(Defines.RenderEvents.FTL_BUTTON, function() end, render_hud_elements)
script.on_render_event(Defines.RenderEvents.GUI_CONTAINER, function() end, render_top_elements)
script.on_internal_event(Defines.InternalEvents.ON_MOUSE_L_BUTTON_DOWN, on_ui_click)
