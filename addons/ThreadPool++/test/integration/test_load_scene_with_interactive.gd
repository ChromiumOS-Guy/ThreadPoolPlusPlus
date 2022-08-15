extends GutTest

func test_load_scene_with_interactive():
	var result
	result = ThreadPoolManager.load_scene_with_interactive("res://addons/ThreadPool++/test/integration/test_load_scene_with_interactive.tscn","tag",false,0,0,true)
	var tick = OS.get_ticks_msec()
	while OS.get_ticks_msec() - tick < 10000:
		if result != null:
			break
	tick = OS.get_ticks_msec()
	while OS.get_ticks_msec() - tick < 10000:
		if result.progress == 100:
			break
		OS.delay_msec(1)
	assert_true(result.progress == 100)
