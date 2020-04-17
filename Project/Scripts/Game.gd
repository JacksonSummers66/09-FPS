extends Spatial

func _ready():
	get_node("/root/Global").update_score(0)
