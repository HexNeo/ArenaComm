set_wotf_emfh = {
	-- WOTF
	{ spellid = 7744, cooldown = 30 },
	-- EMFH
	{ spellid = 59752, cooldown = 90 },
}

-- Gladiator's Medallion
LCT_SpellData[336126] = {
	pvp_trinket = true,
	talent = true,
	sets_cooldowns = set_wotf_emfh,
	cooldown = 120,
  -- Manually map healer specs
  cooldown_overload = {
    [65]   = 90, -- Paladin Holy
    [105]  = 90, -- Druid Restoration
    [256]  = 90, -- Priest Disc
    [257]  = 90, -- Priest Holy
    [264]  = 90, -- Shaman Restoration
    [270]  = 90, -- Monk Mistweaver
    [1468] = 90, -- Evoker Preservation
  }
}
-- Adaptation
LCT_SpellData[336135] = {
	pvp_trinket = true,
	talent = true,
	sets_cooldowns = set_wotf_emfh,
	cooldown = 60,
	-- The cooldown used event triggers when the arena opens, maybe because of a buff or w/e.
	-- Disregard it and only use ARENA_COOLDOWNS_UPDATE
	ignore_cooldown_event = true
}
-- Relentless
LCT_SpellData[336128] = {
  pvp_trinket = true,
	talent = true,
	replaces = 208683,
	--sets_cooldown = { spellid = 7744, cooldown = 30 }
}

-- Healthstone
LCT_SpellData[6262] = {
	item = true,
	talent = true, -- hack to prevent it being displayed before being detected
	heal = true,
	cooldown = 60
}
LCT_SpellData[5512] = 6262
