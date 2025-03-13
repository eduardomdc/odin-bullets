package main

import "core:encoding/json"
import "core:fmt"
import "core:mem"
import "core:path/filepath"
import "core:strings"
import rl "vendor:raylib"

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
	init_state_allocator()
	context.allocator = state_allocator
	defer free_all(state_allocator)

	load_map_options()

	rl.InitWindow(800, 600, "odin bullets")
	defer rl.CloseWindow()
	rl.SetTargetFPS(fps)

	load_assets()

	game_state = new(State, state_allocator)
	defer free_all(state_allocator)

	for !rl.WindowShouldClose() {
		update_game()
		draw_game()
	}

	return
}
