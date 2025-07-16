local MOD = {
	id = "CultSim",
	name = "CultSim Crossover",
	version = "1.0.0",
	mod_version = "1.0.0",
	dependencies = {},
	enabled = true,
	icon = "Mods/CultSim/icon.png",
}
SMODS.optional_features.cardareas.unscored = true

----------------------------------------------------------------------------------------
----------------.------..------..------..------..------..------..------.----------------
----------------|A.--. ||T.--. ||L.--. ||A.--. ||S.--. ||E.--. ||S.--. |----------------
----------------| (\/) || :/\: || :/\: || (\/) || :/\: || (\/) || :/\: |----------------
----------------| :\/: || (__) || (__) || :\/: || :\/: || :\/: || :\/: |----------------
----------------| '--'A|| '--'T|| '--'L|| '--'A|| '--'S|| '--'E|| '--'S|----------------
----------------`------'`------'`------'`------'`------'`------'`------'----------------
----------------------------------------------------------------------------------------

--------------------------------------------
-- Jokers
--------------------------------------------
SMODS.Atlas({
	key = "jok",
	path = "Occult_Jok.png",
	px = 71,
	py = 95,
})

--------------------------------------------
-- Occult Boosters
--------------------------------------------
SMODS.Atlas({
	key = "pack",
	path = "Occult_Pack.png",
	px = 71,
	py = 95,
})

--------------------------------------------
-- Occult Influences
--------------------------------------------
SMODS.Atlas({
	key = "cons",
	path = "Occult_Cons.png",
	px = 71,
	py = 95,
})

--------------------------------------------
-- Vouchers
--------------------------------------------
SMODS.Atlas({
	key = "vouch",
	path = "Occult_Vouchers.png",
	px = 71,
	py = 95,
})

--------------------------------------------
-- Decks
--------------------------------------------
SMODS.Atlas({
	key = "back",
	path = "Occult_Back.png",
	px = 71,
	py = 95,
})

--------------------------------------------
-- Tags
--------------------------------------------
SMODS.Atlas({
	key = "tag",
	path = "Occult_Tag.png",
	px = 34,
	py = 34,
})



function PrintTable(tbl, prefix)
	-- Function to recursively print table contents with key paths
	for key, value in pairs(tbl) do
		local keyPath = prefix .. (prefix == "" and "" or ".") .. tostring(key)
		if type(value) == "table" then
			PrintTable(value, keyPath)
		else
			sendInfoMessage(keyPath .. ": " .. tostring(value), "tgmpDebug")
		end
	end
end

function printDebugInfo()
	-- Print current_round structure
	sendInfoMessage("===== CURRENT ROUND =====", "occDebug")
	PrintTable(G.GAME.current_round, "current_round")

	-- Print round_resets structure
	sendInfoMessage("===== ROUND RESETS =====", "occDebug")
	PrintTable(G.GAME.round_resets, "round_resets")
end

----------------------------------------------------------------------------------------
------------------------.------..------..------..------..------.------------------------
------------------------|D.--. ||E.--. ||C.--. ||K.--. ||S.--. |------------------------
------------------------| :/\: || (\/) || :/\: || :/\: || :/\: |------------------------
------------------------| (__) || :\/: || :\/: || :\/: || :\/: |------------------------
------------------------| '--'D|| '--'E|| '--'C|| '--'K|| '--'S|------------------------
------------------------`------'`------'`------'`------'`------'------------------------
----------------------------------------------------------------------------------------

--------------------------------------------
-- Deck of Hours
-- Start with An Occult Scrap and Vagabond's Map
--------------------------------------------
SMODS.Back {
    key = "occult",
	atlas = "back",
    pos = { 
		x = 0, 
		y = 0 
	},
    config = { vouchers = { 'v_tg_cultsim_vouch_1', 'v_tg_cultsim_vouch_2' } },
    unlocked = true,
	loc_txt	= {
		name="Deck of Hours",
        text={
            "Start run with",
            "{C:spectral,T:v_tg_cultsim_vouch_1}#1#{},",
            "and {C:spectral,T:v_tg_cultsim_vouch_2}#2#{},",
        },
	},
    loc_vars = function(self, info_queue, back)
        return {
            vars = { localize { type = 'name_text', key = self.config.vouchers[1], set = 'Voucher' },
                localize { type = 'name_text', key = self.config.vouchers[2], set = 'Voucher' }
            }
        }
    end,
}

