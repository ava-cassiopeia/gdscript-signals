extends GutTest

# Simple class for testing the Signals helper. Emits a signal with a payload
# equal to the string provided at construction time.
class EmitSignalWithString:
	signal basic_signal(payload: String)
	
	var _emit_value := ""
	
	func _init(emit_value: String, timer: Timer):
		_emit_value = emit_value
		timer.timeout.connect(_on_timer_timeout)
	
	func _on_timer_timeout():
		basic_signal.emit(_emit_value)


func test_all__waits_for_all_signals():
	var timer1 := _create_timer(1.0)
	var timer2 := _create_timer(2.0)
	watch_signals(timer1)
	watch_signals(timer2)
	timer1.start()
	timer2.start()
	
	await Signals.all([timer1.timeout, timer2.timeout])
	
	assert_signal_emitted(timer1, 'timeout')
	assert_signal_emitted(timer2, 'timeout')
	_cleanup_timers([timer1, timer2])

func test_all__ignores_other_signals():
	var timer1 := _create_timer(1.0)
	var timer2 := _create_timer(2.0)
	watch_signals(timer1)
	watch_signals(timer2)
	timer1.start()
	timer2.start()
	
	await Signals.all([timer1.timeout])
	
	assert_signal_emitted(timer1, 'timeout')
	assert_signal_not_emitted(timer2, 'timeout')
	_cleanup_timers([timer1, timer2])

func test_all__returns_emitted_values():
	var timer1 := _create_timer(1.0)
	var timer2 := _create_timer(2.0)
	var emitter1 := EmitSignalWithString.new("First", timer1)
	var emitter2 := EmitSignalWithString.new("Second", timer2)
	watch_signals(timer1)
	watch_signals(timer2)
	watch_signals(emitter1)
	watch_signals(emitter2)
	timer1.start()
	timer2.start()
	
	var results := await Signals.all([
		emitter1.basic_signal,
		emitter2.basic_signal
	])

	assert_eq_deep(results, ["First", "Second"])
	_cleanup_timers([timer1, timer2])

func test_any__returns_emitted_value():
	var timer1 := _create_timer(1.0)
	var timer2 := _create_timer(2.0)
	var emitter1 := EmitSignalWithString.new("First", timer1)
	var emitter2 := EmitSignalWithString.new("Second", timer2)
	watch_signals(timer1)
	watch_signals(timer2)
	watch_signals(emitter1)
	watch_signals(emitter2)
	timer1.start()
	timer2.start()
	
	var result = await Signals.any([
		emitter1.basic_signal,
		emitter2.basic_signal
	])
	
	assert_signal_emitted(emitter1, "basic_signal")
	assert_signal_not_emitted(emitter2, "basic_signal")
	assert_eq(result, "First")
	_cleanup_timers([timer1, timer2])

func _create_timer(wait_time: float)->Timer:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = wait_time
	add_child(timer)
	return timer

func _cleanup_timers(timer_list: Array[Timer]):
	for timer in timer_list:
		remove_child(timer)
