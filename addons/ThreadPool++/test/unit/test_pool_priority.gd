extends GutTest

var pool_script = load("res://addons/ThreadPool++/future_thread_pool.gd")
var pool = null
var counter = 0
var mutex : Mutex = Mutex.new()
var prioritized_task

func before_each():
	pool = pool_script.new()
	pool.__thread_count = 8
	pool.__pool = pool.__create_pool()

func test_pool_priority():
	var result
	while counter < pool.__thread_count + 5:
		pool.submit_task_as_only_parameter(self, "__do_nothing", "submit_task_unparameterized_number ("+str(counter)+")", 0, 100)
		counter += 1
	prioritized_task = pool.submit_task_as_only_parameter(self, "__do_shit", "submit_task_as_only_parameter", 0, 0)
	pool.submit_task_as_only_parameter(self, "__do_nothing", "submit_task_unparameterized_number ("+str(counter)+")", 0, 100)
	pool.submit_task_as_only_parameter(self, "__do_nothing", "submit_task_unparameterized_number ("+str(counter)+")", 0, 100)
	var task = __drain_task()
	var tick = OS.get_ticks_msec()
	while OS.get_ticks_msec() - tick < 10000:
		if prioritized_task != null and task != null:
			break
		OS.delay_msec(1)
	assert_true(prioritized_task == task)

func __do_nothing(task):
	mutex.lock()
	OS.delay_msec(2000)
	mutex.unlock()


func __drain_task():
	var result
	for task in pool.__tasks:
		if result != null:
			if task.__priority < result.__priority:
				result = task
		else:
			result = task
	return result;
