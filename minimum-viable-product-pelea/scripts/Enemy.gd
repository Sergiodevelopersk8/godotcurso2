#res://scenes/chacarters/raul.tscn
class_name Raul
extends CharacterBody2D

var healt : int = 100

func take_damage(amount):
	healt -= amount
	print("raul recibe daño") 
	
	if healt <= 0:
		death() 
	
	

func death():
	queue_free()
