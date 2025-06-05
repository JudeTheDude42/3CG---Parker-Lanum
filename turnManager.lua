
TurnManagerClass = {}

function TurnManagerClass:new()
  local turnManager = {}
  local metadata = {__index = TurnManagerClass}
  setmetatable(turnManager, metadata)
  
  turnManager.turnNumber = 1
  turnManager.playerSumbitted = false
  turnManager.opponentSumbitted = false
  
  turnManager.resolveQueue = {}
  turnManager.resolveTimer = 2
  turnManager.resolveDelay = 2 --2 seconds between cards
  turnManager.resolving = false
  
  return turnManager
end

--Called when the game begins
function TurnManagerClass:startGame()
  self.turnNumber = 1
  self.playerSubmitted = false
  self.opponentSubmitted = true

  player:startTurn(self.turnNumber)
  opponent:startTurn(self.turnNumber)
end

--Called when the player clicks the Submit button
function TurnManagerClass:playerSubmit()
  if not self.playerSubmitted then
    player:submitTurn()
    self.playerSubmitted = true
  end
end

--Called when opponent turn logic is complete
function TurnManagerClass:opponentSubmit()
  if not self.opponentSubmitted then
    opponent:submitTurn()
    self.opponentSubmitted = true
  end
end

--Regularly called from love.update()
function TurnManagerClass:update(dt)
  
  if turnManager.resolving and #turnManager.resolveQueue > 0 then
    turnManager.resolveTimer = turnManager.resolveTimer - dt

    if turnManager.resolveTimer <= 0 then
      local next = table.remove(turnManager.resolveQueue, 1)
      next.card.shown = true

      if not next.card.alreadyRevealed then
        local cardEffects = require("cardEffects")
        cardEffects.resolve(next.card, player, opponent, locations, next.owner)
        next.card.alreadyRevealed = true
      end

      turnManager.resolveTimer = turnManager.resolveDelay
    end

    --Finished resolving
  elseif turnManager.resolving and #turnManager.resolveQueue == 0 then
    turnManager.resolving = false

    --Call scoring once resolution is complete
    calculateScores()
    
    opponentPlay()
  end
  
  --Proceed to the next turn if both players have submitted
  if self.playerSubmitted and self.opponentSubmitted then
    self:startNextTurn()
  end
  
end

local cardEffects = require("cardEffects")

--Move to the next turn
function TurnManagerClass:startNextTurn()
  --hide all cards submitted in preparation for reveal
  for _, card in ipairs(player.stagedCards) do
    if not card.alreadyRevealed then
      card.shown = false
    end
  end
  
  --card behavior
  cardPowers()

  self.turnNumber = self.turnNumber + 1
  self.playerSubmitted = false
  self.opponentSubmitted = true

  player:startTurn(self.turnNumber)
  opponent:startTurn(self.turnNumber)
end

function cardPowers()
  local cardEffects = require("cardEffects")

  turnManager.resolveQueue = {}

  --Add all cards to queue (starting with winner or random)
  local first = love.math.random(1, 2)
  
  if player.points > opponent.points then 
    first = 1
  elseif player.points < opponent.points then 
    first = 2
  end
  
  if first == 1 then
    enqueuePlayerCards()
    enqueueOpponentCards()
  else
    enqueueOpponentCards()
    enqueuePlayerCards()
  end 

  turnManager.resolveTimer = 0
  turnManager.resolving = true
end

--Helper function to calculate the scores at each location
function calculateScores()
  for i = 1, 3 do
    local playerLoc = locations[i]
    local opponentLoc = locations[i + 3]

    local playerTotal = 0
    local opponentTotal = 0

    for _, card in ipairs(playerLoc.cards) do
      if card.submitted then
        playerTotal = playerTotal + card.power
      end
    end

    for _, card in ipairs(opponentLoc.cards) do
      if card.submitted then
        opponentTotal = opponentTotal + card.power
      end
    end

    local difference = playerTotal - opponentTotal
    if difference > 0 then
      player.points = player.points + difference
    else
      opponent.points = opponent.points - difference
    end
  end
end

function enqueuePlayerCards()
  for _, card in ipairs(player.stagedCards) do
    if card.submitted and not card.alreadyRevealed then
      table.insert(turnManager.resolveQueue, {card = card, owner = player})
    end
  end
end

function enqueueOpponentCards()
  for _, card in ipairs(opponent.stagedCards) do
    if card.submitted and not card.alreadyRevealed then
      table.insert(turnManager.resolveQueue, {card = card, owner = opponent})
    end
  end
end

--Highly advanced AI opponent (plays the first card it can)
function opponentPlay()
  for _, card in ipairs(opponent.hand) do
    local rand = love.math.random(1, 3) + 3
    local loc = locations[rand]
    if opponent.mana >= card.cost and #loc.cards < 4 then
      opponent.mana = opponent.mana - card.cost
      card.submitted = false

      --Remove from hand
      for h = #opponent.hand, 1, -1 do
        if opponent.hand[h] == card then
          table.remove(opponent.hand, h)
          break
        end
      end

      --Add to location and player's staged cards  
      card.location = rand - 3
      loc:addCard(card)
      table.insert(opponent.stagedCards, card)
      break
    end
  end
  
  opponent:submitTurn()
  
  TurnManagerClass:opponentSubmit()
end