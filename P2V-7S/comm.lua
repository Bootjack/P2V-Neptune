io = data.base.io
table = data.base.table
tostring = data.base.tostring
type = data.base.type
getmetatable = data.base.getmetatable

local menus = data.menus

data.rootItem = {
    name = _('Main'),
    getSubmenu = function(self)
        local tbl = {
            name = _('Main'),
            items = {}
        }

        if data.pUnit == nil or data.pUnit:isExist() == false then
            return tbl
        end

        if self.builders ~= nil then
            for index, builder in pairs(self.builders) do
                builder(self, tbl)
            end
        end

        if #data.menuOther.submenu.items > 0 then
            tbl.items[10] = {
                name = _('Other'),
                submenu = data.menuOther.submenu
            }
        end

        return tbl
    end,
    builders = {}
}

local parameters = {
    fighter = false,
    radar = false,
    ECM = false,
    refueling = false
}

local menus = data.menus

utils.verifyChunk(utils.loadfileIn('Scripts/UI/RadioCommandDialogPanel/Config/Common/ATC.lua', getfenv()))(5, {[Airbase.Category.AIRDROME] = true})
utils.verifyChunk(utils.loadfileIn('Scripts/UI/RadioCommandDialogPanel/Config/Common/AWACS.lua', getfenv()))(7, {tanker = false, radar = false})
utils.verifyChunk(utils.loadfileIn('Scripts/UI/RadioCommandDialogPanel/Config/Common/Ground Crew.lua', getfenv()))(8)

menus['Ground Crew'].items[4] = { name = _('Wheel chocks'), submenu = {
    name = _('Wheel chocks'),
    items = {
        [1] = {
            name = _('Place_'),
            command = sendMessage.new(Message.wMsgLeaderGroundToggleWheelChocks, true)
        },
        [2] = {
            name = _('Remove_'),
            command = sendMessage.new(Message.wMsgLeaderGroundToggleWheelChocks, false)
        }
    }
}}
