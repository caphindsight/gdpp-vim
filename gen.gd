@tool
extends SceneTree

func _init() -> void:
  var obj_classes = ""
  var ref_classes = ""
  var node_classes = ""

  for cls in ClassDB.get_class_list():
    if ClassDB.is_parent_class(cls, "RefCounted"):
      ref_classes += " " + cls
    elif ClassDB.is_parent_class(cls, "Node"):
      node_classes += " " + cls
    else:
      obj_classes += " " + cls

  var file := FileAccess.open("syntax/classes.vim", FileAccess.WRITE)
  file.store_line("syntax keyword godotObjClass" + obj_classes)
  file.store_line("syntax keyword godotRefClass" + ref_classes)
  file.store_line("syntax keyword godotNodeClass" + node_classes)
  file.close()
  quit()