----------------------------------------------------------------------------------------
--------------------.------..------..------..------..------..------.--------------------
--------------------|J.--. ||O.--. ||K.--. ||E.--. ||R.--. ||S.--. |--------------------
--------------------| :(): || :/\: || :/\: || (\/) || :(): || :/\: |--------------------
--------------------| ()() || :\/: || :\/: || :\/: || ()() || :\/: |--------------------
--------------------| '--'J|| '--'O|| '--'K|| '--'E|| '--'R|| '--'S|--------------------
--------------------`------'`------'`------'`------'`------'`------'--------------------
----------------------------------------------------------------------------------------

--------------------------------------------
-- Enlightenment
-- Make an Influence card if
-- scoring hand has all 4 suits
--------------------------------------------
SMODS.Joker {
	key = "enlightenment",
	name = "Enlightenment",
	atlas = "jok",
	pos = {
		x = 0,
		y = 0
	},
	loc_txt = {
		name = "Enlightenment",
		text = {
			"Create an {C:occult}Influence{} card if",
            "poker hand contains a",
            "{C:diamonds}Diamond{} card, {C:clubs}Club{} card,",
            "{C:hearts}Heart{} card, and {C:spades}Spade{} card",
			"{C:inactive}Must have room{}"
		}
	},
	config = {levels = {}, extra = {level_amt = 1}},
  	rarity = 2, --uncommon
  	cost = 6,
	calculate = function(self, card, context)
		if context.joker_main then
    		local suits = {
    	    	['Hearts'] = 0,
    	    	['Diamonds'] = 0,
    	    	['Spades'] = 0,
    	    	['Clubs'] = 0
    		}	
    	    for i = 1, #context.scoring_hand do
    	        if context.scoring_hand[i].ability.name ~= 'Wild Card' then
    	            if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then 
						suits["Hearts"] = suits["Hearts"] + 1
    	            elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0  then 
						suits["Diamonds"] = suits["Diamonds"] + 1
    	            elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0  then 
						suits["Spades"] = suits["Spades"] + 1
    	            elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0  then 
						suits["Clubs"] = suits["Clubs"] + 1 
					end
	            end
    	    end
        	for i = 1, #context.scoring_hand do
            	if context.scoring_hand[i].ability.name == 'Wild Card' then
                	if context.scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then 
						suits["Hearts"] = suits["Hearts"] + 1
	                elseif context.scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0  then 
						suits["Diamonds"] = suits["Diamonds"] + 1
        	        elseif context.scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0  then 
						suits["Spades"] = suits["Spades"] + 1
                	elseif context.scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0  then 
						suits["Clubs"] = suits["Clubs"] + 1 
					end
    	        end
        	end
        	if suits["Hearts"] > 0 and suits["Diamonds"] > 0 and suits["Spades"] > 0 and suits["Clubs"] > 0 then
            	if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                	G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                	G.E_MANAGER:add_event(Event({
                    	trigger = 'before',
                    	delay = 0.0,
                    	func = (function()
	                            local card = create_card('occult',G.consumeables, nil, nil, nil, nil, nil, 'sixth')
    	                        card:add_to_deck()
        	                    G.consumeables:emplace(card)
            	                G.GAME.consumeable_buffer = 0
                	        return true
                    	end)}))
	            end
    	        	return true
        	end
    	end
	end
}

--------------------------------------------
-- Sensation
-- Consumes first played Face card
-- and keeps its Chips and Mult
--------------------------------------------
SMODS.Joker {
	key = "sensation",
	name = "Sensation",
	atlas = "jok",
	pos = {
		x = 1,
		y = 0
	},
	loc_txt = {
		name = "Sensation",
		text = {
			"Destroy first played",
			"{C:attention}Face Card{}, and",
			"gain all of its",
			"{C:chips}Chips{} and {C:mult}Mult{}",
			"{C:inactive}Current: {}{C:chips}#1#{}{C:inactive}, {}{C:mult}#2#{}"
		}
	},
	config = {extra = {chip_collect = 0, mult_collect = 0}},
  	rarity = 3, --rare
  	cost = 8,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_collect, card.ability.extra.mult_collect } }
    end,
	calculate = function(self, card, context)
		if context.destroy_card and not context.blueprint then
			local facecard_slot = 0
			local temp_mult = 0
			local temp_chips = 0
			local temp_rank = 0
			for i = #context.full_hand, 1, -1 do
				if G.play.cards[i]:is_face() then
					facecard_slot = i
					if G.play.cards[i]:get_id() == 13 or G.play.cards[i]:get_id() == 12 or G.play.cards[i]:get_id() == 11 then
						temp_rank = 10
					elseif G.play.cards[i]:get_id() == 14 then
						temp_rank = 11
					else
						temp_rank = G.play.cards[i]:get_id()
					end
					temp_mult = G.play.cards[i].ability.perma_mult
					temp_chip = G.play.cards[i].ability.perma_bonus + temp_rank
				end
			end
	        if not(facecard_slot == 0) and context.destroy_card and context.destroy_card == G.play.cards[facecard_slot] then
  				card.ability.extra.mult_collect = card.ability.extra.mult_collect + G.play.cards[facecard_slot].ability.mult + temp_mult
				card.ability.extra.chip_collect = card.ability.extra.chip_collect + G.play.cards[facecard_slot].ability.bonus + temp_chip
			return {
    				remove = true
  				}
			end
		end
		if context.joker_main then
            return {
                mult = card.ability.extra.mult_collect,
				chips = card.ability.extra.chip_collect
            }
        end
    end
}

