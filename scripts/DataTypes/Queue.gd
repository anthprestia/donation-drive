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
	if is_empty():
		return null
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

# dequeue and return data element
func dequeue():
	# if empty, nothing to return
	if is_empty():
		return null
	var temp: QueueNode = front
	front = temp.next
	# if front is null so is the rear cuz nothing is in
	if front == null:
		rear = null
	self.queueSize -= 1
	# return data from front
	return temp.data
	
func leave_queue(data=null):
	# if empty then return null
	# we go through the whole list and remove the first instance of data = QueueNode.data
	# need prev
	# current
	# next
	
	if is_empty():
		return null
		
	var prev = null
	var current = self.front
	
	while current != null:
		var next = current.next
		# if this is the data/node we want to dequeue
		if current.data == data:
			# dequeue/connect prev with next
			# will this properly free up resources?
			if prev != null:
				prev.next = next
			else:
				# if prev is null aka this is the front
				front = current.next
			self.queueSize -= 1
			return
		# if this is not the data/node we're looking for we step over
		else:
			prev = current
			current = current.next
	self.rear = prev
	
func show_queue() -> void:
	
	var q_string = '['
	var q_data = self.front
	
	for n in self.queueSize:
		q_string += str(q_data.data) + ', '
		q_data = q_data.next
	
	q_string += ']'
	print(q_string)


class QueueNode:
	var data = null
	var next: QueueNode = null

	func _init(data) -> void:
		self.data = data
		next = null
