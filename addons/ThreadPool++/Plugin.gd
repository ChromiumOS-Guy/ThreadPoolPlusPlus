tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("ThreadPoolManager","res://addons/ThreadPool++/thread_pool_manager.gd")


func _exit_tree():
	remove_autoload_singleton("ThreadPoolManager")
