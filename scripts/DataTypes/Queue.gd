class_name Queue
var front: QueueNode
var rear: QueueNode
var queueSize: int

func _init(list_to_queue: Array = []) -> void:
	front = null
	rear = null
	queueSize = 0
	
	if not list_to_queue.is_empty():
		for station in list_to_queue:
			enqueue(station)
	
func is_empty() -> bool:
	return self.front == null

func size() -> int:
	return self.queueSize
	
func get_front():
	return front.data
	
func compare_front(data):
	return front.data == data
	
func enqueue(data) -> void:
	var new_node: QueueNode = QueueNode.new(data)
	if is_empty():
		front = new_node
		rear = new_node
	else:
		rear.next = new_node
		rear = new_node
	self.queueSize += 1

func dequeue():
	if is_empty():
		return null
	var temp: QueueNode = front
	front = temp.next
	if front == null:
		rear = null
	self.queueSize -= 1
	return temp.data

class QueueNode:
	var data = null
	var next: QueueNode = null

	func _init(data) -> void:
		self.data = data
		next = null
