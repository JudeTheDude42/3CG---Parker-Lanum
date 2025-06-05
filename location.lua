
require "vector"
require "card"
require "player"

LocationClass = {}

function LocationClass:new(x, y, owner)
  local location = {}
  local metadata = {__index = LocationClass}
  setmetatable(location, metadata)
  
  location.center = Vector(x, y)
  location.cards = {}
  location.owner = owner
  
  return location
end

--Check if a point is inside this location (oval hitbox)
function LocationClass:isPointInside(x, y)
  local dx = (x - self.center.x) / 210
  local dy = (y - self.center.y) / 50
  return math.sqrt(dx * dx + dy * dy) < 1
end

--Add a card and position it visually
function LocationClass:addCard(card)
  table.insert(self.cards, card)

  local spacing = 104
  local index = #self.cards

  card.position.x = self.center.x - 1.5 * spacing + (index - 1) * spacing - 50
  card.position.y = self.center.y - 70
end

--Remove a card from this location
function LocationClass:removeCard(card)
  for i, c in ipairs(self.cards) do
    if c == card then
      table.remove(self.cards, i)
      break
    end
  end
end