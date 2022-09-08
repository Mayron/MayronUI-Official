local MAJOR, MINOR = "LibAddonCompat-1.0", 13
---@class LibAddonCompat
local LibAddonCompat = LibStub:NewLibrary(MAJOR, MINOR)
if not LibAddonCompat then return end

LibAddonCompat.PROFESSION_FIRST_INDEX = 1
LibAddonCompat.PROFESSION_SECOND_INDEX = 2
LibAddonCompat.PROFESSIONS_ARCHAEOLOGY_INDEX = 3
LibAddonCompat.PROFESSION_FISHING_INDEX = 4
LibAddonCompat.PROFESSION_COOKING_INDEX = 5
LibAddonCompat.PROFESSION_FIRST_AID_INDEX = 6

if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
	function LibAddonCompat:GetProfessions()
		return GetProfessions()
	end
	function LibAddonCompat:GetProfessionInfo(skillIndex)
		return GetProfessionInfo(skillIndex)
	end

	return
end

local GetNumSkillLines, GetSkillLineInfo = GetNumSkillLines, GetSkillLineInfo
local FindSpellBookSlotBySpellID, GetSpellBookItemTexture = FindSpellBookSlotBySpellID, GetSpellBookItemTexture
local PROFESSIONS_COOKING, PROFESSIONS_FIRST_AID, PROFESSIONS_FISHING = PROFESSIONS_COOKING, PROFESSIONS_FIRST_AID, PROFESSIONS_FISHING

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
local TEXTURE_JEWELCRAFTING = { "134071", "134072" }
local TEXTURE_INSCRIPTION = "237171"

local professionsLocale = {
	[PROFESSIONS_COOKING] = TEXTURE_COOKING,
	[PROFESSIONS_FIRST_AID] = TEXTURE_FIRST_AID,
	[PROFESSIONS_FISHING] = TEXTURE_FISHING
}

if INSCRIPTION then
	professionsLocale[INSCRIPTION] = TEXTURE_INSCRIPTION
end

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

		if skillName and not isHeader then
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
local professionInfoTable = {}
setmetatable(professionInfoTable, {
	__newindex = function(t, k, v)
		if type(k) == "table" then
			for _, texture in ipairs(k) do
				professionInfoTable[texture] = v
			end
		else
			rawset(t, k, v)
		end
	end
})

professionInfoTable[TEXTURE_FIRST_AID] = { numAbilities = 1, spellIds = { 3273, 3274, 7924, 10846, 27028, 45542, 74559, 110406, 158741, 195113 }, skillLine = 129 }
professionInfoTable[TEXTURE_BLACKSMITHING] = { numAbilities = 1, spellIds = { 2018, 3100, 3538, 9785, 29844, 51300, 76666, 110396, 158737, 195097 }, skillLine = 164 }
professionInfoTable[TEXTURE_LEATHERWORKING] = { numAbilities = 1, spellIds = { 2108, 3104, 3811, 10662, 32549, 51302, 81199, 110423, 158752, 195119 }, skillLine = 165 }
professionInfoTable[TEXTURE_ALCHEMY] = { numAbilities = 1, spellIds = { 2259, 3101, 3464, 11611, 28596, 51304, 80731, 105206 }, skillLine = 171 }
professionInfoTable[TEXTURE_HERBALISM] = { numAbilities = 1, spellIds = { }, skillLine = 182 }
professionInfoTable[TEXTURE_MINING] = { numAbilities = 2, spellIds = { 2656 }, skillLine = 186 }
professionInfoTable[TEXTURE_ENGINEERING] = { numAbilities = 1, spellIds = { 4036, 4037, 4038, 12656, 30350, 51306, 82774, 110403, 158739, 195112 }, skillLine = 202 }
professionInfoTable[TEXTURE_ENCHANTING] = { numAbilities = 1, spellIds = { 7411, 7412, 7413, 13920, 28029, 51313, 74258, 110400, 158716, 195096 }, skillLine = 333 }
professionInfoTable[TEXTURE_FISHING] = { numAbilities = 1, spellIds = { }, skillLine = 356 }
professionInfoTable[TEXTURE_COOKING] = { numAbilities = 1, spellIds = { 2550, 3102, 3413, 18260, 33359, 51296, 88053, 104381, 158765, 195128 }, skillLine = 185 }
professionInfoTable[TEXTURE_TAILORING] = { numAbilities = 1, spellIds = { 3908, 3909, 3910, 12180, 26790, 51309, 75156, 110426, 158758, 195126 }, skillLine = 197 }
professionInfoTable[TEXTURE_SKINNING] = { numAbilities = 1, spellIds = { }, skillLine = 393 }
professionInfoTable[TEXTURE_JEWELCRAFTING] = { numAbilities = 2, spellIds = { 25229, 25230, 28894, 28895, 28897, 51311, 73318, 110420, 158750, 195116 }, skillLine = 755 }
professionInfoTable[TEXTURE_INSCRIPTION] = { numAbilities = 2, spellIds = { 45357, 45358, 45359, 45360, 45361, 45363, 86008, 110417, 158748, 195115 }, skillLine = 773 }

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
	professionsLocale["Juwelierskunst"] = TEXTURE_JEWELCRAFTING
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
	professionsLocale["Joyería"] = TEXTURE_JEWELCRAFTING
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
	professionsLocale["Joyería"] = TEXTURE_JEWELCRAFTING
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
	professionsLocale["Joaillerie"] = TEXTURE_JEWELCRAFTING
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
	professionsLocale["Oreficeria"] = TEXTURE_JEWELCRAFTING
elseif locale == "koKR" then
	professionsLocale["대장기술"] = TEXTURE_BLACKSMITHING
	professionsLocale["가죽세공"] = TEXTURE_LEATHERWORKING
	professionsLocale["연금술"] = TEXTURE_ALCHEMY
	professionsLocale["약초 채집"] = TEXTURE_HERBALISM
	professionsLocale["채광"] = TEXTURE_MINING
	professionsLocale["기계공학"] = TEXTURE_ENGINEERING
	professionsLocale["마법부여"] = TEXTURE_ENCHANTING
	professionsLocale["재봉술"] = TEXTURE_TAILORING
	professionsLocale["무두질"] = TEXTURE_SKINNING
	professionsLocale["보석세공"] = TEXTURE_JEWELCRAFTING
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
	professionsLocale["Joalheia"] = TEXTURE_JEWELCRAFTING
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
	professionsLocale["Ювелирное дело"] = TEXTURE_JEWELCRAFTING
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
	professionsLocale["珠宝加工"] = TEXTURE_JEWELCRAFTING
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
	professionsLocale["珠寶設計"] = TEXTURE_JEWELCRAFTING
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
	professionsLocale["Jewelcrafting"] = TEXTURE_JEWELCRAFTING
end

local tmp = {}
for k, v in pairs(professionsLocale) do
	if type(v) == "table" then
		v = v[1] -- just pick the first value for now.
	end
	tmp[k] = v
	tmp[string.lower(k)] = v
end

professionsLocale = tmp
