extends Node2D


var row_size = 10
var col_size = 3
var items = []


func _ready():
	for x in range(row_size):
		items.append([])
		
		for i in range(col_size):
			items[x].append([])
	
	items[5][2] = "Hello"
	print(items)
