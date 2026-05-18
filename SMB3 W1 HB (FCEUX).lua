local text_colour      = "white"
local text_move_colour = "green"
local text_back_colour = "#00000066"

local ram_Level_Tileset   = 0x70A
local ram_World_Num       = 0x727
local ram_Map_Operation   = 0x729
local ram_Random_Pool     = 0x781
local ram_Map_Entered_Y   = 0x7976
local ram_Map_Entered_X   = 0x797A
local ram_Map_Objects_Y   = 0x7EEB
local ram_Map_Objects_XLo = 0x7EF9
local ram_Map_Objects_IDs = 0x7F15

HB_X = 0xA0
HB_Y = 0x80

function code()
	if memory.readbyte(ram_World_Num) == 0 then
		if emu.framecount() < 39 then --Less than 39 frames in, hammer brothers moving is impossible
			gui.text(1, 9, "Facing?: N/A", text_colour, text_back_colour)
			gui.text(1, 18, "Moving?: N/A", text_colour, text_back_colour)
		else
			if memory.readbyte(ram_Map_Objects_IDs + 2) == 3 or memory.readbyte(ram_Map_Objects_IDs + 2) == 0xB
			or (memory.readbyte(ram_Map_Objects_XLo + 2) == 0 and memory.readbyte(ram_Map_Objects_Y + 2) == 0) then
				if memory.readbyte(ram_Map_Operation) == 0xB and PreviousMap_Operation ~= 0xB then
					colour = text_move_colour
				else
					colour = text_colour
				end
			end
			PreviousMap_Operation = memory.readbyte(ram_Map_Operation)
			
			if memory.readbyte(ram_Level_Tileset) ~= 0 or memory.readbyte(ram_Map_Operation) < 0xB then --If not in world map or before map hammer brother march operation
				if memory.readbyte(ram_Map_Entered_Y) == 0x60 and memory.readbyte(ram_Map_Entered_X) == 0x60 then --If player is in 1-F
					HB_X = 0xFF
					HB_Y = 0xFF
				else
					if memory.readbyte(ram_Map_Objects_XLo + 2) == 0xA0 and memory.readbyte(ram_Map_Objects_Y + 2) == 0x80 then
						HB_X = 0xA0
						HB_Y = 0x80
					elseif memory.readbyte(ram_Map_Objects_XLo + 2) == 0x80 and memory.readbyte(ram_Map_Objects_Y + 2) == 0x80 then
						HB_X = 0x80
						HB_Y = 0x80
					elseif memory.readbyte(ram_Map_Objects_XLo + 2) == 0x60 and memory.readbyte(ram_Map_Objects_Y + 2) == 0xA0 then
						HB_X = 0x60
						HB_Y = 0xA0
					elseif memory.readbyte(ram_Map_Objects_XLo + 2) == 0x40 and memory.readbyte(ram_Map_Objects_Y + 2) == 0x80 then
						HB_X = 0x40
						HB_Y = 0x80
					elseif memory.readbyte(ram_Map_Objects_XLo + 2) == 0x40 and memory.readbyte(ram_Map_Objects_Y + 2) == 0x60 then
						HB_X = 0x40
						HB_Y = 0x60
					end
				end
			end
			
			if memory.readbyte(ram_Map_Objects_XLo + 2) == 0 and memory.readbyte(ram_Map_Objects_Y + 2) == 0 then
				HB_X = 0xA0
				HB_Y = 0x80
			end
			
			if HB_Y == 0xFF and HB_X == 0xFF then                                --If player is in 1-F,
				gui.text(1, 9, "Facing?: ERROR", text_colour, text_back_colour)  --the facing
				gui.text(1, 18, "Moving?: ERROR", text_colour, text_back_colour) --and moving direction after completing it can't be predetermined
			else
				Facing = bit.rshift(AND(memory.readbyte(ram_Random_Pool + 8), 6), 1) --Facing direction is determined 39 frames before moving after completing numbered stages
				if Facing == 0 then
					gui.text(1, 9, "Facing?: RIGHT", text_back_colour, text_back_colour)
					gui.text(44, 9, "RIGHT", colour, "clear")
				elseif Facing == 1 then
					gui.text(1, 9, "Facing?: LEFT", text_back_colour, text_back_colour)
					gui.text(44, 9, "LEFT", colour, "clear")
				elseif Facing == 2 then
					gui.text(1, 9, "Facing?: DOWN", text_back_colour, text_back_colour)
					gui.text(44, 9, "DOWN", colour, "clear")
				else
					gui.text(1, 9, "Facing?: UP", text_back_colour, text_back_colour)
					gui.text(44, 9, "UP", colour, "clear")
				end
				gui.text(1, 9, "Facing?:", text_colour, "clear")
				
				Value = AND(memory.readbyte(ram_Random_Pool + 3), 0x83)
				if HB_X == 0xA0 and HB_Y == 0x80 then --If HB is one tile before castle/airship
					if (Facing == 0 and (Value == 0 or Value == 2 or Value == 3 or Value == 0x80))
					or (Facing ~= 1 and (Value == 1 or Value == 0x81 or Value == 0x82 or Value == 0x83)) then
						gui.text(1, 18, "Moving?: RIGHT", text_back_colour, text_back_colour)
						gui.text(44, 18, "RIGHT", colour, "clear")
					else
						gui.text(1, 18, "Moving?: LEFT", text_back_colour, text_back_colour)
						gui.text(44, 18, "LEFT", colour, "clear")
					end
				elseif HB_X == 0x60 and HB_Y == 0xA0 then --If HB is between 1-5 and 1-6
					if memory.readbyte(ram_Map_Entered_X) == 0x40 and memory.readbyte(ram_Map_Entered_Y) == 0xA0 then --If player is in 1-5
						gui.text(1, 18, "Moving?: RIGHT", text_back_colour, text_back_colour)
						gui.text(44, 18, "RIGHT", colour, "clear")
					else
						if (Facing == 0 and (Value == 0 or Value == 2 or Value == 3 or Value == 0x80))
						or (Facing ~= 1 and (Value == 1 or Value == 0x81 or Value == 0x82 or Value == 0x83)) then
							gui.text(1, 18, "Moving?: RIGHT", text_back_colour, text_back_colour)
							gui.text(44, 18, "RIGHT", colour, "clear")
						else
							gui.text(1, 18, "Moving?: LEFT", text_back_colour, text_back_colour)
							gui.text(44, 18, "LEFT", colour, "clear")
						end
					end
				elseif HB_X == 0x80 and HB_Y == 0x80 then --If HB is above 1-6
					if memory.readbyte(ram_Map_Entered_X) == 0x80 and memory.readbyte(ram_Map_Entered_Y) == 0xA0 then --If player is in 1-6
						if (Facing == 0 and (Value == 0 or Value == 2 or Value == 3 or Value == 0x80))
						or (Facing ~= 1 and (Value == 1 or Value == 0x81 or Value == 0x82 or Value == 0x83)) then
							gui.text(1, 18, "Moving?: RIGHT", text_back_colour, text_back_colour)
							gui.text(44, 18, "RIGHT", colour, "clear")
						else
							gui.text(1, 18, "Moving?: LEFT", text_back_colour, text_back_colour)
							gui.text(44, 18, "LEFT", colour, "clear")
						end
					else
						if (Facing ~= 1 and (Value == 1 or Value == 0x82 or Value == 0x83))
						or (Facing == 0 and Value == 2) or (Facing == 3 and Value == 0x81) then
							gui.text(1, 18, "Moving?: RIGHT", text_back_colour, text_back_colour)
							gui.text(44, 18, "RIGHT", colour, "clear")
						elseif (Facing == 3 and (Value == 0 or Value == 3)) or (Facing ~= 0 and (Value == 2 or Value == 0x80))
						or (Facing == 1 and (Value == 0x82 or Value == 0x83)) then
							gui.text(1, 18, "Moving?: LEFT", text_back_colour, text_back_colour)
							gui.text(44, 18, "LEFT", colour, "clear")
						else
							gui.text(1, 18, "Moving?: DOWN", text_back_colour, text_back_colour)
							gui.text(44, 18, "DOWN", colour, "clear")
						end
					end
				elseif HB_X == 0x40 and HB_Y == 0x80 then --If HB is one tile above 1-5
					if (Facing == 2 and (Value == 0 or Value == 1 or Value == 2 or Value == 0x82))
					or (Facing ~= 3 and (Value == 3 or Value == 0x80 or Value == 0x81 or Value == 0x83)) then
						gui.text(1, 18, "Moving?: DOWN", text_back_colour, text_back_colour)
						gui.text(44, 18, "DOWN", colour, "clear")
					else
						gui.text(1, 18, "Moving?: UP", text_back_colour, text_back_colour)
						gui.text(44, 18, "UP", colour, "clear")
					end
				else --HB is directly to the left of 1-F
					gui.text(1, 18, "Moving?: DOWN", text_back_colour, text_back_colour)
					gui.text(44, 18, "DOWN", colour, "clear")
				end
				gui.text(1, 18, "Moving?:", text_colour, "clear")
			end
		end
	end
end

emu.registerafter(code)