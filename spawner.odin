package main

import rl "vendor:raylib"

Spawner :: struct {
	position:        rl.Vector2,
	spawn_frequency: f32,
	velocity:        f32,
	bullet_type:     BulletType,
}
