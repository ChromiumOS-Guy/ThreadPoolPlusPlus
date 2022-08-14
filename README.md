# ThreadPoolPlusPlus 
A full fledged GDScript thread pool with all the features you'll (probably) need

Youtube Playlist:
https://www.youtube.com/watch?v=9Khs5F1jXp4&list=PLTgk34QEf4QVybQcZEzLNUR2XGqKu9yyA

WARNINGS:

thread_pool_manager.gd is an autoload remember to set it as such

load_scene_with_interactive() is by desgin ment to run once per time don't use in parallel if you do, expext unexpected behavor and crashes

# Goals:
1. make join more reliable

2. add unitest

# ThreadPool Features:
task time limit

variable thread count

Futures

Priority

join (suspected to not work with multiple threads at the same time please report bugs)

ThreadPoolManager.gd functions:

# # get functions:

# get_task_queue_as_immutable():
```GDScript
get_task_queue_as_immutable(immutable: bool = true)
```
if turned off it will give the task queue in mutable form not recommended

# get_pending_queue_as_immutable():
```GDScript
get_pending_queue_as_immutable(immutable: bool = true)
```
if turned off it will give the pending queue in mutable form not recommended

# get_threads_as_immutable() should only be used for debugging purposes !!!:
```GDScript
get_threads_as_immutable(immutable: bool = true)
```
if turned off it will give the thread array in mutable form really really not recommended

(DO NOT USE THIS IF YOU DON'T KNOW WHAT YOUR DOING)

# # normal functions:

# join():
```GDScript
join(identifier, by: String = "task")
```
when called will "block" the thread from doing anything until a task is finished or cancelled

use example 1: join(task)

use example 2: join("the_task_tag","task_tag")

"the_task_tag" is the the tag name to search for
, "task_tag" is to tell join you want to search by task.tag

will return err when finished err == "OK" is success , err == "OK_CANCEL" is success but task that has been joined got cancelled

# submit_task():
```GDScript
submit_task(instance: Object, method: String, parameter,task_tag : String ,time_limit : float = task_time_limit, priority:int = default_priority) 
```
submit tasks like normal,

use example: submit_task(self, "very_important_function",data,"important_task",10000,0)

"important_task" will be task.tag
, data is the method data to pass to method
, "very_important_function" is the method name
, self is the object
, 100000 is the time limit in milliseconds
, 0 is highest priority (theres no limit to lowest priority)

# submit_task_as_parameter():
```GDScript
submit_task_as_parameter(instance: Object, method: String, parameter,task_tag : String, time_limit : float = task_time_limit, priority:int = default_priority)
```
like submit_task() but gives the selected method the task as self, allowing said method to change things about its task 

method example: func said_method(userdata, task)

# submit_task_unparameterized():
```GDScript
submit_task_unparameterized(instance: Object, method: String, task_tag : String, time_limit : float = task_time_limit, priority:int = default_priority) 
```
like submit_task() but without any parameters

use example: submit_task(self, "very_important_function","important_task",10000,0)

"important_task" will be task.tag
, "very_important_function" is the method name
, self is the object
, 100000 is the time limit in milliseconds
, 0 is highest priority (theres no limit to lowest priority)

# submit_task_array_parameterized():
```GDScript
submit_task_array_parameterized(instance: Object, method: String, parameter: Array,task_tag : String, time_limit : float = task_time_limit, priority:int = default_priority)
```
like submit_task() but uses callv () instead of call()

# submit_task_as_only_parameter():
```GDScript
submit_task_as_only_parameter(instance: Object, method: String ,task_tag : String, time_limit : float = task_time_limit, priority:int = default_priority)
```
like submit_task_unparameterized() but sends task as only parameter 

method example: func said_method(task)

# submit_task_unparameterized_if_no_parameter():
```GDScript
submit_task_unparameterized_if_no_parameter(instance: Object, method: String, task_tag : String,parameter = null, time_limit : float = task_time_limit, priority:int = default_priority) 
```
like submit_task() but if parameter is equal to null it uses submit_task_unparameterized() instead of submit_task()

# load_scene_with_interactive():
```GDScript
load_scene_with_interactive(path, task_tag : String, print_to_console = true ,time_limit : float = task_time_limit, priority:int = 0) 
```
uses ResourceLoader.load_interactive() to load your scene async while also updating the task's task.progress and it returns task so you can hook it up to a loading screen

use example: load_scene_with_interactive("path_to_level.tscn","task_tag", false , 100000 , 0)

"path_to_level.tscn" is the level path
, "task_tag" is the task.tag
, false is print_to_console
, 100000 is the time limit in milliseconds
, 0 is highest priority (theres no limit to lowest priority)
