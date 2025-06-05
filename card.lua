
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  HOVER = 1,
  HELD = 2
}

CARD_LOCATION = {
  DECK = -1,
  HAND = 0,
  LOC1 = 1,
  LOC2 = 2,
  LOC3 = 3
}


function CardClass:new(xPos, yPos, power, cost, name, text, id, owner)
  local card = {}
  setmetatable(card, {__index = CardClass})

  --Position and Size
  card.position = Vector(xPos, yPos)
  card.originalPosition = Vector(xPos, yPos)
  card.size = Vector(100, 140)

  --State
  card.state = CARD_STATE.IDLE
  card.location = CARD_LOCATION.DECK

  --Stats
  card.power = power
  card.cost = cost
  card.name = name
  card.text = text
  card.owner = owner
  card.id = id

  --Gameplay State
  card.shown = false
  card.submitted = false
  card.alreadyRevealed = false

  return card
end

local grabby = false
function CardClass:update()
  --self.shown=true
  local mousePos = grabber.currMousePos
  
  if not self.shown and self.location == CARD_LOCATION.HAND and self.owner == "player" then 
    self.shown = true
  end
  
  --grab a card when clicked
  if self.state == CARD_STATE.HOVER and love.mouse.isDown(1) and grabby == false and self.location == CARD_LOCATION.HAND and self.shown and not turnManager.resolving then
    self.state = CARD_STATE.GRABBED
    grabby = true
    self.originalPosition = Vector(self.position.x, self.position.y)
  end
  
  --when grabbed move card with mouse
  if self.state == CARD_STATE.GRABBED and love.mouse.isDown(1) then
    self.position.x = mousePos.x - 50
    self.position.y = mousePos.y - 70
  end
  
  --when mouse is released drop card
  if self.state == CARD_STATE.GRABBED and not love.mouse.isDown(1) then
    local dropSuccess = false

    --Check if card was dropped near a valid location and player has enough mana
    for i, loc in ipairs(locations) do
      if loc.owner == "player" and loc:isPointInside(mousePos.x, mousePos.y) 
      and player.mana >= self.cost and #loc.cards < 4 then
        dropSuccess = true
        player.mana = player.mana - self.cost
        self.submitted = false

        --Remove from hand
        for h = #player.hand, 1, -1 do
          if player.hand[h] == self then
            table.remove(player.hand, h)
            break
          end
        end

        --Add to location and player's staged cards
        self.location = i
        loc:addCard(self)
        table.insert(player.stagedCards, self)
        break
      end
    end
    
    if not dropSuccess then
      --return to original position
      self.position = Vector(self.originalPosition.x, self.originalPosition.y)
    else
      for i, card in ipairs(player.hand) do
        if card == self then
          table.remove(player.hand, i)
          break
        end
      end
    end

    self.state = CARD_STATE.HOVER
    grabby = false
  end
  
end

local statsFont = love.graphics.newFont(10)
local nameFont = love.graphics.newFont(14)
local textFont = love.graphics.newFont(11)

local white = {1, 1, 1, 1}
local black = {0, 0, 0, 1}

function CardClass:draw()
  if self.shown then
    --print card background
    love.graphics.setColor(white)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  
    --print card power
    love.graphics.setColor(black)
    love.graphics.setFont(statsFont)
    love.graphics.printf(self.power .. " power", self.position.x+2, self.position.y+5, 50, "center")
    
    --print card cost
    love.graphics.printf(self.cost .. " mana", self.position.x+50, self.position.y+5, 50, "center")
    
     --print card text
    love.graphics.setFont(textFont)

    love.graphics.printf(self.text, self.position.x+2, self.position.y+50, 96, "left")
  
    --print card name
    love.graphics.setFont(nameFont)
    love.graphics.printf(self.name, self.position.x+2, self.position.y+20, 96, "center")
    
  else
    --draw the back of a card
    love.graphics.setColor(white)
    love.graphics.draw(backImage, self.position.x, self.position.y)
  end
end

function CardClass:checkHover(grabber)
  if self.state == CARD_STATE.GRABBED then
    return
  end
  
  local mousePos = grabber.currMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and mousePos.x < self.position.x+self.size.x and
    mousePos.y > self.position.y and mousePos.y < self.position.y+self.size.y
    
  self.state = isMouseOver and CARD_STATE.HOVER or CARD_STATE.IDLE

end