--------------------------------------------
-- Power
-- Gains X Mult per card in deck
-- with extra Chips or Mult
--------------------------------------------

SMODS.Joker {
	key = "power",
	name = "Power",
	atlas = "jok",
	pos = {
		x = 2,
		y = 0
	},
	loc_txt = {
		name = "Power",
		text = {
			"This Joker gains {X:mult,C:white} X#1# {} Mult",
			"for each card in",
			"your full deck",
			"with extra {C:chips}Chips{}", 
			"or extra {C:mult}Mult{}",
			"{C:inactive}Currently {X:mult,C:white} X#2# {C:inactive} Mult",
		}
	},
	config = {extra = {tally = 0, x_mult_per = 0.05, x_mult_base = 1, x_mult_total = 1}},
  	rarity = 3, --rare
  	cost = 8,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_per, card.ability.extra.x_mult_total } }
    end,
	calculate = function(self, card, context)
		if G.STAGE == G.STAGES.RUN then
			card.ability.extra.tally = 0
            for k, v in pairs(G.playing_cards) do
                if v.ability.perma_mult + v.ability.mult ~= 0 or v.ability.perma_bonus + v.ability.bonus ~= 0 then 
					card.ability.extra.tally = card.ability.extra.tally+1 
				end
            end
			card.ability.extra.x_mult_total = card.ability.extra.x_mult_base + (card.ability.extra.tally * card.ability.extra.x_mult_per)
		end
		if context.joker_main then
			if (card.ability.extra.tally ~= 0) then 
        	    return {
        	        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult_total}},
        		        Xmult_mod = card.ability.extra.x_mult_total
        	    }
        	end
		end
	end
}
----------------------------------------------------------------------------------------
----------------------------.------..------..------..------.----------------------------
----------------------------|T.--. ||A.--. ||G.--. ||S.--. |----------------------------
----------------------------| :/\: || (\/) || :/\: || :/\: |----------------------------
----------------------------| (__) || :\/: || :\/: || :\/: |----------------------------
----------------------------| '--'T|| '--'A|| '--'G|| '--'S|----------------------------
----------------------------`------'`------'`------'`------'----------------------------
----------------------------------------------------------------------------------------

--------------------------------------------
-- Rite Tag
-- Gives a free Mega Occult Pack
--------------------------------------------
SMODS.Tag {
	key = "tag",
	loc_txt = {
		name="Rite Tag",
        text={
            "Gives a free",
            "{C:attention}Mega Occult Pack",
        },
	},
	atlas = "tag",
	pos = { 
		x = 0, 
		y = 0 
	},
	apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.PURPLE, function()
                local booster = SMODS.create_card { key = 'p_tg_cultsim_m_booster_1', area = G.play }
                booster.T.x = G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2
                booster.T.y = G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2
                booster.T.w = G.CARD_W * 1.27
                booster.T.h = G.CARD_H * 1.27
                booster.cost = 0
                booster.from_tag = true
                G.FUNCS.use_card({ config = { ref_table = booster } })
                booster:start_materialize()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}

----------------------------------------------------------------------------------------
------------.------..------..------..------..------..------..------..------.------------
------------|V.--. ||O.--. ||U.--. ||C.--. ||H.--. ||E.--. ||R.--. ||S.--. |------------
------------| :(): || :/\: || (\/) || :/\: || :/\: || (\/) || :(): || :/\: |------------
------------| ()() || :\/: || :\/: || :\/: || (__) || :\/: || ()() || :\/: |------------
------------| '--'V|| '--'O|| '--'U|| '--'C|| '--'H|| '--'E|| '--'R|| '--'S|------------
------------`------'`------'`------'`------'`------'`------'`------'`------'------------
----------------------------------------------------------------------------------------

