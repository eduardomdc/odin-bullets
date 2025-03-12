package main

import rl "vendor:raylib"

BulletType :: enum {
	bouncer,
	constructor,
	bulldozer,
}

Bullet :: struct {
	position: rl.Vector2,
	type:     BulletType,
}
