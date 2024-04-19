local _, rm = ...
local L = rm.L

function rm.removeSpaces(string)
    if string then
        return string:gsub("%s+", "")
    end
end

local function isCapitalized(string)
    return string:sub(1, 1):upper() == string:sub(1, 1)
end

local function capitalizeName(string)
    if not isCapitalized(string) then
        return string:gsub("^%l", string.upper)
    end
end

function rm.removeRecipePrefix(recipeName, capitalize)
    for _, prefix in pairs(L.recipePrefixes) do
        if recipeName:sub(1, #prefix) == prefix then
            local strippedName = recipeName:sub(#prefix + 1)
            if capitalize then
                return capitalizeName(strippedName) or strippedName
            end
            return strippedName
        end
    end
    return recipeName
end

function rm.getIDFromLink(link)
    local strippedLink = select(2, strsplit(":", link))
    local ID = tonumber(string.match(strippedLink, "%d+")) -- Extracts only numerical part
    return ID
end
