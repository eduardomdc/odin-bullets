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
		//move
		bullet.position = bullet.position + bullet.velocity * rl.GetFrameTime()
		//check for collision with map boundary
		if i32(bullet.position.x) + bullet_radius > game_state.map_width {
			bullet.velocity.x *= -1
			bullet.position.x = f32(game_state.map_width) - bullet_radius
			continue
		} else if i32(bullet.position.x) - bullet_radius < 0 {
			bullet.velocity.x *= -1
			bullet.position.x = bullet_radius
			continue
		}
		if i32(bullet.position.y) + bullet_radius > game_state.map_height {
			bullet.velocity.y *= -1
			bullet.position.y = f32(game_state.map_height) - bullet_radius
			continue
		} else if i32(bullet.position.y) - bullet_radius < 0 {
			bullet.velocity.y *= -1
			bullet.position.y = bullet_radius
			continue
		}
		//check for collision with walls
		for wall in game_state.walls {
			colliding := rl.CheckCollisionCircleLine(
				bullet.position,
				bullet_radius,
				wall.start,
				wall.end,
			)
			if colliding {
				start_origin_end_vector := wall.end - wall.start
				start_origin_bullet_vector := bullet.position - wall.start
				right_handed_wall_normal := rl.Vector2Normalize(
					{start_origin_end_vector.y, -start_origin_end_vector.x},
				) // start--->end, ^ rh_normal
				// check if bullet is on right or left side
				normal: rl.Vector2
				displacement := rl.Vector2DotProduct(
					start_origin_bullet_vector,
					right_handed_wall_normal,
				)
				if displacement > 0 { 	//right side
					normal = right_handed_wall_normal
				} else { 	// left side
					normal = -1 * right_handed_wall_normal
				}
				bullet.velocity -= 2 * rl.Vector2DotProduct(bullet.velocity, normal) * normal
				// displace bullet away from wall to stop secondary collisions
				bullet.position += (bullet_radius - abs(displacement)) * normal
			}
		}
	}
}

draw_bullets :: proc() {
	for bullet in game_state.bullets {
		bullet_color: rl.Color
		switch bullet.type {
		case BulletType.bouncer:
			bullet_color = rl.PINK
		case BulletType.bulldozer:
			bullet_color = rl.RED
		case BulletType.constructor:
			bullet_color = rl.GREEN
		}
		rl.DrawTexture(
			assets.bullet_texture,
			i32(bullet.position.x - bullet_radius),
			i32(bullet.position.y - bullet_radius),
			bullet_color,
		)
	}
}