--------------------------------------------
-- Voucher - An Occult Scrap
-- Occult Cards appear in the Shop
--------------------------------------------
SMODS.Voucher {
	key = "vouch_1",
	atlas = "vouch",
	set = "Voucher",
	pos = {
		x = 0,
		y = 0
	},
	config = { extra = 1 },
	cost = 10,
	loc_txt = {
		name = "An Occult Scrap",
		text = {"{C:occult}Influence{} cards may",
            "appear in the shop",
		},
	},
	loc_vars = function(self, info_queue, card)
		return{ vars = {card.ability.extra} }
	end,
	redeem = function(self, card)
		G.GAME.occult_rate = 2;
	end
}

--------------------------------------------
-- Voucher - Vagabond's Map
-- Occult Cards appear in Shops x2
--------------------------------------------
SMODS.Voucher {
	key = "vouch_2",
	atlas = "vouch",
	set = "Voucher",
	pos = {
		x = 1,
		y = 0
	},
	config = { extra = 1 },
	cost = 10,
	loc_txt = {
		name = "Vagabond's Map",
		text = {"{C:occult}Influence{} cards",
            "appear in the shop",
			"twice as often",
		},	
	},
	requires = {"v_vouch_1"},
	loc_vars = function(self, info_queue, card)
		return{ vars = {card.ability.extra} }
	end,
	redeem = function(self, card)
		G.GAME.occult_rate = 4;
	end
}

----------------------------------------------------------------------------------------
--------------------.------..------..------..------..------..------.--------------------
--------------------|O.--. ||C.--. ||C.--. ||U.--. ||L.--. ||T.--. |--------------------
--------------------| :/\: || :/\: || :/\: || (\/) || :/\: || :/\: |--------------------
--------------------| :\/: || :\/: || :\/: || :\/: || (__) || (__) |--------------------
--------------------| '--'O|| '--'C|| '--'C|| '--'U|| '--'L|| '--'T|--------------------
--------------------`------'`------'`------'`------'`------'`------'--------------------
----------------------------------------------------------------------------------------

SMODS.ConsumableType {
    key = 'occult',
	shop_rate = 0,
    loc_txt = {
         name = 'Influence', -- used on card type badges
         collection = 'Influences', -- label for the button to access the collection
         undiscovered = { -- description for undiscovered cards in the collection
             name = 'Not Discovered',
             text = { 'Purchase or use',
                     'this card in an',
                     'unseeded run to',
                     'learn what it does' },
         },
     },
	collection_rows = {4, 4},
    primary_colour = HEX('309EC3'),
    secondary_colour = HEX('309EC3')
}

--.------..------..------..------..------..------..------..------.--
--|B.--. ||O.--. ||O.--. ||S.--. ||T.--. ||E.--. ||R.--. ||S.--. |--
--| :(): || :/\: || :/\: || :/\: || :/\: || (\/) || :(): || :/\: |--
--| ()() || :\/: || :\/: || :\/: || (__) || :\/: || ()() || :\/: |--
--| '--'B|| '--'O|| '--'O|| '--'S|| '--'T|| '--'E|| '--'R|| '--'S|--
--`------'`------'`------'`------'`------'`------'`------'`------'--

--------------------------------------------
-- Booster 1
-- 1 of 4
--------------------------------------------
SMODS.Booster {
	name = "Occult Pack",
	key = "booster_1",
	kind = "occult",
	atlas = "pack",
	pos = { 
		x = 0, 
		y = 0 
	},
	config = { extra = 4, choose = 1},
	cost = 4,
	weight = 1,
  	draw_hand = true,
  	unlocked = true,
  	discovered = true,
    set = "Booster",
	loc_txt = {
		name="Occult Pack",
		group_name = "Occult Pack",
		text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:occult} Influence{} cards to",
            "be used immediately",
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	ease_background_colour = function(self)
        return ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
	create_card = function(self, card, i)
        return {
            set = "occult",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false
        }
    end
}

--------------------------------------------
-- Booster 2
-- 1 of 4
--------------------------------------------
SMODS.Booster {
	name = "Occult Pack",
	key = "booster_2",
	kind = "occult",
	atlas = "pack",
	pos = { 
		x = 1, 
		y = 0 
	},
	config = { extra = 4, choose = 1},
	cost = 4,
	weight = 1,
  	draw_hand = true,
  	unlocked = true,
  	discovered = true,
    set = "Booster",
	loc_txt = {
		name="Occult Pack",
		group_name = "Occult Pack",
		text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:occult} Influence{} cards to",
            "be used immediately",
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	ease_background_colour = function(self)
        return ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
	create_card = function(self, card, i)
        return {
            set = "occult",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false
        }
    end
}

