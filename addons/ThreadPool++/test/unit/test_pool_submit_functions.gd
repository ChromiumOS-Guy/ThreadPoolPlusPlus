extends GutTest

class Test_submit_task:
	extends GutTest
	var pool_script = load("res://addons/ThreadPool++/future_thread_pool.gd")
	var pool = null

	func before_each():
		pool = pool_script.new()
		pool.__thread_count = 0
		pool.no_timer_thread = true
		pool.__pool = pool.__create_pool()

	func __do_nothing(t):
		if t:
			return t

	func test_submit_task():
		var result = pool.submit_task(self, "__do_nothing", true ,"test_submit_task", 0, 0)
		var tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result != null:
				break
			OS.delay_msec(1)
		tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result.result != null:
				break
			OS.delay_msec(1)
		assert_true(result.result)


class Test_submit_task_as_parameter:
	extends GutTest
	var pool_script = load("res://addons/ThreadPool++/future_thread_pool.gd")
	var pool = null

	func before_each():
		pool = pool_script.new()
		pool.__thread_count = 0
		pool.no_timer_thread = true
		pool.__pool = pool.__create_pool()

	func __do_nothing(t, task):
		if t and task != null:
			return t

	func test_submit_task_as_parameter():
		var result = pool.submit_task_as_parameter(self, "__do_nothing", true ,"submit_task_as_parameter", 0, 0)
		var tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result != null:
				break
			OS.delay_msec(1)
		tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result.result != null:
				break
			OS.delay_msec(1)
		assert_true(result.result)

class Test_submit_task_unparameterized:
	extends GutTest
	var pool_script = load("res://addons/ThreadPool++/future_thread_pool.gd")
	var pool = null

	func before_each():
		pool = pool_script.new()
		pool.__thread_count = 0
		pool.no_timer_thread = true
		pool.__pool = pool.__create_pool()

	func __do_nothing():
		return true

	func test_submit_task_unparameterized():
		var result = pool.submit_task_unparameterized(self, "__do_nothing", "submit_task_unparameterized", 0, 0)
		var tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result != null:
				break
			OS.delay_msec(1)
		tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result.result != null:
				break
			OS.delay_msec(1)
		assert_true(result.result)


class Test_submit_task_as_only_parameter:
	extends GutTest
	var pool_script = load("res://addons/ThreadPool++/future_thread_pool.gd")
	var pool = null

	func before_each():
		pool = pool_script.new()
		pool.__thread_count = 0
		pool.no_timer_thread = true
		pool.__pool = pool.__create_pool()

	func __do_nothing(task):
		if task != null:
			return true

	func test_submit_task_as_only_parameter():
		var result = pool.submit_task_as_only_parameter(self, "__do_nothing", "submit_task_as_only_parameter", 0, 0)
		var tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result != null:
				break
			OS.delay_msec(1)
		tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result.result != null:
				break
			OS.delay_msec(1)
		assert_true(result.result)


class Test_submit_task_array_parameterized:
	extends GutTest
	var pool_script = load("res://addons/ThreadPool++/future_thread_pool.gd")
	var pool = null

	func before_each():
		pool = pool_script.new()
		pool.__thread_count = 0
		pool.no_timer_thread = true
		pool.__pool = pool.__create_pool()

	func __do_nothing(t, task):
		if t and task:
			return t

	func test_submit_task_array_parameterized():
		var result = pool.submit_task_array_parameterized(self, "__do_nothing", [true, true] ,"submit_task_array_parameterized", 0, 0)
		var tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result != null:
				break
			OS.delay_msec(1)
		tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result.result != null:
				break
			OS.delay_msec(1)
		assert_true(result.result)



class Test_submit_task_unparameterized_if_no_parameter:
	extends GutTest
	var pool_script = load("res://addons/ThreadPool++/future_thread_pool.gd")
	var pool = null

	func before_each():
		pool = pool_script.new()
		pool.__thread_count = 0
		pool.no_timer_thread = true
		pool.__pool = pool.__create_pool()

	func __do_nothing(t):
		if t:
			return t

	func __do_nothing2():
			return true

	func test_submit_task_unparameterized_if_no_parameter():
		var result_1 = pool.submit_task_unparameterized_if_no_parameter(self, "__do_nothing","submit_task_unparameterized_if_no_parameter", true,  0, 0)
		var tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result_1 != null:
				break
			OS.delay_msec(1)
		tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result_1.result != null:
				break
			OS.delay_msec(1)
		OS.delay_msec(10)
		var result_2 = pool.submit_task_unparameterized_if_no_parameter(self, "__do_nothing2","submit_task_unparameterized_if_no_parameter_2", null, 0, 0)
		tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result_2 != null:
				break
			OS.delay_msec(1)
		tick = OS.get_ticks_msec()
		while OS.get_ticks_msec() - tick < 1000:
			if result_2.result != null:
				break
			OS.delay_msec(1)
		
		assert_true(result_1.result and result_2.result)
