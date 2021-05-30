local MAJOR, MINOR = "LibAddonCompat-1.0", 6
---@class LibAddonCompat
local LibAddonCompat = LibStub:NewLibrary(MAJOR, MINOR)
if not LibAddonCompat then return end

local GetNumSkillLines, GetSkillLineInfo = GetNumSkillLines, GetSkillLineInfo
local FindSpellBookSlotBySpellID, GetSpellBookItemTexture = FindSpellBookSlotBySpellID, GetSpellBookItemTexture
local PROFESSIONS_COOKING, PROFESSIONS_FIRST_AID, PROFESSIONS_FISHING = PROFESSIONS_COOKING, PROFESSIONS_FIRST_AID, PROFESSIONS_FISHING

LibAddonCompat.PROFESSION_FIRST_INDEX = 1
LibAddonCompat.PROFESSION_SECOND_INDEX = 2
LibAddonCompat.PROFESSION_FISHING_INDEX = 4
LibAddonCompat.PROFESSION_COOKING_INDEX = 5
LibAddonCompat.PROFESSION_FIRST_AID_INDEX = 6

local TEXTURE_COOKING = "133971"
local TEXTURE_FIRST_AID = "135966"
local TEXTURE_FISHING = "136245"
local TEXTURE_BLACKSMITHING = "136241"
local TEXTURE_LEATHERWORKING = "133611"
local TEXTURE_ALCHEMY = "136240"
local TEXTURE_HERBALISM = "136065"
local TEXTURE_MINING = "136248"
local TEXTURE_ENGINEERING = "136243"
local TEXTURE_ENCHANTING = "136244"
local TEXTURE_TAILORING = "136249"
local TEXTURE_SKINNING = "134366"

local professionsLocale = {
	[PROFESSIONS_COOKING] = TEXTURE_COOKING,
	[PROFESSIONS_FIRST_AID] = TEXTURE_FIRST_AID,
	[PROFESSIONS_FISHING] = TEXTURE_FISHING
}

function LibAddonCompat:GetProfessions()
	local professions = {
		first = nil,
		second = nil,
		cooking = nil,
		first_aid = nil,
		fishing = nil
	}

	for skillIndex = 1, GetNumSkillLines() do
		local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier,
		skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType,
		skillDescription = GetSkillLineInfo(skillIndex)

		if not isHeader then
			if isAbandonable then
				-- primary
				if not professions.first then
					professions.first = skillIndex
				else
					professions.second = skillIndex
				end
			else
				local skillNameLower = string.lower(skillName)
				if skillName == PROFESSIONS_COOKING or skillNameLower == string.lower(PROFESSIONS_COOKING) then
					professions.cooking = skillIndex
				elseif skillName == PROFESSIONS_FIRST_AID or skillNameLower == string.lower(PROFESSIONS_FIRST_AID) then
					professions.first_aid = skillIndex
				elseif skillName == PROFESSIONS_FISHING or skillNameLower == string.lower(PROFESSIONS_FISHING) then
					professions.fishing = skillIndex
				end
			end
		end
	end

	-- original: prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
	return professions.first, professions.second, nil, professions.fishing, professions.cooking, professions.first_aid
end

local function FindSpellBookSlotBySpellIDs(t)
	if not t then return end

	for i, id in ipairs(t) do
		local spellIndex = FindSpellBookSlotBySpellID(id)
		if (spellIndex) then
			return spellIndex
		end
	end
end

local function findSpellTexture(skillName)
	local texture = GetSpellBookItemTexture(skillName)
	if texture then return tostring(texture) end

	return professionsLocale[skillName] or professionsLocale[string.lower(skillName)]
end

---@private
---@class ProfInfo
---@field icon number
---@field numAbilities number
---@field spellIds number
---@field skillLine number

---@type table<string, ProfInfo>
local professionInfoTable = {
	[TEXTURE_FIRST_AID] = { numAbilities = 1, spellIds = { 3273, 3274, 7924, 10846 }, skillLine = 129 },
	[TEXTURE_BLACKSMITHING] = { numAbilities = 1, spellIds = { 2018, 3100, 3538, 9785 }, skillLine = 164 },
	[TEXTURE_LEATHERWORKING] = { numAbilities = 1, spellIds = { 2108, 3104, 3811, 10662 }, skillLine = 165 },
	[TEXTURE_ALCHEMY] = { numAbilities = 1, spellIds = { 2259, 3101, 3464, 11611 }, skillLine = 171 },
	[TEXTURE_HERBALISM] = { numAbilities = 1, spellIds = { }, skillLine = 182 },
	[TEXTURE_MINING] = { numAbilities = 2, spellIds = { 2656 }, skillLine = 186 },
	[TEXTURE_ENGINEERING] = { numAbilities = 1, spellIds = { 4036, 4037, 4038, 12656 }, skillLine = 202 },
	[TEXTURE_ENCHANTING] = { numAbilities = 1, spellIds = { 7411, 7412, 7413, 13920 }, skillLine = 333 },
	[TEXTURE_FISHING] = { numAbilities = 1, spellIds = { }, skillLine = 356 },
	[TEXTURE_COOKING] = { numAbilities = 1, spellIds = { 2550, 3102, 3413, 18260 }, skillLine = 185 },
	[TEXTURE_TAILORING] = { numAbilities = 1, spellIds = { 3908, 3909, 3910, 12180 }, skillLine = 197 },
	[TEXTURE_SKINNING] = { numAbilities = 1, spellIds = { }, skillLine = 393 },
}

