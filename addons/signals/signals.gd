@tool
class_name Signals extends EditorPlugin
# Provides static convenience functions for managing multiple signals,
# similar to static helpers in other languages like JavaScript's Promise.all().


# Given a list of signals, waits until each signal has been recieved at least
# once, then returns.
static func all(signal_list: Array[Signal]):
	pass
