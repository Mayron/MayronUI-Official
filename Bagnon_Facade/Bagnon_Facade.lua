--[[
Copyright 2011-2019 João Cardoso
Bagnon Facade is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Bagnon Facade.

Bagnon Facade is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Bagnon Facade is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Bagnon Facade. If not, see <http://www.gnu.org/licenses/>.
--]]

local ADDON, Addon = 'Bagnon', Bagnon
local Masque = LibStub('Masque')

for i, frameID in ipairs {'inventory', 'bank', 'guildbank', 'voidstorage'} do
	Masque:Group(ADDON, frameID .. ' - items')
	Masque:Group(ADDON, frameID .. ' - bags')
end

local Item, Bag = Addon.ItemSlot, Addon.Bag
local NewItem, FreeItem = Item.New, Item.Free
local NewBag = Bag.New

function Item:New(...)
	local button = NewItem(self, ...)
	local name = button:GetName()

	Masque:Group(ADDON, button:GetFrameID() .. ' - items'):AddButton(button, {
		Count = button.Count or _G[name .. 'Count'],
		Icon = button.icon or _G[name .. 'IconTexture'],

		Normal = button:GetNormalTexture(),
		Highlight = button:GetHighlightTexture(),
		Pushed = button:GetPushedTexture(),

		Cooldown = button.Cooldown,
		Border = button.IconGlow,
	})

	button.IconBorder:SetAlpha(0)
	return button
end

function Item:Free()
	if self:GetFrameID() then
		Masque:Group(ADDON, self:GetFrameID() .. ' - items'):RemoveButton(self)
	end

	FreeItem(self)
end

function Bag:New(...)
	local button = NewBag(self, ...)

	Masque:Group(ADDON, button:GetFrameID() .. ' - bags'):AddButton(button, {
		Count = button.Count,
		Icon = button.Icon,

		Normal = button:GetNormalTexture(),
		Highlight = button:GetHighlightTexture(),
		Pushed = button:GetPushedTexture(),
		Checked = button:GetCheckedTexture(),
	})

	return button
end
