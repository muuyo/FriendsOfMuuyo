
SMODS.Sound {
  key="opencan",
  path= 'opencan.ogg',
  volume = 0.5
}
SMODS.Sound {
  key="greenzwin",
  path= 'greenzwin.ogg',
}
SMODS.Sound {
  key="greenzlose",
  path= 'greenzlose.ogg',
}

SMODS.Atlas {
  -- Key for code to find it with
  key = "FOM1",
  -- The name of the file, for the code to pull the atlas from
  path = "FOM1.png",
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}

SMODS.Joker {
    key="Jill",
    loc_txt = {
        name="Jill Stingray",
        text={
          "Gain 1 random {C:attention}base Consumable{} of any type",
          "and lose {C:money}$#1#{} at end of round" 
        },
    },
    config = {
        extra = {
            cost = 2,
            tarot = .4,
            planet = .8
        }
    },
    atlas='FOM1',
    pos= {x=0,y=0},
    rarity=2,
    cost=2,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cost } }
    end,

--[[     calc_dollar_bonus = function(self, card)
      local bonus = (card.ability.extra.cost*-1)
      return bonus
    end,
 ]]
    calculate = function(self, card, context)
      if context.end_of_round and not context.repetition and not context.individual and #G.consumeables.cards < G.consumeables.config.card_limit then

          SMODS.add_card {
            set = 'Consumeables',
            area = G.consumeables,
            soulable = true,
          }

          play_sound('myo_opencan')
          return {
            dollars = card.ability.extra.cost*-1
          }
      end
    end
}


--[[ 
SMODS.Joker {
  key="",
  loc_txt = {
      name="",
      text={
        "" 
      },
  },
  config = {
      extra = {
          cost = 2,
      }
  },
  atlas='FOM1',
  pos= {x=0,y=0},
  rarity=1,
  cost=2,
  loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.cost } }
  end,

  calculate = function(self, card, context)

  end
}
]]

SMODS.Joker {
  key="Greenz",
  loc_txt = {
      name="Mr. GREENZ",
      text={
        "Has a {C:green}#2# in 2{} chance to double",
        "XMult each hand, otherwise halves it",
        "{S:0.8}resets to 1 at the start of each Ante",
        "{C:inactive}(Currently {X:mult,C:white} X#1# Mult)"
      },
  },
  config = {
      extra = {
          XMult = 1,
      }
  },
  atlas='FOM1',
  pos= {x=1,y=0},
  rarity=3,
  cost=9.85,
  loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.XMult, (G.GAME.probabilities.normal or 1) } }
  end,

  calculate = function(self, card, context)
    
      if context.cardarea == G.jokers and context.after == true then
        if pseudorandom(greenz) < G.GAME.probabilities.normal / card.ability.extra.odds then
          card.ability.extra.XMult = card.ability.extra.XMult * 2
          play_sound('myo_greenzwin')
          card = card
        else
          card.ability.extra.XMult = card.ability.extra.XMult / 2
          play_sound('myo_greenzlose')
          card = card

        end
      end
      
      if context.end_of_round and context.individual and not context.blueprint then
        card.ability.extra.XMult = 1
        card = card
        return {
          message = localize('k_reset'),
          colour = G.C.RED
        }
      end

      if context.joker_main then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.XMult }}
      }
      end
      


  end
}