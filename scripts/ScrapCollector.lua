local component = require("component")
local event = require("event")
local bot = require("robot")
local sides = require("sides")
local inv = component.inventory_controller

local MAX_BOXES_PER_TIME = 20

local function findFreeSlot(side)
   local i = 1

   while i <= inv.getInventorySize(side) do
      local item = inv.getStackInSlot(side, i)
      if not item then
         return i
      end
      i = i + 1
   end

   return 0
end

local function findScrapboxSlot(side)

   local i = 1

   while i <= inv.getInventorySize(side) do
      local item = inv.getStackInSlot(side, i)
      if item then
         local name = item.name
         if name == "industrialupgrade:doublescrapbox" then
            return i
         end
      end
      i = i + 1
   end

   return 0
end

local function storeResults(maxSize)
   local i = 1;

   while i <= maxSize do
      local item = inv.getStackInInternalSlot(i)
      if item then

         bot.select(i)

         local freeSlot = findFreeSlot(sides.front)

         if freeSlot == 0 then
            print("No free slots aviable!")
            return
         else
            inv.dropIntoSlot(sides.front, freeSlot)
         end

      end
      i = i + 1
   end
end

local function handleUse(scrapSlot)
   inv.suckFromSlot(sides.bottom, scrapSlot, MAX_BOXES_PER_TIME)

   inv.equip()

   local i = 1
   while i <= MAX_BOXES_PER_TIME do
      bot.use(sides.front, true)
      i = i + 1
   end

   storeResults(bot.inventorySize())
end

local function check()
   bot.select(1)

   local scrapSlot = findScrapboxSlot(sides.bottom)
   if scrapSlot == 0 then
      print("Scapboxes not found!")
   else
      handleUse(scrapSlot)
   end

end

local function init()
   storeResults(bot.inventorySize())
   while true do
      check()
   end
end

init()
