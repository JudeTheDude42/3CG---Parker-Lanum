-- Parker Lanum
-- CMPM 121 - 3CG
-- 5/28/25

io.stdout:setvbuf("no")

require "card"
require "grabber"

math.randomseed(os.time())

function love.load()
  love.window.setMode(1280,720)
  
  win = 0
  
  backImage = love.graphics.newImage("Sprites/back.png")
  backgroundImage = love.graphics.newImage("Sprites/background.png")
  
  --load sprites
  
  resetImage = love.graphics.newImage("Sprites/reset.png") 
        
  --temp
  cardTable = {}
        
  grabber = GrabberClass:new()
  
  --define constants 
  
  require "location"
  locations = {
    LocationClass:new(213, 440, "player"),
    LocationClass:new(640, 440, "player"),
    LocationClass:new(1067, 440, "player"),
    LocationClass:new(213, 280, "opponent"),
    LocationClass:new(640, 280, "opponent"),
    LocationClass:new(1067, 280, "opponent"),
  }
  
  require "player"

  player = PlayerClass:new("player")
  opponent = PlayerClass:new("opponent")
  
  require "deck"
  
  --Create Deck
  player.deck = buildDeck("player")
  opponent.deck = buildDeck("opponent")
  
  --Draw starting hands (3 cards each)
  for i = 1, 3 do
    player:drawCard()
    opponent:drawCard()
  end
  
  require "turnManager"
  
  turnManager = TurnManagerClass:new()
  
  turnManager:startGame()

end

function love.update(dt)
  grabber:update()
  
  checkForMouseMoving()
  
  turnManager:update(dt)
    
  --update backwards to give topmost cards priority
  for i = #cardTable, 1, -1 do
    local card = cardTable[i]
    card:update()
  end
  
  --check if the player has won
  if player.points >= 25  and opponent.points < 25 then
    win = 1
  elseif opponent.points >= 25  and player.points < 25 then
    win = -1
  elseif player.points >= 25  and opponent.points >= 25 then
    if player.points > opponent.points then 
      win = 1 
    elseif player.points < opponent.points then 
      win = -1
    end
  end
  
  
  for index, card in ipairs(cardTable) do
    --hovering the mouse over a card brings it to top via draw order
    if card.state == CARD_STATE.HOVER then
      table.remove(cardTable, index)
      table.insert(cardTable, card)
    end
  end
end

--when the player clicks the deck or reset button
function love.mousepressed(x, y, button)
  if turnManager.resolving then return end
  if button == 1 then -- left click
    if x >= submitButton.x and x <= submitButton.x + submitButton.width and
       y >= submitButton.y and y <= submitButton.y + submitButton.height then

      turnManager:playerSubmit()
    end
    if win ~= 0 then love.load() end
  end
end

function checkForMouseMoving()
  if grabber.currMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkHover(grabber)
  end
end


local rulesFont = love.graphics.newFont(20)
local winFont = love.graphics.newFont(160)

local white = {1, 1, 1, 1}
local green = {0, 0.55, 0, 1}
local red = {1, 0, 0, 1}

submitButton = {
  x = 1050,
  y = 640,
  width = 200,
  height = 60,
  text = "Submit",
  color = {0, 0.55, 0, 1}, -- green
}

function love.draw()
  love.graphics.setColor(white)
  love.graphics.setFont(rulesFont)
  
  --Draw Background
  love.graphics.draw(backgroundImage, 0, 0, 0, 1, 1)
  
  --Draw Turn Number
  love.graphics.print("Turn: " .. tostring(turnManager.turnNumber), 10, 10)

  --Draw Player Info
  love.graphics.print("Mana: " .. player.mana, 80, 600)
  love.graphics.print("Points: " .. player.points, 80, 630)

  --Draw Opponent Info
  love.graphics.print("Mana: " .. opponent.mana, 80, 60)
  love.graphics.print("Points: " .. opponent.points, 80, 90)
  
  -- Draw the submit button
    love.graphics.setColor(submitButton.color)
    love.graphics.rectangle("fill", submitButton.x, submitButton.y, submitButton.width, submitButton.height, 10, 10)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.printf(submitButton.text, submitButton.x, submitButton.y + 15, submitButton.width, "center")
  
  
  for _, card in ipairs(cardTable) do
    card:draw()
  end

    --draw you win or lose
    if win ~= 0 then
      love.graphics.setColor(0, 0, 0)
      love.graphics.draw(backgroundImage, 0, 0, 0, 1, 1)
      
      love.graphics.setColor(green)
      love.graphics.rectangle("fill", 340, 400, 600, 150, 12)
      love.graphics.setColor(1, 1, 1)
      love.graphics.setFont(love.graphics.newFont(60))
      love.graphics.printf("Play Again", 150, 440, 1000, "center")
      
      love.graphics.setFont(love.graphics.newFont(180))
      
    end
    if win == 1 then
      love.graphics.setColor(green)
      love.graphics.printf("You Win!", 120, 160, 1000, "center")
    elseif win == -1 then
      love.graphics.setColor(red)
      love.graphics.printf("You Lose!", 120, 160, 1000, "center")
    end
end