package main

import rl "vendor:raylib"

fps :: 120

bullet_radius :: 15

State :: struct {
	player:         Player,
	map_width:      i32,
	map_height:     i32,
	wall_thickness: i32,
	player_speed:   i32,
	bullets:        [dynamic]Bullet,
	walls:          [dynamic]Wall,
	spawners:       [dynamic]Spawner,
}

game_state: State

Assets :: struct {
	bullet_texture: rl.Texture2D,
}

assets: Assets

load_assets :: proc() {
	assets = {
		bullet_texture = rl.LoadTexture("assets/blue_fire15.png"),
	}
}
