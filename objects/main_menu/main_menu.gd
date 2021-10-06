extends Control

func _ready():
	pass 

func _on_play_pressed():
	get_tree().change_scene("res://objects/plot/plot.tscn")

func _on_exit_pressed():
	get_tree().quit()
