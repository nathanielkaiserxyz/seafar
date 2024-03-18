extends MultiplayerSpawner
var count_of_players = 1

@export var PlayerScene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = spawnPlayer
	if(is_multiplayer_authority()):
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)

func spawnPlayer(data):
	var p = PlayerScene.instantiate() 
	p.set_multiplayer_authority(data)
	Globals.players[data] = p
	Globals.players[str(data)+"spawnPoint"] = str("/root/Main/Level/spawnLocations/spawn" + str(count_of_players))
	count_of_players += 1
	return p
	
func removePlayer(data):
	Globals.players[data].queue_free()
	Globals.players.erase(data)
	
 