function LibAddonCompat:GetProfessionInfo(skillIndex)
	local skillName, isHeader, isExpanded, skillRank, numTempPoints, skillModifier,
	skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType,
	skillDescription = GetSkillLineInfo(skillIndex)

	local texture = findSpellTexture(skillName)
	local info = professionInfoTable[texture or 0] or {}
	local spellOffset = FindSpellBookSlotBySpellIDs(info.spellIds or {})
	if spellOffset then
		spellOffset = spellOffset - 1
	end

	return skillName, texture, skillRank, skillMaxRank, info.numAbilities, spellOffset, info.skillLine, skillModifier + numTempPoints, nil, nil
end

--- Thanks to blizzard for great bodge
local locale = GetLocale()
if locale == "deDE" then
	professionsLocale["Schmiedekunst"] = TEXTURE_BLACKSMITHING
	professionsLocale["Lederverarbeitung"] = TEXTURE_LEATHERWORKING
	professionsLocale["Alchemie"] = TEXTURE_ALCHEMY
	professionsLocale["Kräuterkunde"] = TEXTURE_HERBALISM
	professionsLocale["Bergbau"] = TEXTURE_MINING
	professionsLocale["Ingenieurskunst"] = TEXTURE_ENGINEERING
	professionsLocale["Verzauberkunst"] = TEXTURE_ENCHANTING
	professionsLocale["Schneiderei"] = TEXTURE_TAILORING
	professionsLocale["Kürschnerei"] = TEXTURE_SKINNING
elseif locale == "esES" then
	professionsLocale["Herrería"] = TEXTURE_BLACKSMITHING
	professionsLocale["Peletería"] = TEXTURE_LEATHERWORKING
	professionsLocale["Alquimia"] = TEXTURE_ALCHEMY
	professionsLocale["Herboristería"] = TEXTURE_HERBALISM
	professionsLocale["Minería"] = TEXTURE_MINING
	professionsLocale["Ingeniería"] = TEXTURE_ENGINEERING
	professionsLocale["Encantamiento"] = TEXTURE_ENCHANTING
	professionsLocale["Sastrería"] = TEXTURE_TAILORING
	professionsLocale["Desuello"] = TEXTURE_SKINNING
elseif locale == "esMX" then
	professionsLocale["Herrería"] = TEXTURE_BLACKSMITHING
	professionsLocale["Peletería"] = TEXTURE_LEATHERWORKING
	professionsLocale["Alquimia"] = TEXTURE_ALCHEMY
	professionsLocale["Herboristería"] = TEXTURE_HERBALISM
	professionsLocale["Minería"] = TEXTURE_MINING
	professionsLocale["Ingeniería"] = TEXTURE_ENGINEERING
	professionsLocale["Encantamiento"] = TEXTURE_ENCHANTING
	professionsLocale["Sastrería"] = TEXTURE_TAILORING
	professionsLocale["Desuello"] = TEXTURE_SKINNING
elseif locale == "frFR" then
	professionsLocale["Forge"] = TEXTURE_BLACKSMITHING
	professionsLocale["Travail du cuir"] = TEXTURE_LEATHERWORKING
	professionsLocale["Alchimie"] = TEXTURE_ALCHEMY
	professionsLocale["Herboristerie"] = TEXTURE_HERBALISM
	professionsLocale["Minage"] = TEXTURE_MINING
	professionsLocale["Ingénierie"] = TEXTURE_ENGINEERING
	professionsLocale["Enchantement"] = TEXTURE_ENCHANTING
	professionsLocale["Couture"] = TEXTURE_TAILORING
	professionsLocale["Dépeçage"] = TEXTURE_SKINNING
elseif locale == "itIT" then
	professionsLocale["Forgiatura"] = TEXTURE_BLACKSMITHING
	professionsLocale["Conciatura"] = TEXTURE_LEATHERWORKING
	professionsLocale["Alchimia"] = TEXTURE_ALCHEMY
	professionsLocale["Erbalismo"] = TEXTURE_HERBALISM
	professionsLocale["Estrazione"] = TEXTURE_MINING
	professionsLocale["Ingegneria"] = TEXTURE_ENGINEERING
	professionsLocale["Incantamento"] = TEXTURE_ENCHANTING
	professionsLocale["Sartoria"] = TEXTURE_TAILORING
	professionsLocale["Scuoiatura"] = TEXTURE_SKINNING
