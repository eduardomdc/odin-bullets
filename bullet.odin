package main

import rl "vendor:raylib"

BulletType :: enum {
	bouncer,
	constructor,
	bulldozer,
}

Bullet :: struct {
	position: rl.Vector2,
	velocity: rl.Vector2,
	type:     BulletType,
}

update_bullets :: proc() {
	for &bullet in game_state.bullets {
		bullet.position = bullet.position + bullet.velocity * rl.GetFrameTime()
		if i32(bullet.position.x) + bullet_radius > game_state.map_width {
			bullet.velocity.x *= -1
			bullet.position.x = f32(game_state.map_width) - bullet_radius
		} else if i32(bullet.position.x) - bullet_radius < 0 {
			bullet.velocity.x *= -1
			bullet.position.x = bullet_radius
		}
		if i32(bullet.position.y) + bullet_radius > game_state.map_height {
			bullet.velocity.y *= -1
			bullet.position.y = f32(game_state.map_height) - bullet_radius
		} else if i32(bullet.position.y) - bullet_radius < 0 {
			bullet.velocity.y *= -1
			bullet.position.y = bullet_radius
		}
	}
}

draw_bullets :: proc() {
	for bullet in game_state.bullets {
		rl.DrawTexture(
			assets.bullet_texture,
			i32(bullet.position.x - bullet_radius),
			i32(bullet.position.y - bullet_radius),
			rl.WHITE,
		)
	}
}
