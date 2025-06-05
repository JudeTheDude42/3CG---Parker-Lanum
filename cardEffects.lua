
local cardEffects = {}

function cardEffects.resolve(card, player, opponent, locations, owner)
  if not card or not card.id or card.id < 5 then return end

  local other = nil

  if owner == player then
    other = opponent
  elseif owner == opponent then
    other = player
  end

  local id = card.id

  --cards id 1-4 are vanilla
  if id == 5 then
    
    -- Zeus: Lower the power of each card in opponent's hand by 1
    for _, card2 in ipairs(other.hand) do
      card2.power = card2.power - 1
    end
    
  elseif id == 6 then
    
    -- Ares: Gain +2 power for each enemy card here
    for _, card2 in ipairs(other.stagedCards) do
      if card.location == card2.location then
        card.power = card.power + 2
      end
    end
    
  elseif id == 7 then
    
    -- Medusa: When any other card is played here, lower that card’s power by 1
    
  elseif id == 8 then
    
    -- Cyclops: Discard your other cards here, gain +2 power per discarded
    
  elseif id == 9 then
    
    -- Poseidon: Move away an enemy card here with the lowest power
    
  elseif id == 10 then
    
    -- Artemis: Gain +5 power if exactly one enemy card is here
    local i = 0
    for _, card2 in ipairs(other.stagedCards) do
      if card.location == card2.location then
        i = i + 1
      end
    end
    
    if i == 1 then card.power = card.power + 5 end
    
  elseif id == 11 then
    
    -- Hera: Give cards in your hand +1 power
    for _, card2 in ipairs(owner.hand) do
      card2.power = card2.power + 1
    end
    
  elseif id == 12 then
    
    -- Demeter: Both players draw a card
    player:drawCard()
    player:arrangeHand()
    opponent:drawCard()
    opponent:arrangeHand()
    
  elseif id == 13 then
    
    -- Hades: Gain +2 power for each card in discard pile
    
  elseif id == 14 then
    
    -- Hercules: Double its power if strongest card here
    local strongest = true
    for _, card2 in ipairs(owner.stagedCards) do
      if card.location == card2.location then
        if card2.power > card.power then strongest = false end
      end
    end
    for _, card2 in ipairs(other.stagedCards) do
      if card.location == card2.location then
        if card2.power > card.power then strongest = false end
      end
    end
    if strongest then card.power = card.power * 2 end
    
  elseif id == 15 then
    
    -- Dionysus: +2 power for each of your other cards here
    for _, card2 in ipairs(owner.stagedCards) do
      if card.location == card2.location then
        card.power = card.power + 2
      end
    end
    card.power = card.power - 2
    
  elseif id == 16 then
    
    -- Hermes: Moves to another location
    
  elseif id == 17 then
    
    -- Hydra: Add two copies to hand when discarded
    
  elseif id == 18 then
    
    -- Ship of Theseus: Add a copy with +1 power to hand
    
  elseif id == 19 then
    
    -- Sword of Damocles: Loses 1 power if not winning this location
    
  elseif id == 20 then
    
    -- Midas: Set ALL cards here to 3 power
    for _, card2 in ipairs(owner.stagedCards) do
      if card.location == card2.location then
        card2.power = 3
      end
    end
    for _, card2 in ipairs(other.stagedCards) do
      if card.location == card2.location then
        card2.power = 3
      end
    end
    
  elseif id == 21 then
    
    -- Aphrodite: Lower power of each enemy card here by 1
    for _, card2 in ipairs(other.stagedCards) do
      if card.location == card2.location then
        card2.power = card2.power - 1
      end
    end
    
  elseif id == 22 then
    
    -- Athena: Gain +1 power when you play another card here
    
  elseif id == 23 then
    
    -- Apollo: Gain +1 mana next turn
    owner.mana = owner.mana + 1
    
  elseif id == 24 then
    
    -- Hephaestus: Lower cost of 2 cards in hand by 1
    
  elseif id == 25 then
    
    -- Persephone: Discard lowest power card in hand
    
  elseif id == 26 then
    
    -- Prometheus: Draw a card from opponent’s deck
    
  elseif id == 27 then
    
    -- Pandora: If no allies are here, -5 power
    local i = 0
    for _, card2 in ipairs(owner.stagedCards) do
      print(card2.name)
      if card.location == card2.location then
        i = i + 1
        print(card.location)
        print(card2.location)
      end
    end
    
    if i < 2 then card.power = card.power - 5 end
    
  elseif id == 28 then
    
    -- Icarus: Gains +1 power each turn, discard if > 7
    
  elseif id == 29 then
    
    -- Iris: Give +1 power to cards at other locations with unique powers
    
  elseif id == 30 then
    
    -- Nyx: Discard other cards here, add their power to this
    
  elseif id == 31 then
    
    -- Atlas: Loses 1 power if your side of location is full
    
  elseif id == 32 then
    
    -- Daedalus: Add Wooden Cow to each other location
    
  elseif id == 33 then
    
    -- Helios: Discard this at end of turn
    
  elseif id == 34 then
    
    -- Mnemosyne: Add a copy of last card played to your hand
    
  end
end

return cardEffects