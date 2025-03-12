package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(800, 600, "odin bullets")
	for !rl.WindowShouldClose() {
		draw_game()
	}
	return
}
