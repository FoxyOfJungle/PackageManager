
/*-------------------------------------------------------------
	Package Manager, by FoxyOfJungle | FoxyOfJungle#0167
	License: MIT
-------------------------------------------------------------*/

enum __PACKAGE_RESOURCE_TYPE {
	_FILE,
	_BUFFER,
	_IMAGE,
	_SURFACE,
	_FONTS,
}

/*GENERATING: For creating packages and add files inside
sprites, audio, models, data (maps), texts, and others*/

function __Package(name) constructor {
	__ppf_trace("Package Created | " + string(name));
	_pkg_name = name;
	_pkg_data_buffer = buffer_create(0, buffer_grow, 1);
	_pkg_contents = [];
}

function package_create(name="") {
	return new __Package(name);
}

function package_add_file(pkg_id, name_str, file_path) {
	__ppf_exception(!variable_struct_exists(pkg_id, "_pkg_contents"), "Invalid package id");
	__ppf_exception(!file_exists(file_path), "File not found");
	__ppf_trace("- File added: " + name_str);
	var _buff = buffer_load(file_path);
	var _buffb64 = buffer_base64_encode(_buff, 0, buffer_get_size(_buff));
	var _data = {
		type : __PACKAGE_RESOURCE_TYPE._FILE,
		name : name_str,
		data : _buffb64,
		info : {
			extension : filename_ext(file_path),
		},
	}
	array_push(pkg_id._pkg_contents, _data);
}

function package_add_buffer(pkg_id, name_str, buffer) {
	__ppf_exception(!variable_struct_exists(pkg_id, "_pkg_contents"), "Invalid package id");
	__ppf_trace("- Buffer added: " + name_str);
	var _buffb64 = buffer_base64_encode(buffer, 0, buffer_get_size(buffer));
	var _data = {
		type : __PACKAGE_RESOURCE_TYPE._BUFFER,
		name : name_str,
		data : _buffb64,
		info : {},
	}
	array_push(pkg_id._pkg_contents, _data);
}

function package_add_sprite(pkg_id, name_str, sprite, img_index) {
	__ppf_exception(!variable_struct_exists(pkg_id, "_pkg_contents"), "Invalid package id");
	__ppf_trace("- Sprite added: " + name_str);
	var _ww = sprite_get_width(sprite), _hh = sprite_get_height(sprite);
	var _xof = sprite_get_xoffset(sprite), _yof = sprite_get_yoffset(sprite);
	var _image_surf = surface_create(_ww, _hh);
	surface_set_target(_image_surf);
	gpu_set_blendmode_ext(bm_one, bm_zero);
	draw_sprite(sprite, img_index, _xof, _yof);
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
	
	var _image_buff = buffer_create(_ww * _hh * 4, buffer_fixed, 1);
	buffer_get_surface(_image_buff, _image_surf, 0);
	
	var _buffb64 = buffer_base64_encode(_image_buff, 0, buffer_get_size(_image_buff));
	var _data = {
		type : __PACKAGE_RESOURCE_TYPE._IMAGE,
		name : name_str,
		data : _buffb64,
		info : {
			width : _ww,
			height : _hh,
			xoffset : _xof,
			yoffset : _yof,
		},
	}
	array_push(pkg_id._pkg_contents, _data);
	surface_free(_image_surf);
	buffer_delete(_image_buff);
}

function package_add_surface(pkg_id, name_str, surface) {
	__ppf_exception(!variable_struct_exists(pkg_id, "_pkg_contents"), "Invalid package id");
	__ppf_trace("- Surface added: " + name_str);
	var _ww = surface_get_width(surface), _hh = surface_get_height(surface);
	var _surface_buff = buffer_create(_ww * _hh * 4, buffer_fixed, 1);
	buffer_get_surface(_surface_buff, surface, 0);
	
	var _buffb64 = buffer_base64_encode(_surface_buff, 0, buffer_get_size(_surface_buff));
	var _data = {
		type : __PACKAGE_RESOURCE_TYPE._SURFACE,
		name : name_str,
		data : _buffb64,
		info : {
			width : _ww,
			height : _hh,
		},
	}
	array_push(pkg_id._pkg_contents, _data);
	buffer_delete(_surface_buff);
}

