package main

import rl "vendor:raylib"

draw_game :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	draw_bullets()
	draw_walls()
	rl.EndDrawing()
}

update_game :: proc() {
	update_spawners()
	update_bullets()
}
