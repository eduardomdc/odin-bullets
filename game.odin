package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"
import gl "vendor:raylib/rlgl"

draw_game :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
	rl.DrawTexture(assets.background_texture, 0, 0, rl.BLUE)
	draw_bullets()
	draw_walls()
	draw_player()
	draw_ui()
	rl.EndDrawing()
}

last_selected: i32
drop_down_selected: i32
drop_down_edit: bool
drop_down_rect: rl.Rectangle = {0, 0, 200, 30}
load_button_rect: rl.Rectangle = {200, 0, 120, 30}

draw_ui :: proc() {
	mouse_pos := rl.GetMousePosition()
	if !drop_down_edit &&
	   rl.IsMouseButtonPressed(rl.MouseButton.LEFT) &&
	   rl.CheckCollisionPointRec(mouse_pos, drop_down_rect) {
		drop_down_edit = true
	}

	if rl.GuiDropdownBox(
		drop_down_rect,
		strings.clone_to_cstring(map_options_str, context.temp_allocator),
		&drop_down_selected,
		drop_down_edit,
	) {
		if (drop_down_selected != last_selected) {
			drop_down_edit = false
			last_selected = drop_down_selected
		}
	}

	if drop_down_edit &&
	   drop_down_selected != last_selected &&
	   rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
		drop_down_edit = false
	}

	if rl.GuiButton(load_button_rect, "#01#Load map") {
		load_map(drop_down_selected)
	}
	rl.GuiLabel({600,0,200,30}, fmt.caprint("Bullets :", len(game_state.bullets), allocator = context.temp_allocator))
	rl.GuiLabel({600,30,200,30}, fmt.caprint("Walls :", len(game_state.walls), allocator = context.temp_allocator))
	rl.GuiLabel({600,60,200,30}, fmt.caprint("FPS :", rl.GetFPS(), allocator = context.temp_allocator))
	rl.GuiLabel({600,90,200,30}, fmt.caprint("Frame Time :", rl.GetFrameTime(), allocator = context.temp_allocator))
	rl.GuiLabel({600,120,200,30}, fmt.caprint("Time Survived :", sw_check_time(&game_state.player_time), allocator = context.temp_allocator))
}

load_map :: proc(selected: i32) {
	free_all(state_allocator)
	game_state = new(State, state_allocator)
	success := load_map_file(map_files[selected], game_state)
	game_state.player_position = {f32(game_state.map_width/2), f32(game_state.map_height/2)}
	game_state.player_time = sw_create()
	gl.SetLineWidth(game_state.wall_thickness)
}

update_game :: proc() {
	update_spawners()
	update_bullets()
	update_player()
}

draw_player :: proc() {
	player_color := rl.RED if game_state.player_dead else rl.WHITE
	rl.DrawTexture(
		assets.player_texture,
		i32(game_state.player_position.x - player_radius),
		i32(game_state.player_position.y - player_radius),
		player_color,
	)
}

update_player :: proc(){
	input_dir : rl.Vector2
	if rl.IsKeyDown(rl.KeyboardKey.UP) {input_dir.y -= 1}
	if rl.IsKeyDown(rl.KeyboardKey.DOWN) {input_dir.y += 1}
	if rl.IsKeyDown(rl.KeyboardKey.LEFT) {input_dir.x -= 1}
	if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {input_dir.x += 1}
	input_dir = rl.Vector2Normalize(input_dir)

	using game_state; {
		move : rl.Vector2 = player_speed * input_dir * rl.GetFrameTime()

		new_position : rl.Vector2 = player_position + move

		if i32(new_position.x) + player_radius > map_width {
			new_position.x = f32(map_width) - player_radius
		} else if i32(new_position.x) - player_radius < 0 {
			new_position.x = player_radius
		}
		if i32(new_position.y) + player_radius > map_height {
			new_position.y = f32(map_height) - player_radius
		} else if i32(new_position.y) - player_radius < 0 {
			new_position.y = player_radius
		}

		for wall in walls {
			colliding := rl.CheckCollisionCircleLine(player_position, player_radius, wall.start, wall.end)
			if colliding {
				// repeated code from bullet.odin -> future function for returning normal
				start_origin_end_vector := wall.end - wall.start
				start_origin_bullet_vector := player_position - wall.start
				right_handed_wall_normal := rl.Vector2Normalize(
					{start_origin_end_vector.y, -start_origin_end_vector.x},
				) // start--->end, ^ rh_normal
				// check if player is on right or left side
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
				new_position += (player_radius-abs(displacement)) * normal
			}
		}

		player_position = new_position
	}
}