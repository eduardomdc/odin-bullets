package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(800, 600, "odin bullets")
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
	append(&game_state.spawners, spawner)
	for !rl.WindowShouldClose() {
		update_game()
		draw_game()
	}
	return
}