function package_add_font(pkg_id, name_str, file_path, size, bold, italic, firt_char, last_char) {
	__ppf_exception(!variable_struct_exists(pkg_id, "_pkg_contents"), "Invalid package id");
	__ppf_exception(!file_exists(file_path), "File not found");
	__ppf_trace("- Font added: " + name_str);
	var _buff = buffer_load(file_path);
	var _buffb64 = buffer_base64_encode(_buff, 0, buffer_get_size(_buff));
	var _data = {
		type : __PACKAGE_RESOURCE_TYPE._FONTS,
		name : name_str,
		data : _buffb64,
		info : {
			size : size,
			bold : bold,
			italic : italic,
			firt_char : firt_char,
			last_char : last_char,
		},
	}
	array_push(pkg_id._pkg_contents, _data);
}

function package_save(pkg_id, package_name) {
	__ppf_exception(!buffer_exists(pkg_id._pkg_data_buffer), "Invalid package id");
	var _file = PACKAGE_DATA_PATH + string(package_name) + PACKAGE_FILE_EXTENSION;
	__ppf_trace("Package \"" + _file + "\" saved");
	if file_exists(_file) file_delete(_file);
	var _buff = pkg_id._pkg_data_buffer;
	var _data = pkg_id._pkg_contents;
	buffer_write(_buff, buffer_string, json_stringify(_data));
	
	var _buff_compressed = buffer_compress(_buff, 0, buffer_get_size(_buff));
	if (PACKAGE_ENABLE_ENCRYPTION) rc4_cryptography(_buff_compressed, PACKAGE_CRYPT_KEY, 0, buffer_get_size(_buff_compressed));
	buffer_save(_buff_compressed, _file);
	buffer_delete(_buff_compressed);
}


/*LOADING: For loading existing packages and get their contents*/

function package_load(package_name) {
	_contents_data = [];
	var _file = PACKAGE_DATA_PATH + string(package_name) + PACKAGE_FILE_EXTENSION;
	if file_exists(_file) {
		var _buff_compressed = buffer_load(_file);
		if (PACKAGE_ENABLE_ENCRYPTION) rc4_cryptography(_buff_compressed, PACKAGE_CRYPT_KEY, 0, buffer_get_size(_buff_compressed));
		var _buff = buffer_decompress(_buff_compressed);
		var _json_string = buffer_read(_buff, buffer_string);
		_contents_data = json_parse(_json_string);
	} else {
		show_error("Package \"" + package_name + "\" not found", true);
		return -1;
	}
	return _contents_data;
}

