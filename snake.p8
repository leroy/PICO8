pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
cls(0)

--[[

	variables

]]

-- tiles moved per second
snake_speed = 8
snake_direction = 1

delta = nil

tile = 8

width = 128
height = 128

snake = {}
apple = nil
is_game_over = false

x=64
y=64

rainbow_colors = {
	8, -- red
	9, -- orange
	10,-- yellow
	11,-- green
	12,-- cyan
	1, -- blue
	2,	-- purple
}

color_shift = 1

--[[

	util functions

]]
function pos(x, y)
	return {
			x = x,
			y = y
		}
end

function npos(x, y)
	return {
			x = x - x % tile,
			y = y - y % tile
		}
end

function direction_to_vec(direction)
	local vx = 0
	local vy = 0
	
 -- right
	if direction == 1 then
		vx = tile
	end
	
	-- down
	if direction == 3 then
		vy = tile
	end
	
	-- left
	if direction == 0 then
		vx = -tile
	end
	
	-- up
	if direction == 2 then
		vy = -tile
	end
	
	return pos(vx, vy)
end


--[[
	
	snake functions

]]
function grow_snake(direction)
	local tmp_snake = {}
	
	local move_vec = direction_to_vec(direction)
	
	if snake[1] == nil then
		tmp_snake[1] = npos(x,y)
	else
 	tmp_snake[1] = npos(snake[1].x,snake[1].y)
 	tmp_snake[1].x += move_vec.x
 	tmp_snake[1].y += move_vec.y
	end
	
	for i=1, #snake do
		tmp_snake[i+1] = npos(snake[i].x, snake[i].y)
	end

	snake = tmp_snake
end

function get_snake_direction(current_direction)
	local direction = current_direction;
	for i=0,3 do
 		if btn(i) then
 			direction = i
 		break
 	end
 end
 
 if current_direction == 0 and direction == 1 then
 	return current_direction
 end
 
 if current_direction == 1 and direction == 0 then
 	return current_direction
 end
 
 if current_direction == 2 and direction == 3 then
 	return current_direction
 end
 
 if current_direction == 3 and direction == 2 then
 	return current_direction
 end 
 
 return direction
end

function move_snake(direction)
	local move_vec = direction_to_vec(direction)
	
	for i=#snake, 2, -1 do
		snake[i].x = snake[i-1].x
		snake[i].y = snake[i-1].y
	end
	
	snake[1] = npos(snake[1].x + move_vec.x, snake[1].y + move_vec.y)
end

function fatal_collision()
	local position = snake[1]
	
	for i=2, #snake do
		local snakepart = snake[i]
		if position.x == snakepart.x and position.y == snakepart.y then
			return true
		end
	end
	
	if position.x > width or position.x < 0 then
		return true
	end
	
	if position.y > height or position.y < 0 then
		return true
	end
	
	return false
end

--[[

	apple functions

]]

function spawn_apple()
	local x = flr(rnd(width))
	local y = flr(rnd(height))
	
	apple = npos(x, y)
	
	printh("spawning apple at")
	printh(apple.x)
	printh(apple.y)
end

function hit_apple()
	return snake[1].x == apple.x and
								snake[1].y == apple.y
end

--[[

	game functions

]]
function gameover()
	is_game_over = true
end

function reset()
	is_game_over = false
	snake = {}
	snake_direction = 1

	print_header("new game")
	
	for i=1,3 do
		grow_snake(1)
	end
	
	spawn_apple()
end

function _init()
	reset()
end

loopcounter = 0
function _update60()
	if is_game_over then
		if btn(4) then
			reset()
		end
	
		return
	end

	delta = 1/stat(9)
	loopcounter += delta	
	
	snake_direction = get_snake_direction(snake_direction)
	
	if (loopcounter > 1/snake_speed) then
		-- timed step
 	
 	move_snake(snake_direction)
 	
 	if hit_apple() then
  	grow_snake(snake_direction)
 		spawn_apple()
 	end
 	
 	if fatal_collision() then
 		gameover()
 	end
 	
 	color_shift -= 1
 	
 	if color_shift < 0 then
 		color_shift = #rainbow_colors
 	end
 	
 	-- end timed step
 	
 	loopcounter = 0
	end
end

function _draw()
	cls()
	
	if is_game_over then
		print("game over", width / 2 - 12, height / 2)
		print("press z to continue", width / 2 - 32, height / 2 + 7)
		return
	end
	
	-- render apple
	rectfill(apple.x, apple.y, apple.x + tile - 1, apple.y + tile - 1, 8)
	
	-- render snake
	for i=1, #snake do
		local p = snake[i]
		local x = p.x-- - p.x % tile
		local y = p.y-- - p.y % tile
		
		local col_index = #rainbow_colors - (i + color_shift) % #rainbow_colors
		local col = rainbow_colors[col_index]
		
		color(col)
		rectfill(x, y, x + tile - 1, y + tile - 1)
	end
end

-->8
function print_header(name, padding)
 if (padding == nil) then
 	padding = 1
 end
 
 for i=1, padding do
 	printh("")
 end
 
 printh("  [[ " .. name .. " ]]  ")
 
 for i=1, padding do
 	printh("")
 end
end

function print_snake()
	for i=1, #snake do
		local x = snake[i].x
		local y = snake[i].y
		
		printh("["..i.."]".." ["..x..", "..y.."]")
	end
end
__sfx__
010300201485014850248500f8500d8500f850238500f8501b8500f8500f8500d8500f850228500f8501d8500f8500f8501b8500f850188500f8500d8500d8500d8500d8500f8500f850188500f8501185010850
