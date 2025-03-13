package main

import "core:encoding/json"
import "core:fmt"
import "core:mem"
import "core:path/filepath"
import "core:strings"
import rl "vendor:raylib"
import gl "vendor:raylib/rlgl"

map_files: []string
map_options_str: string

load_map_options :: proc() {
	map_files, _ = filepath.glob("maps/*.json", context.temp_allocator)
	map_options_str = ""
	for str in map_files {
		slice: []string = {map_options_str, str, ";"}
		map_options_str = strings.concatenate(slice, context.temp_allocator)
	}
}

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

	load_map_options()

	fmt.println(map_options_str)

	rl.InitWindow(800, 600, "odin bullets")
	defer rl.CloseWindow()
	rl.SetTargetFPS(fps)

	load_assets()

	game_state = new(State, context.allocator)
	defer free(game_state)

	success := load_map_file("maps/example.json", game_state)

	gl.SetLineWidth(game_state.wall_thickness)

	for !rl.WindowShouldClose() {
		update_game()
		draw_game()
	}
	return
}
