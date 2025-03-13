package main

import "core:encoding/json"
import "core:fmt"
import "core:os"

load_map_file :: proc(file_name: string, state: ^State) -> bool {
	file, success := os.read_entire_file_from_filename(file_name, context.temp_allocator)
	if !success {
		fmt.println("Couldn't read map file ", file_name)
		return false
	}
	parsed, good := json.parse(file, allocator = context.temp_allocator)
	data_object: json.Object = parsed.(json.Object)
	state.map_width = i32(data_object["map_width"].(f64))
	state.map_height = i32(data_object["map_height"].(f64))
	state.wall_thickness = f32(data_object["wall_thickness"].(f64))
	state.player_speed = f32(data_object["player_speed"].(f64))
	parse_walls(data_object["walls"], state)
	parse_spawners(data_object["bullet_spawners"], state)
	return true
}

parse_walls :: proc(walls_value: json.Value, state: ^State) {
	walls_array := walls_value.(json.Array)
	for wall_v in walls_array {
		wall_obj := wall_v.(json.Object)
		wall: Wall = {
			start = {f32(wall_obj["x1"].(f64)), f32(wall_obj["y1"].(f64))},
			end   = {f32(wall_obj["x2"].(f64)), f32(wall_obj["y2"].(f64))},
		}
		if "invulnerable" in wall_obj {
			wall.invulnerable = wall_obj["invulnerable"].(bool)
		}
		append(&state.walls, wall)
	}
}

parse_spawners :: proc(spawners_value: json.Value, state: ^State) {
	spawners_array := spawners_value.(json.Array)
	for spawner_v in spawners_array {
		spawner_obj := spawner_v.(json.Object)
		spawner: Spawner = {
			position = {f32(spawner_obj["x"].(f64)), f32(spawner_obj["y"].(f64))},
			velocity = f32(spawner_obj["velocity"].(f64)),
		}
		bullet_type_str := spawner_obj["bullet_type"].(string)
		switch bullet_type_str {
		case "bouncer":
			spawner.bullet_type = BulletType.bouncer
		case "constructor":
			spawner.bullet_type = BulletType.constructor
		case "bulldozer":
			spawner.bullet_type = BulletType.bulldozer
		}
		spawner.timer = create_timer(f32(spawner_obj["spawn_frequency"].(f64)))
		append(&state.spawners, spawner)
	}
}