function __GenerateResources(pkg_id) constructor {
	if !is_array(pkg_id) return -1;
	_contents_array = pkg_id;
	_contents_size = array_length(_contents_array);
	_current_progress = 0;
	_current_resource = "";
	_time_source_id = -1;
	
	var _generate = function() {
		_current_progress += 1;
		if (_current_progress <= _contents_size) {
			var _index = _contents_array[_current_progress-1];
			var _name = _index.name;
			var _type = _index.type;
			var _data = _index.data;
			var _info = _index.info;
			_current_resource = _index.name;
		
			// generate resource by type [all resources have a type]
			//show_debug_message(_info);
			switch(_type) {
				case __PACKAGE_RESOURCE_TYPE._FILE:
						// choose file extension
						switch(_info.extension) {
							case ".txt":
								var _buffer = buffer_base64_decode(_data);
								self[$ _name] = buffer_read(_buffer, buffer_string);
								buffer_delete(_buffer);
								break;
								
							case ".ogg":
								// I don't recommend doing this... write and save. it's just the only way to load external ogg audio :(
								var _buffer = buffer_base64_decode(_data);
								buffer_save(_buffer, PACKAGE_TEMP_PATH + "_temp_audio_buff.buff");
								self[$ _name] = audio_create_stream(PACKAGE_TEMP_PATH + "_temp_audio_buff.buff");
								buffer_delete(_buffer);
								break;
						}
					break;
				
				case __PACKAGE_RESOURCE_TYPE._BUFFER:
					var _buffer = buffer_base64_decode(_data);
					self[$ _name] = _buffer;
					break;
				
				case __PACKAGE_RESOURCE_TYPE._IMAGE:
					var _buffer = buffer_base64_decode(_data);
					var _surf = surface_create(_info.width, _info.height);
					buffer_set_surface(_buffer, _surf, 0);
					self[$ _name] = sprite_create_from_surface(_surf, 0, 0, _info.width, _info.height, false, false, _info.xoffset, _info.yoffset);
					surface_free(_surf);
					buffer_delete(_buffer);
					break;
				
				case __PACKAGE_RESOURCE_TYPE._SURFACE:
					var _buffer = buffer_base64_decode(_data);
					var _surf = surface_create(_info.width, _info.height);
					buffer_set_surface(_buffer, _surf, 0);
					self[$ _name] = _surf;
					buffer_delete(_buffer);
					break;
				
				case __PACKAGE_RESOURCE_TYPE._FONTS:
					var _buffer = buffer_base64_decode(_data);
					buffer_save(_buffer, PACKAGE_TEMP_PATH + "_temp_font_buff.buff");
					self[$ _name] = font_add(PACKAGE_TEMP_PATH + "_temp_font_buff.buff", _info.size, _info.bold, _info.italic, _info.firt_char, _info.last_char);
					buffer_delete(_buffer);
					break;
			}
		} else {
			time_source_destroy(_time_source_id);
		}
	}
	_time_source_id = time_source_create(time_source_game, PACKAGE_LOAD_SPEED, time_source_units_frames, _generate, [], _contents_size+1);
	time_source_start(_time_source_id);
}

function package_get_contents(pkg_id) {
	return new __GenerateResources(pkg_id);
}

function package_contents_get_progress(content_id) {
	__ppf_exception(!variable_struct_exists(content_id, "_current_progress"), "Invalid package content id");
	var _progress = {
		progress : clamp(content_id._current_progress / content_id._contents_size, 0, 1),
		current_resource : content_id._current_resource,
	}
	return _progress;
}

function package_contents_loaded(content_id) {
	__ppf_exception(!is_struct(content_id), "Invalid package content id");
	return (content_id._current_progress > content_id._contents_size);
}

/*-------------------------------------------------------------
	MISC: Other related functions
-------------------------------------------------------------*/

function package_destroy(pkg_id) {
	__ppf_exception(!buffer_exists(pkg_id._pkg_data_buffer), "Invalid package id");
	buffer_delete(pkg_id._pkg_data_buffer);
}

function package_remove_item(pkg_id, item_name) {
	__ppf_exception(!is_struct(pkg_id), "Invalid package id");
	var _array = pkg_id._pkg_contents;
	var _size = array_length(_array);
	for (var i = 0; i < _size; ++i) {
		if (_array[i].name == item_name) {
			__ppf_trace("Item removed: " + item_name + " (id: " + string(i) + ")");
			array_delete(pkg_id._pkg_contents, i, 1);
			break;
		}
	}
}

function package_rename_item(pkg_id, item_name, new_name) {
	__ppf_exception(!is_struct(pkg_id), "Invalid package id");
	var _array = pkg_id._pkg_contents;
	var _size = array_length(_array);
	for (var i = 0; i < _size; ++i) {
		if (_array[i].name == item_name) {
			pkg_id._pkg_contents[i].name = new_name;
			break;
		}
	}
}

function package_clean_cache() {
	if directory_exists(PACKAGE_TEMP_PATH) {
		file_delete(PACKAGE_TEMP_PATH + "_temp_font_buff.buff");
	}
}

/// @ignore
function __ppf_trace(text) {
	if (!PACKAGE_CFG_TRACE_ENABLE) exit
	show_debug_message("# PackageManager >> " + string(text));
}
/// @ignore
function __ppf_exception(condition, text) {
	if (!PACKAGE_CFG_ERROR_CHECKING_ENABLE) exit;
	if (condition) show_error("PackageManager >> " + string(text), true);
}

