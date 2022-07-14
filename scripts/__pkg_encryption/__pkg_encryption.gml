
function rc4_cryptography(buffer, key, offset, length) {
	var i, j, s, temp, key_length, pos;
	s = array_create(256);
	key_length = string_byte_length(key);
	for(var i = 255; i >= 0; --i) {
		s[i] = i;
	}
	j = 0;
	for(var i = 0; i <= 255; ++i) {
		j = (j + s[i] + string_byte_at(key, i % key_length)) % 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
	}
	i = 0;
	j = 0;
	pos = 0;
	buffer_seek(buffer, buffer_seek_start, offset);
	repeat(length) {
		i = (i+1) % 256;
		j = (j+s[i]) % 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
		var cur_byte = buffer_peek(buffer, pos++, buffer_u8);
		buffer_write(buffer, buffer_u8, s[(s[i]+s[j]) % 256] ^ cur_byte);
	}
}
