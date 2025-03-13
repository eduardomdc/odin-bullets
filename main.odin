package main

import "core:encoding/json"
import "core:fmt"
import "core:mem"
import rl "vendor:raylib"
import gl "vendor:raylib/rlgl"

main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	rl.InitWindow(800, 600, "odin bullets")
	defer rl.CloseWindow()
	rl.SetTargetFPS(fps)

	load_assets()
	load_map_file("maps/example.json", &game_state)

	game_state.map_height = 600
	game_state.wall_thickness = 5
	spawner: Spawner = {
		position    = {400, 300},
		timer       = create_timer(1.0),
		velocity    = 200.0,
		bullet_type = BulletType.bouncer,
	}
	append(&game_state.spawners, spawner)
	gl.SetLineWidth(game_state.wall_thickness)
	for !rl.WindowShouldClose() {
		update_game()
		draw_game()
	}
	return
}
