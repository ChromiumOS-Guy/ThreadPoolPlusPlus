extends Node
# initialization parameters 
onready var pool = FutureThreadPool.new()
onready var autoload_names = ["ThreadPoolManager"]
onready var wait = Mutex.new()


# setting parameters
var thread_count = 0 # amount of threads in thread pool
var no_timer_thread:bool = false # note if enabled task_time_limit will not work as it depends on the timer thread to actually cancel tasks
var task_time_limit:float = 100000 # in milliseconds
var default_priority: int = 100

# initialization phase
func _ready():
	__start_pool()


func __start_pool():
	pool.__thread_count = thread_count
	pool.no_timer_thread = no_timer_thread
	pool.__pool = pool.__create_pool()

# post initialization phase
func join(identifier, by: String = "task"):
	return pool.join(identifier, by)

func get_task_queue_as_immutable(immutable: bool = true):
	if immutable:
		return pool.__tasks.duplicate(false)
	else:
		return pool.__tasks

func get_pending_queue_as_immutable(immutable: bool = true):
	if immutable:
		return pool.__pending.duplicate(false)
	else:
		return pool.__pending

func get_threads_as_immutable(immutable: bool = true): # should only really be used for debugging
	if immutable:
		return pool.__pool.duplicate(false)
	else:
		print("getting_threads_when_not_immutable_is_a_really_bad_idea")
		return pool.__pool

func submit_task(instance: Object, method: String, parameter,task_tag : String ,time_limit : float = task_time_limit, priority:int = default_priority):
	return pool.submit_task(instance, method, parameter,task_tag, time_limit, priority)

func submit_task_as_parameter(instance: Object, method: String, parameter,task_tag : String, time_limit : float = task_time_limit, priority:int = default_priority):
	return pool.submit_task_as_parameter(instance, method, parameter ,task_tag, time_limit, priority)

func submit_task_unparameterized(instance: Object, method: String, task_tag : String, time_limit : float = task_time_limit, priority:int = default_priority):
	return pool.submit_task_unparameterized(instance, method ,task_tag, time_limit, priority)

func submit_task_array_parameterized(instance: Object, method: String, parameter: Array,task_tag : String, time_limit : float = task_time_limit, priority:int = default_priority):
	return pool.submit_task_array_parameterized(instance, method, parameter ,task_tag, time_limit, priority)

func submit_task_as_only_parameter(instance: Object, method: String ,task_tag : String, time_limit : float = task_time_limit, priority:int = default_priority):
	return pool.submit_task_as_only_parameter(instance, method,task_tag, time_limit , priority)

func submit_task_unparameterized_if_no_parameter(instance: Object, method: String, task_tag : String,parameter = null, time_limit : float = task_time_limit, priority:int = default_priority):
	return pool.submit_task_unparameterized_if_no_parameter(instance, method, parameter ,task_tag, time_limit, priority)

func load_scene_with_interactive(path, task_tag : String, print_to_console = true ,time_limit : float = task_time_limit, priority:int = 0):
	if path.get_extension() == "":
		print("the path provided has no file extension")
		return
	elif path.get_extension() != "tscn":
		print("the file provided is not a scene file (.tscn)")
		return
	return pool.submit_task_as_parameter(self, "__load_scene_interactive",[path, print_to_console] ,task_tag, time_limit, priority)


# execution phase
func __load_scene_interactive(data, task): # handels polling and scene switching
	if OS.can_use_threads(): # double check if platform supports aysnc (no fallback if it failes)
		wait.lock()
		var loader = ResourceLoader.load_interactive(data[0])
		var path = data[0]
		var print_to_console = data[1]
		if loader == null and task.target_argument == null: # complains about invalid paths
			print("Resource loader unable to load the resource at path")
			return
		
		while (!task.cancelled and !task.completed): # polling / loading selected scene and updating progress for loading bar
			var err = loader.poll()
			if err == ERR_FILE_EOF:
				#Loading Complete
				var resource = loader.get_resource().instance()
				task.progress = 100
				get_tree().get_root().add_child_below_node(get_tree().get_root(),resource)
				for child in get_tree().get_root().get_children(): # gets children of root and queue_free() them if they are not a singleton
					if autoload_names.has(child.get_name()): # checks if the childs name is valid for exclusion from queue_free() by looking up its name and seeing if it exist in Globals.autoload_names
						pass
					elif child == resource:
						pass
					else:
						child.queue_free()
				if print_to_console:
					print(path.get_file()," is complete!")
				break
			elif err == OK:
				#Still loading
				var progress = float(loader.get_stage())/loader.get_stage_count()
				task.progress = progress * 100
				if print_to_console:
					print(path.get_file()," is at %",progress * 100," completion!")
			else:
				print("Error while loading file") # if err isn't ERR_FILE_EOF(completed) or OK(still loading) the something Is preventing the file from loading
				break
		loader = null
		data = null
		wait.unlock()
		yield(get_tree(),"idle_frame") # makes it possible to see end result
