
require "card"

PlayerClass = {}

function PlayerClass:new(name)
  local player = {}
  setmetatable(player, {__index = PlayerClass})

  player.name = name
  
  player.deck = {}
  player.hand = {}
  
  player.mana = 0
  player.points = 0
  
  player.stagedCards = {}
  
  return player
end

--Move a card from the deck into the hand
function PlayerClass:drawCard()
  if #self.hand >= 7 or #self.deck == 0 then return end --hand full or deck empty 
  local card = table.remove(self.deck, 1)
  card.location = CARD_LOCATION.HAND
  card.shown = false
  table.insert(self.hand, card)
  table.insert(cardTable, card)
end

--Arrange hand on screen
function PlayerClass:arrangeHand()
  for i, card in ipairs(self.hand) do
    card.position.x = 260 + (i - 1) * 110
    card.position.y = (self.name == "opponent") and 30 or 550
    card.shown = false
  end
end

--Submit all staged cards (flag them as submitted)
function PlayerClass:submitTurn()
  for _, card in ipairs(self.stagedCards) do
    card.submitted = true
  end
end

--Reset for a new turn
function PlayerClass:startTurn(turnNumber)
  self.mana = turnNumber
  self:drawCard()
  self:arrangeHand()
end