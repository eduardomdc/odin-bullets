package main

import rl "vendor:raylib"

Spawner :: struct {
	position:    rl.Vector2,
	timer:       Timer,
	velocity:    f32,
	bullet_type: BulletType,
}

update_spawners :: proc() {
	for &spawner in game_state.spawners {
		update_timer(&spawner.timer)
		if spawner.timer.ready {
			random_angle: f32 = (f32(rl.GetRandomValue(0, 1000)) / 1000) * 2 * rl.PI
			bullet: Bullet = {
				position = spawner.position,
				velocity = rl.Vector2Rotate({spawner.velocity, 0}, random_angle),
				type     = spawner.bullet_type,
			}
			append(&game_state.bullets, bullet)
			reset_timer(&spawner.timer)
		}
	}
}
