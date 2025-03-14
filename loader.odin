package main

import "core:encoding/json"
import "core:fmt"
import "core:os"

MapFileWall :: struct {
	x1 : f32,
	y1 : f32,
	x2 : f32,
	y2 : f32,
	invulnerable : bool
}

MapFileBulletSpawner :: struct {
	x : f32,
	y : f32,
	spawn_frequency : f32,
	velocity : f32,
	bullet_type : BulletType,
}

MapFile :: struct {
	map_width : i32,
	map_height : i32,
	wall_thickness : f32,
	player_speed : f32,
	walls : []MapFileWall,
	bullet_spawners : []MapFileBulletSpawner,
}

load_map_file :: proc(file_name: string, state: ^State) -> bool {
	file, success := os.read_entire_file_from_filename(file_name, context.temp_allocator)
	if !success {
		fmt.println("Couldn't read map file ", file_name)
		return false
	}
	mapfile : MapFile
	json.unmarshal(file, &mapfile, allocator=context.temp_allocator)
	state.map_height = mapfile.map_height
	state.map_width = mapfile.map_width
	state.wall_thickness = mapfile.wall_thickness
	state.player_speed = mapfile.player_speed
	parse_walls(mapfile.walls, state)
	parse_spawners(mapfile.bullet_spawners, state)
	return true
}

parse_walls :: proc(walls_file: []MapFileWall, state: ^State) {
	context.allocator = state_allocator
	for wall_file in walls_file {
		wall: Wall = {
			start = {wall_file.x1, wall_file.y1},
			end   = {wall_file.x2, wall_file.y2},
			invulnerable = wall_file.invulnerable
		}
		append(&state.walls, wall)
	}
}

parse_spawners :: proc(spawners_file: []MapFileBulletSpawner, state: ^State) {
	context.allocator = state_allocator
	for spawner_file in spawners_file {
		spawner: Spawner = {
			position = {spawner_file.x, spawner_file.y},
			velocity = spawner_file.velocity,
			bullet_type = spawner_file.bullet_type,
			timer = create_timer(spawner_file.spawn_frequency)
		}
		append(&state.spawners, spawner)
	}
}
