extends Object
class_name PackGenerator

const ROOT_TAG: Array[String] = [
	"ModMetaData",
	"LanguageData"
]
enum ROOT_TAG_INDEX {
	ModMetaData,
	LanguageData
}

var needed_translate_tags: Array[String]
var maybe_children_have_needed_translate_tags: Array[String]

var dir: DirAccess
var file: FileAccess


func _init() -> void:
	var tag_rule_for_define: Dictionary = FileFunction.json_as_dictionary("res://config/tag_rule_for_define.json")
	needed_translate_tags.append_array(tag_rule_for_define.needed_translate_tags)
	maybe_children_have_needed_translate_tags.append_array(tag_rule_for_define.maybe_children_have_needed_translate_tags)


func xml_to_dic(path: String) -> Dictionary:
	var xml: XMLDocument = XML.parse_file(path)
	var root: XMLNode = xml.root
	return root.to_dict()

func define_head_tag(e: String = "utf-8") -> String:
	return "<?xml version=\"1.0\" encoding=\"%s\"?>" % [e] + "\n"

func parse_pack(path: String) -> Pack:
	if !DirAccess.dir_exists_absolute(path + "/About"):
		print("that isn't pack")
		return
	var pack: Pack = Pack.new()
	
	#define About file
	if !FileAccess.file_exists(path + "/About/About.xml"):
		print("it not has 'About' file")
		return
	var about: Pack.About = Pack.About.new()
	var about_dic: Dictionary = xml_to_dic(path + "/About/About.xml")
	var sv: Dictionary = about_dic.children.supportedVersions.children
	for index in range(sv.size()):
		about.supportedVersions.append(sv.get(sv.keys()[index]).content)
	about.packageId = about_dic.children.packageId.content
	about.name = about_dic.children.name.content
	about.description = about_dic.children.description.content
	about.author = about_dic.children.author.content
	pack.about = about
	
	#define defs directory position
	var defs: Array[Dictionary]
	var defs_dir: String
	if DirAccess.dir_exists_absolute(path + "/Common"):
		defs_dir = path + "/Common/Defs"
	else:
		var ver: float
		for hver: String in about.supportedVersions:
			if hver as float > ver:
				ver = hver as float
		defs_dir = path + "/" + str(ver) + "/Defs"
	
	#parse defs
	var def_files: Dictionary = FileFunction.get_file_list(defs_dir)
	for def_file_index in range(def_files.size()):
		var xml: XMLDocument = XML.parse_file(def_files.get(def_files.keys()[def_file_index]))
		if xml.root.name == "Defs":
			var xml_defs: Array = xml.root.to_dict_cia(false).children
			for def_dic: Dictionary in xml_defs:
				defs.append(def_dic)
	pack.defs = defs
	
	#parse class api
	var apis: Array[Dictionary]
	var api_files: Dictionary = FileFunction.get_file_list(path + "/Languages/English/Keyed")
	for api_file_index in range(api_files.size()):
		var xml: XMLDocument = XML.parse_file(api_files.get(api_files.keys()[api_file_index]))
		if xml.root.name == ROOT_TAG[ROOT_TAG_INDEX.LanguageData]:
			var api_defs: Array = xml.root.to_dict_cia(false).children
			for api_dic: Dictionary in api_defs:
				apis.append(api_dic)
	pack.apis = apis
	
	#push_error(defs)
	#dump data, it's so long
	return pack

#func def_dic_to_xml(def Dictionary) - XMLNode
	#var xml XMLNode = XMLNode.new()
	#xml.name = def.name
	#for tag Dictionary in def.children.values()
		#xml.children.append(tag_to_xml(tag))
	#
	#return xml
#
#func tag_to_xml(tag Dictionary) - XMLNode
	#var xml XMLNode = XMLNode.new()
	#xml.name = tag.name
	#if !tag.content == 
		#xml.content = tag.content
	#if !tag.children.is_empty()
		#for child Dictionary in tag.children.values()
			#xml.children.append(tag_to_xml(child))
	#
	#return xml

func def_dic_to_xml(def: Dictionary, def_name: String) -> Array[XMLNode]:
	var xmls: Array[XMLNode]
	for tag: Dictionary in def.children.values():
		var xml: XMLNode = XMLNode.new()
		xml.children.append(tag_to_xml(tag, xmls, def_name))
	#tag_to_xml(def, xmls, def_name)
	
	return xmls

func tag_to_xml(tag: Dictionary, target_array: Array[XMLNode], parent_tag: String = ""):
	var xml: XMLNode
	xml = XMLNode.new()
	xml.name = parent_tag + "." + tag.name if parent_tag != "" else tag.name
	if !tag.children.is_empty():
		for child: Dictionary in tag.children.values():
			target_array.append(tag_to_xml(child, target_array, xml.name))
	else:
		if !tag.content == "":
			xml.content = tag.content
			
			target_array.append(xml)

