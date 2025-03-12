package main

import rl "vendor:raylib"
import gl "vendor:raylib/rlgl"

main :: proc() {
	rl.InitWindow(800, 600, "odin bullets")
	defer rl.CloseWindow()
	rl.SetTargetFPS(fps)
	load_assets()
	game_state.map_height = 600
	game_state.map_width = 800
	game_state.wall_thickness = 5
	spawner: Spawner = {
		position    = {400, 300},
		timer       = create_timer(1.0),
		velocity    = 200.0,
		bullet_type = BulletType.bouncer,
	}
	wall: Wall = {
		start = {200, 200},
		end   = {600, 322},
	}
	append(&game_state.walls, wall)
	append(&game_state.spawners, spawner)
	gl.SetLineWidth(game_state.wall_thickness)
	for !rl.WindowShouldClose() {
		update_game()
		draw_game()
	}
	return
}
