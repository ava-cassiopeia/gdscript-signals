@tool
class_name Signals extends EditorPlugin
# Provides static convenience functions for managing multiple signals,
# similar to static helpers in other languages like JavaScript's Promise.all().


# Given a list of signals, waits until each signal has been recieved at least
# once, then returns all of the signals' return values.
static func all(signal_list: Array[Signal])->Array[Object]:
	var output: Array[Object] = []
	# Use 'single_signal' instead of 'signal' here because 'signal' is a
	# keyword.
	for single_signal in signal_list:
		var result = await single_signal
		output.append(result)
	return output
