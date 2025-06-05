
require "mythodex"

function buildDeck(owner)
  local deck = {}
  local cardCounts = {}

  while #deck < 20 do
    local candidate = mythodex[math.random(#mythodex)]
    local name = candidate.name

    -- ensure at most 2 copies
    if not cardCounts[name] then
      cardCounts[name] = 0
    end

    if cardCounts[name] < 2 then --create a card instance
      local card = CardClass:new(
        -999, -999, --offscreen
        candidate.power,
        candidate.cost,
        candidate.name,
        candidate.text,
        candidate.id,
        owner
      )

      table.insert(deck, card)
      cardCounts[name] = cardCounts[name] + 1
    end
  end

  --Fisher-Yates shuffle
  for i = #deck, 2, -1 do
    local j = math.random(i)
    deck[i], deck[j] = deck[j], deck[i]
  end

  return deck
end