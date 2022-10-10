extends GutTest

var pool_script = load("res://addons/ThreadPool++/future_thread_pool.gd")
var pool = null

func before_each():
	pool = pool_script.new()
	pool.__thread_count = 0
	pool.__pool = pool.__create_pool()

func test_pool_join():
	var result = pool.submit_task_as_only_parameter(self, "join_nothing", "test", 0, 0)
	var result2 = pool.submit_task_as_only_parameter(self, "join_nothing", "test2", 0, 0)
	var tick = OS.get_ticks_msec()
	while OS.get_ticks_msec() - tick < 10000:
		if result != null and result2 != null:
			break
		OS.delay_msec(1)
	tick = OS.get_ticks_msec()
	while OS.get_ticks_msec() - tick < 4000:
		if result.result != null and result2.result != null:
			break
		OS.delay_msec(1)
	assert_true(true if result.result == null and result2.result == null else false)
	

func __do_nothing():
	OS.delay_msec(20000)

func join_nothing(task):
	OS.delay_msec(1000)
	var task1 = pool.submit_task_unparameterized(self, "__do_nothing", "join_test", 0, 0)
	var ta = task.__pool.join(task1)
	if ta == "OK" or ta == "OK_CANCEL":
		return true
	else:
		return false