--------------------------------------------
-- Booster 3
-- 1 of 4
--------------------------------------------
SMODS.Booster {
	name = "Occult Pack",
	key = "booster_3",
	kind = "occult",
	atlas = "pack",
	pos = { 
		x = 2, 
		y = 0 
	},
	config = { extra = 4, choose = 1},
	cost = 4,
	weight = 1,
  	draw_hand = true,
  	unlocked = true,
  	discovered = true,
    set = "Booster",
	loc_txt = {
		name="Occult Pack",
		group_name = "Occult Pack",
		text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:occult} Influence{} cards to",
            "be used immediately",
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	ease_background_colour = function(self)
        return ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
	create_card = function(self, card, i)
        return {
            set = "occult",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false
        }
    end
}

--------------------------------------------
-- Booster 4
-- 1 of 4
--------------------------------------------
SMODS.Booster {
	name = "Occult Pack",
	key = "booster_4",
	kind = "occult",
	atlas = "pack",
	pos = { 
		x = 3, 
		y = 0 
	},
	config = { extra = 4, choose = 1},
	cost = 4,
	weight = 1,
  	draw_hand = true,
  	unlocked = true,
  	discovered = true,
    set = "Booster",
	loc_txt = {
		name="Occult Pack",
		group_name = "Occult Pack",
		text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:occult} Influence{} cards to",
            "be used immediately",
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	ease_background_colour = function(self)
        return ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
	create_card = function(self, card, i)
        return {
            set = "occult",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false
        }
    end
}

--------------------------------------------
-- Jumbo Booster 1
-- 1 of 6
--------------------------------------------
SMODS.Booster {
	name = "Jumbo Occult Pack",
	key = "j_booster_1",
	kind = "occult",
	atlas = "pack",
	pos = { 
		x = 0, 
		y = 1 
	},
	config = { extra = 6, choose = 1},
	cost = 6,
	weight = 1,
  	draw_hand = true,
  	unlocked = true,
  	discovered = true,
    set = "Booster",
	loc_txt = {
		name="Jumbo Occult Pack",
		group_name = "Occult Pack",
		text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:occult} Influence{} cards to",
            "be used immediately",
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	ease_background_colour = function(self)
        return ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
	create_card = function(self, card, i)
        return {
            set = "occult",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false
        }
    end
}

--------------------------------------------
-- Jumbo Booster 2
-- 1 of 6
--------------------------------------------
SMODS.Booster {
	name = "Jumbo Occult Pack",
	key = "j_booster_2",
	kind = "occult",
	atlas = "pack",
	pos = { 
		x = 1, 
		y = 1 
	},
	config = { extra = 6, choose = 1},
	cost = 6,
	weight = 1,
  	draw_hand = true,
  	unlocked = true,
  	discovered = true,
    set = "Booster",
	loc_txt = {
		name="Jumbo Occult Pack",
		group_name = "Occult Pack",
		text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:occult} Influence{} cards to",
            "be used immediately",
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	ease_background_colour = function(self)
        return ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
	create_card = function(self, card, i)
        return {
            set = "occult",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false
        }
    end
}

--------------------------------------------
-- Mega Booster 1
-- 2 of 6
--------------------------------------------
SMODS.Booster {
	name = "Occult Pack",
	key = "m_booster_1",
	kind = "occult",
	atlas = "pack",
	pos = { 
		x = 2, 
		y = 1 
	},
	config = { extra = 6, choose = 2},
	cost = 8,
	weight = 1,
  	draw_hand = true,
  	unlocked = true,
  	discovered = true,
    set = "Booster",
	loc_txt = {
		name="Mega Occult Pack",
		group_name = "Occult Pack",
		text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:occult} Influence{} cards to",
            "be used immediately",
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	ease_background_colour = function(self)
        return ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
	create_card = function(self, card, i)
        return {
            set = "occult",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false
        }
    end
}

