extends GutTest

var pool_script = load("res://addons/ThreadPool++/future_thread_pool.gd")
var pool = null

func before_each():
	pool = pool_script.new()
	pool.__thread_count = 0
	pool.__pool = pool.__create_pool()

func test_pool_task_time_limit():
	var result = pool.submit_task_unparameterized(self, "__do_nothing", "null", 100, 0)
	var tick = OS.get_ticks_msec()
	while OS.get_ticks_msec() - tick < 10000:
		if result != null:
			break
		OS.delay_msec(1)
	OS.delay_msec(1000)
	if result.cancelled:
		assert_true(true)
	else:
		assert_true(false)

func __do_nothing():
	OS.delay_msec(2000)
