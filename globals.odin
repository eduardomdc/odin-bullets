package main

import "core:mem"
import rl "vendor:raylib"

fps :: 120

bullet_radius :: 15

State :: struct {
	player:         Player,
	map_width:      i32,
	map_height:     i32,
	wall_thickness: f32,
	player_speed:   f32,
	bullets:        [dynamic]Bullet,
	walls:          [dynamic]Wall,
	spawners:       [dynamic]Spawner,
}

game_state: ^State

Assets :: struct {
	bullet_texture: rl.Texture2D,
}

assets: Assets

load_assets :: proc() {
	assets = {
		bullet_texture = rl.LoadTexture("assets/ball.png"),
	}
}

state_allocator: mem.Allocator
arena: mem.Arena
data: [1024 * 1024]byte

init_state_allocator :: proc() {
	mem.arena_init(&arena, data[:])
	state_allocator = mem.arena_allocator(&arena)
}
