@tool
class_name Signals extends EditorPlugin
# Provides static convenience functions for managing multiple signals,
# similar to static helpers in other languages like JavaScript's Promise.all().


# Given a list of signals, waits until each signal has been recieved at least
# once, then returns all of the signals' return values.
static func all(signal_list: Array[Signal])->Array:
	var output = []
	# Use 'single_signal' instead of 'signal' here because 'signal' is a
	# keyword.
	for single_signal in signal_list:
		var result = await single_signal
		output.append(result)
	return output

# Given a list of signals, waits until any of them complete then returns with
# the (optional) payload from the completed signal.
static func any(signal_list: Array[Signal]):
	var listener := _AnySignalListener.new()
	for single_signal in signal_list:
		listener.add_signal(single_signal)
	var result = await listener.any_signal_received
	return result

class _AnySignalListener:
	signal any_signal_received(payload)
	var signal_list: Array[Signal] = []
	var completed := false
	
	func add_signal(single_signal: Signal):
		assert(
			!completed,
			"Cannot add signal: this any signal listener has already completed.")
		signal_list.append(single_signal)
		single_signal.connect(_on_signal)
	
	func _on_signal(payload):
		if completed: return
		any_signal_received.emit(payload)
		_disconnect_all_signals()
		completed = true
	
	func _disconnect_all_signals():
		if completed: return
		for single_signal in signal_list:
			if not single_signal.get_object(): continue
			if single_signal.is_connected(_on_signal):
				single_signal.disconnect(_on_signal)
