pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
cls(0)

--[[

game vars

]]

width = 128
height = 128

player = {}
player.width = 16
player.height = 4
player.x = 64 - (player.width/2)
player.y = 128
player.speed = 1


ball = {}
ball.direction = 270
ball.speed = 2
ball.width = 4
ball.height = 4


--[[

functions

]]

function aabb(a, b)
	return a.x < b.x + b.width
	and a.x + a.width > b.x
	and a.y < b.y + b.height
 and a.y + a.height > b.y
end

function move_player()
	if btn(1) then
		player.x += player.speed
	end
	
	if btn(0) then
		player.x -= player.speed
	end
end

function move_ball()
	ball.x += ball.speed * cos(ball.direction / 360)
	ball.y += ball.speed * sin(ball.direction / 360)


	if ball.x < 0 or ball.x > width then
		bounce_ball()
	end
	
	if ball.y < 0 then
		bounce_ball()
	end

	if aabb(ball, player) then
		bounce_ball()
	end
end

function bounce_ball()
	ball.direction *= -1
end

function reset_ball()
	ball.x = 64
	ball.y = 64
end


--[[

game functions

]]

function _init()
	reset_ball()
end

function _update()
	move_player()
	move_ball()
end

function _draw()
	cls(0)
	rectfill(player.x, player.y, player.x + player.width, player.y - player.height, 10)
	rectfill(ball.x, ball.y, ball.x + ball.width, ball.y - ball.height, 10)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
