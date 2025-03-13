package main

import rl "vendor:raylib"

Wall :: struct {
	start:       rl.Vector2,
	end:         rl.Vector2,
	invulnerable: bool,
}

draw_walls :: proc() {
	for wall in game_state.walls {
		rl.DrawLineV(wall.start, wall.end, rl.RED)
	}
}
