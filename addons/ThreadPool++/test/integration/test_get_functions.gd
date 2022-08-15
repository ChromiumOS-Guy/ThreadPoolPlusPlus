extends GutTest

class Test_get_task_queue_as_immutable:
	extends GutTest
	func test_get_task_queue_as_immutable():
		var checks = 0
		if ThreadPoolManager.get_task_queue_as_immutable() == ThreadPoolManager.pool.__tasks:
			checks += 1
		if ThreadPoolManager.get_task_queue_as_immutable(false) == ThreadPoolManager.pool.__tasks:
			checks += 1
		assert_true(checks >= 2)


class Test_get_pending_queue_as_immutable:
	extends GutTest
	func test_get_pending_queue_as_immutable():
		var checks = 0
		if ThreadPoolManager.get_pending_queue_as_immutable() == ThreadPoolManager.pool.__pending:
			checks += 1
		if ThreadPoolManager.get_pending_queue_as_immutable(false) == ThreadPoolManager.pool.__pending:
			checks += 1
		assert_true(checks >= 2)


class Test_get_threads_as_immutable:
	extends GutTest
	func test_get_threads_as_immutable():
		var checks = 0
		if ThreadPoolManager.get_threads_as_immutable() == ThreadPoolManager.pool.__pool:
			checks += 1
		if ThreadPoolManager.get_threads_as_immutable(false) == ThreadPoolManager.pool.__pool:
			checks += 1
		assert_true(checks >= 2)