func child_needed_translate(tag: Dictionary) -> bool:
	if tag.keys()[0] in needed_translate_tags:
		return true
	elif !tag.values()[0].children.is_empty():
		for key: String in tag.values()[0].children.keys():
			if key in needed_translate_tags:
				return true
			
			for child_key: String in tag.values()[0].children.get(key).children.keys():
				return child_needed_translate(tag.values()[0].children.get(key).children)
	
	return false

func make_and_open(path):
	dir.make_dir_recursive(path)
	dir = DirAccess.open(path)

func pack_generator(
	packs: Array[Pack],
	meta_tags: Dictionary,
	languages: Array[String],
	project_path: String = "P:/rimworld-mtt/test"
	):
		for pack: Pack in packs:
			if !DirAccess.dir_exists_absolute(project_path):
				DirAccess.make_dir_recursive_absolute(project_path)
			dir = DirAccess.open(project_path)
			
			#About
			var about_xml: XMLNode = XMLNode.new()
			about_xml.name = ROOT_TAG[ROOT_TAG_INDEX.ModMetaData]
			for key in meta_tags.keys():
				var tag: XMLNode = XMLNode.new()
				var value = meta_tags.get(key)
				if !value is String:
					for str: String in value:
						var node: XMLNode = XMLNode.new()
						node.name = "li"
						node.content = str
						tag.children.append(node)
				elif key == "supportedVersions":
					var node: XMLNode = XMLNode.new()
					node.name = "li"
					node.content = value
					tag.children.append(node)
				else:
					tag.content = value
				tag.name = key
				about_xml.children.append(tag)
			
			make_and_open(project_path + "/About")
			file = FileAccess.open(dir.get_current_dir() + "/About.xml", FileAccess.WRITE)
			file.store_string(define_head_tag())
			file.store_string(about_xml.dump_str(true, 0, 4))
			file.flush()
			
			#Defs
			var lang_path = "/Languages/%s"
			if !pack.defs.is_empty():
				var def_types: Dictionary
				for def: Dictionary in pack.defs:
					var keep: Dictionary = {
						def.values()[0].children.defName.content: def.values()[0].duplicate(true)
						}
					keep.values()[0].children.clear()
					for key: String in def.values()[0].children.keys():
						if key in needed_translate_tags || key in maybe_children_have_needed_translate_tags:
							if !def.keys()[0] in def_types:
								def_types.merge({def.keys()[0]: []})
							
							if key in needed_translate_tags:
								keep.values()[0].children.merge({key: def.values()[0].children.get(key)})
							else:
								if child_needed_translate({key: def.values()[0].children.get(key)}):
									keep.values()[0].children.merge({key: def.values()[0].children.get(key)})
					if !keep.values()[0].children.is_empty():
						def_types.get(def.keys()[0]).append(keep)
				
				for language: String in languages:
					var def_dir_path = project_path + lang_path % language + "/DefInjected"
					make_and_open(def_dir_path)
					
					for def_type: String in def_types.keys():
						var defs_xml: XMLNode = XMLNode.new()
						defs_xml.name = ROOT_TAG[ROOT_TAG_INDEX.LanguageData]
						for def: Dictionary in def_types.get(def_type):
							defs_xml.children.append_array(def_dic_to_xml(def.values()[0], def.keys()[0]))
						
						make_and_open(def_dir_path + "/" + def_type)
						var pack_name = pack.about.name
						file = FileAccess.open(def_dir_path + "/" + def_type + "/" + pack_name + ".xml", FileAccess.WRITE)
						file.store_string(define_head_tag())
						file.store_string(defs_xml.dump_str(true, 0, 4))
						file.flush()
						#print(defs_xml.dump_str(true, 0, 4))
			
			#Class Apis
			if !pack.apis.is_empty():
				var apis_xml: XMLNode = XMLNode.new()
				apis_xml.name = ROOT_TAG[ROOT_TAG_INDEX.LanguageData]
				for dic: Dictionary in pack.apis:
					tag_to_xml(dic.values()[0], apis_xml.children)
				
				for language: String in languages:
					var api_path = project_path + lang_path % language + "/Keyed"
					make_and_open(api_path)
					
					var pack_name = pack.about.name
					file = FileAccess.open(dir.get_current_dir() + "/" + pack_name + ".xml", FileAccess.WRITE)
					file.store_string(define_head_tag())
					file.store_string(apis_xml.dump_str(true, 0, 4))
					file.flush()