--------------------------------------------
-- Mega Booster 2
-- 2 of 6
--------------------------------------------
SMODS.Booster {
	name = "Occult Pack",
	key = "m_booster_2",
	kind = "occult",
	atlas = "pack",
	pos = { 
		x = 3, 
		y = 1 
	},
	config = { extra = 6, choose = 2},
	cost = 8,
	weight = 1,
  	draw_hand = true,
  	unlocked = true,
  	discovered = true,
    set = "Booster",
	loc_txt = {
		name="Mega Occult Pack",
		group_name = "Occult Pack",
		text={
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:occult} Influence{} cards to",
            "be used immediately",
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	ease_background_colour = function(self)
        return ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,
	create_card = function(self, card, i)
        return {
            set = "occult",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false
        }
    end
}

--.------..------..------..------..------..------..------..------..------..------.--
--|I.--. ||N.--. ||F.--. ||L.--. ||U.--. ||E.--. ||N.--. ||C.--. ||E.--. ||S.--. |--
--| (\/) || :(): || :(): || :/\: || (\/) || (\/) || :(): || :/\: || (\/) || :/\: |--
--| :\/: || ()() || ()() || (__) || :\/: || :\/: || ()() || :\/: || :\/: || :\/: |--
--| '--'I|| '--'N|| '--'F|| '--'L|| '--'U|| '--'E|| '--'N|| '--'C|| '--'E|| '--'S|--
--`------'`------'`------'`------'`------'`------'`------'`------'`------'`------'--

--------------------------------------------
-- Heart - An Imminence
-- +2 Mult - Hearts
--------------------------------------------
SMODS.Consumable {
	key = "heart",
	name = "An Imminence",
	slug = "heart",
	cost = 3,
	set = "occult",
	atlas = "cons",
	pos = {
		x = 0,
		y = 0,
	},
	config = {extra = {grant_mult = 2}},
	
	loc_txt = {
		name = "An Imminence",
		text = {
			"All {C:hearts}Hearts{} in hand",
			"gain {C:mult}+#1#{} Mult",
		},
	},
	loc_vars = function(self, info_queue, card)
       	return { vars = { card.ability.extra.grant_mult } }
    end,
	sprite = "heart",
	can_use = function(self, card)
		return #G.hand.cards > 0 
	end,
	use = function(self, card, area, copier)
    	if G.hand.cards and #G.hand.cards > 0 then
      		for i = 1, #G.hand.cards do
        		if G.hand.cards[i]:is_suit("Hearts") then
					G.hand.cards[i].ability.perma_mult = (G.hand.cards[i].ability.perma_mult or 0) + card.ability.extra.grant_mult
      				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_upgrade_ex"), colour = G.C.RED})
             		G.E_MANAGER:add_event(Event({
                		func = function()
                		G.hand.cards[i]:juice_up(0.3, 0.4)
                		return true
            		end
            		})) 
        		end
      		end
		end
	end
}

--------------------------------------------
-- Lantern - A Splendour
-- +2 Mult - Diamonds
--------------------------------------------
SMODS.Consumable {
	key = "lantern",
	name = "A Splendour",
	slug = "lantern",
	cost = 3,
	set = "occult",
	atlas = "cons",
	pos = {
		x = 1,
		y = 0,
	},
	config = {extra = {grant_mult = 2}},
	
	loc_txt = {
		name = "A Splendour",
		text = {
			"All {C:diamonds}Diamonds{} in hand",
			"gain {C:mult}+#1#{} Mult",
		},
	},
	loc_vars = function(self, info_queue, card)
       	return { vars = { card.ability.extra.grant_mult } }
    end,
	sprite = "lantern",
	can_use = function(self, card)
		return #G.hand.cards > 0 
	end,
	use = function(self, card, area, copier)
    	if G.hand.cards and #G.hand.cards > 0 then
      		for i = 1, #G.hand.cards do
        		if G.hand.cards[i]:is_suit("Diamonds") then
					G.hand.cards[i].ability.perma_mult = (G.hand.cards[i].ability.perma_mult or 0) + card.ability.extra.grant_mult
      				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_upgrade_ex"), colour = G.C.RED})
             		G.E_MANAGER:add_event(Event({
                		func = function()
                		G.hand.cards[i]:juice_up(0.3, 0.4)
                		return true
            		end
            		})) 
        		end
      		end
		end
	end
}

--------------------------------------------
-- Edge - A Resolution
-- +2 Mult - Spades
--------------------------------------------
SMODS.Consumable {
	key = "edge",
	name = "A Resolution",
	slug = "edge",
	cost = 3,
	set = "occult",
	atlas = "cons",
	pos = {
		x = 2,
		y = 0,
	},
	config = {extra = {grant_mult = 2}},
	
	loc_txt = {
		name = "A Resolution",
		text = {
			"All {C:spades}Spades{} in hand",
			"gain {C:mult}+#1#{} Mult",
		},
	},
	loc_vars = function(self, info_queue, card)
       	return { vars = { card.ability.extra.grant_mult } }
    end,
	sprite = "edge",
	can_use = function(self, card)
		return #G.hand.cards > 0 
	end,
	use = function(self, card, area, copier)
    	if G.hand.cards and #G.hand.cards > 0 then
      		for i = 1, #G.hand.cards do
        		if G.hand.cards[i]:is_suit("Spades") then
					G.hand.cards[i].ability.perma_mult = (G.hand.cards[i].ability.perma_mult or 0) + card.ability.extra.grant_mult
      				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_upgrade_ex"), colour = G.C.RED})
             		G.E_MANAGER:add_event(Event({
                		func = function()
                		G.hand.cards[i]:juice_up(0.3, 0.4)
                		return true
            		end
            		})) 
        		end
      		end
		end
	end
}

--------------------------------------------
-- Winter - Perfect Frost
-- +2 Mult - Clubs
--------------------------------------------
SMODS.Consumable {
	key = "winter",
	name = "Perfect Frost",
	slug = "winter",
	cost = 3,
	set = "occult",
	atlas = "cons",
	pos = {
		x = 3,
		y = 0,
	},
	config = {extra = {grant_mult = 2}},
	
	loc_txt = {
		name = "Perfect Frost",
		text = {
			"All {C:clubs}Clubs{} in hand",
			"gain {C:mult}+#1#{} Mult",
		},
	},
	loc_vars = function(self, info_queue, card)
       	return { vars = { card.ability.extra.grant_mult } }
    end,
	sprite = "winter",
	can_use = function(self, card)
		return #G.hand.cards > 0 
	end,
	use = function(self, card, area, copier)
    	if G.hand.cards and #G.hand.cards > 0 then
      		for i = 1, #G.hand.cards do
        		if G.hand.cards[i]:is_suit("Clubs") then
					G.hand.cards[i].ability.perma_mult = (G.hand.cards[i].ability.perma_mult or 0) + card.ability.extra.grant_mult
      				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_upgrade_ex"), colour = G.C.RED})
             		G.E_MANAGER:add_event(Event({
                		func = function()
                		G.hand.cards[i]:juice_up(0.3, 0.4)
                		return true
            		end
            		})) 
        		end
      		end
		end
	end
}

--------------------------------------------
-- Grail - An Incarnadescence
-- +20 Chips - Hearts
--------------------------------------------
SMODS.Consumable {
	key = "grail",
	name = "An Incarnadescence",
	slug = "grail",
	cost = 3,
	set = "occult",
	atlas = "cons",
	pos = {
		x = 0,
		y = 1,
	},
	config = {extra = {grant_chips = 20}},
	
	loc_txt = {
		name = "An Incarnadescence",
		text = {
			"All {C:hearts}Hearts{} in hand",
			"gain {C:chips}+#1#{} Chips",
		},
	},
	loc_vars = function(self, info_queue, card)
       	return { vars = { card.ability.extra.grant_chips } }
    end,
	sprite = "grail",
	can_use = function(self, card)
		return #G.hand.cards > 0 
	end,
	use = function(self, card, area, copier)
    	if G.hand.cards and #G.hand.cards > 0 then
      		for i = 1, #G.hand.cards do
        		if G.hand.cards[i]:is_suit("Hearts") then
					G.hand.cards[i].ability.perma_bonus = (G.hand.cards[i].ability.perma_bonus or 0) + card.ability.extra.grant_chips
      				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_upgrade_ex"), colour = G.C.BLUE})
             		G.E_MANAGER:add_event(Event({
                		func = function()
                		G.hand.cards[i]:juice_up(0.3, 0.4)
                		return true
            		end
            		})) 
        		end
      		end
		end
	end
}

--------------------------------------------
-- Moth - That Old Yearning
-- +20 Chips - Diamonds
--------------------------------------------
SMODS.Consumable {
	key = "moth",
	name = "That Old Yearning",
	slug = "moth",
	cost = 3,
	set = "occult",
	atlas = "cons",
	pos = {
		x = 1,
		y = 1,
	},
	config = {extra = {grant_chips = 20}},
	
	loc_txt = {
		name = "That Old Yearning",
		text = {
			"All {C:diamonds}Diamonds{} in hand",
			"gain {C:chips}+#1#{} Chips",
		},
	},
	loc_vars = function(self, info_queue, card)
       	return { vars = { card.ability.extra.grant_chips } }
    end,
	sprite = "moth",
	can_use = function(self, card)
		return #G.hand.cards > 0 
	end,
	use = function(self, card, area, copier)
    	if G.hand.cards and #G.hand.cards > 0 then
      		for i = 1, #G.hand.cards do
        		if G.hand.cards[i]:is_suit("Diamonds") then
					G.hand.cards[i].ability.perma_bonus = (G.hand.cards[i].ability.perma_bonus or 0) + card.ability.extra.grant_chips
      				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_upgrade_ex"), colour = G.C.BLUE})
             		G.E_MANAGER:add_event(Event({
                		func = function()
                		G.hand.cards[i]:juice_up(0.3, 0.4)
                		return true
            		end
            		})) 
        		end
      		end
		end
	end
}

--------------------------------------------
-- Forge - An Incandescence
-- +20 Chips - Spades
--------------------------------------------
SMODS.Consumable {
	key = "forge",
	name = "An Incandescence",
	slug = "forge",
	cost = 3,
	set = "occult",
	atlas = "cons",
	pos = {
		x = 2,
		y = 1,
	},
	config = {extra = {grant_chips = 20}},
	
	loc_txt = {
		name = "An Incandescence",
		text = {
			"All {C:spades}Spades{} in hand",
			"gain {C:chips}+#1#{} Chips",
		},
	},
	loc_vars = function(self, info_queue, card)
       	return { vars = { card.ability.extra.grant_chips } }
    end,
	sprite = "forge",
	can_use = function(self, card)
		return #G.hand.cards > 0 
	end,
	use = function(self, card, area, copier)
    	if G.hand.cards and #G.hand.cards > 0 then
      		for i = 1, #G.hand.cards do
        		if G.hand.cards[i]:is_suit("Spades") then
					G.hand.cards[i].ability.perma_bonus = (G.hand.cards[i].ability.perma_bonus or 0) + card.ability.extra.grant_chips
      				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_upgrade_ex"), colour = G.C.BLUE})
             		G.E_MANAGER:add_event(Event({
                		func = function()
                		G.hand.cards[i]:juice_up(0.3, 0.4)
                		return true
            		end
            		})) 
        		end
      		end
		end
	end
}

--------------------------------------------
-- Knock - Wrong Door
-- +20 Chips - Clubs
--------------------------------------------
SMODS.Consumable {
	key = "knock",
	name = "Wrong Door",
	slug = "knock",
	cost = 3,
	set = "occult",
	atlas = "cons",
	pos = {
		x = 3,
		y = 1,
	},
	config = {extra = {grant_chips = 20}},
	
	loc_txt = {
		name = "Wrong Door",
		text = {
			"All {C:clubs}Clubs{} in hand",
			"gain {C:chips}+#1#{} Chips",
		},
	},
	loc_vars = function(self, info_queue, card)
       	return { vars = { card.ability.extra.grant_chips } }
    end,
	sprite = "knock",
	can_use = function(self, card)
		return #G.hand.cards > 0 
	end,
	use = function(self, card, area, copier)
    	if G.hand.cards and #G.hand.cards > 0 then
      		for i = 1, #G.hand.cards do
        		if G.hand.cards[i]:is_suit("Clubs") then
					G.hand.cards[i].ability.perma_bonus = (G.hand.cards[i].ability.perma_bonus or 0) + card.ability.extra.grant_chips
      				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_upgrade_ex"), colour = G.C.BLUE})
             		G.E_MANAGER:add_event(Event({
                		func = function()
                		G.hand.cards[i]:juice_up(0.3, 0.4)
                		return true
            		end
            		})) 
        		end
      		end
		end
	end
}


local jokers = {}

for _, joker in ipairs(jokers) do
	SMODS.Joker({
		key = joker.key,
		name = joker.name,
		slug = joker.slug,
		config = joker.config,
		pos = joker.pos,
		rarity = joker.rarity,
		cost = joker.cost,
		blueprint_compat = joker.blueprint_compat,
		eternal_compat = true,
		loc_txt = joker.loc_txt,
		loc_vars = joker.loc_vars,
		sprite = joker.sprite,
		atlas = joker.atlas,
		calculate = joker.calculate,
		calc_dollar_bonus = joker.calc_dollar_bonus,
	})
	sendInfoMessage("Registered: " .. joker.name, "tg_cultsim")
end


SMODS.Sound:register_global()

function takePercentage(number, percentage)
	return number * (percentage / 100)
end

function clamp(number, min, max)
	return math.max(min, math.min(max, number))
end

	

return MOD