elseif locale == "koKR" then
	professionsLocale["대장기술"] = TEXTURE_BLACKSMITHING
	professionsLocale["가죽세공"] = TEXTURE_LEATHERWORKING
	professionsLocale["연금술"] = TEXTURE_ALCHEMY
	professionsLocale["약초채집"] = TEXTURE_HERBALISM
	professionsLocale["채광"] = TEXTURE_MINING
	professionsLocale["기계공학"] = TEXTURE_ENGINEERING
	professionsLocale["마법부여"] = TEXTURE_ENCHANTING
	professionsLocale["재봉술"] = TEXTURE_TAILORING
	professionsLocale["무두질"] = TEXTURE_SKINNING
elseif locale == "ptBR" then
	professionsLocale["Ferraria"] = TEXTURE_BLACKSMITHING
	professionsLocale["Couraria"] = TEXTURE_LEATHERWORKING
	professionsLocale["Alquimia"] = TEXTURE_ALCHEMY
	professionsLocale["Herborismo"] = TEXTURE_HERBALISM
	professionsLocale["Mineração"] = TEXTURE_MINING
	professionsLocale["Engenharia"] = TEXTURE_ENGINEERING
	professionsLocale["Encantamento"] = TEXTURE_ENCHANTING
	professionsLocale["Alfaiataria"] = TEXTURE_TAILORING
	professionsLocale["Esfolamento"] = TEXTURE_SKINNING
elseif locale == "ruRU" then
	professionsLocale["Кузнечное дело"] = TEXTURE_BLACKSMITHING
	professionsLocale["Кожевничество"] = TEXTURE_LEATHERWORKING
	professionsLocale["Алхимия"] = TEXTURE_ALCHEMY
	professionsLocale["Травничество"] = TEXTURE_HERBALISM
	professionsLocale["Горное дело"] = TEXTURE_MINING
	professionsLocale["Инженерное дело"] = TEXTURE_ENGINEERING
	professionsLocale["Наложение чар"] = TEXTURE_ENCHANTING
	professionsLocale["Портняжное дело"] = TEXTURE_TAILORING
	professionsLocale["Снятие шкур"] = TEXTURE_SKINNING
elseif locale == "zhCN" then
	professionsLocale["锻造"] = TEXTURE_BLACKSMITHING
	professionsLocale["制皮"] = TEXTURE_LEATHERWORKING
	professionsLocale["炼金术"] = TEXTURE_ALCHEMY
	professionsLocale["草药学"] = TEXTURE_HERBALISM
	professionsLocale["采矿"] = TEXTURE_MINING
	professionsLocale["工程学"] = TEXTURE_ENGINEERING
	professionsLocale["附魔"] = TEXTURE_ENCHANTING
	professionsLocale["裁缝"] = TEXTURE_TAILORING
	professionsLocale["剥皮"] = TEXTURE_SKINNING
elseif locale == "zhTW" then
	professionsLocale["鍛造"] = TEXTURE_BLACKSMITHING
	professionsLocale["製皮"] = TEXTURE_LEATHERWORKING
	professionsLocale["鍊金術"] = TEXTURE_ALCHEMY
	professionsLocale["草藥學"] = TEXTURE_HERBALISM
	professionsLocale["採礦"] = TEXTURE_MINING
	professionsLocale["工程學"] = TEXTURE_ENGINEERING
	professionsLocale["附魔"] = TEXTURE_ENCHANTING
	professionsLocale["裁縫"] = TEXTURE_TAILORING
	professionsLocale["剝皮"] = TEXTURE_SKINNING
else
	professionsLocale["Blacksmithing"] = TEXTURE_BLACKSMITHING
	professionsLocale["Leatherworking"] = TEXTURE_LEATHERWORKING
	professionsLocale["Alchemy"] = TEXTURE_ALCHEMY
	professionsLocale["Herbalism"] = TEXTURE_HERBALISM
	professionsLocale["Mining"] = TEXTURE_MINING
	professionsLocale["Engineering"] = TEXTURE_ENGINEERING
	professionsLocale["Enchanting"] = TEXTURE_ENCHANTING
	professionsLocale["Tailoring"] = TEXTURE_TAILORING
	professionsLocale["Skinning"] = TEXTURE_SKINNING
end

local tmp = {}
for k, v in pairs(professionsLocale) do
	tmp[k] = v
	tmp[string.lower(k)] = v
end

professionsLocale = tmp
