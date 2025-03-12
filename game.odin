package main

import rl "vendor:raylib"

draw_game :: proc() {
	rl.BeginDrawing()
	rl.DrawTexture(assets.bullet_texture, 50, 50, rl.WHITE)
	rl.EndDrawing()
}
