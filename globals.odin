package main

import rl "vendor:raylib"

State :: struct {
	player:  Player,
	bullets: [dynamic]Bullet,
	walls:   [dynamic]Wall,
}

Assets :: struct {
	bullet_texture: rl.Texture2D,
}

assets: Assets = {
	bullet_texture = rl.LoadTexture("assets/blue_fire15.png"),
}
