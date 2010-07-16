import vim, re
from zencoding import zen_core

def get_profile_name():
	return 'xhtml'

def get_doc_type():
	return 'html'

class insertion_point_maker():
	
	def __init__(self, text=''):
		self.already_inserted = False
		if text == '':
			self.placeholder = '$1'
		else:
			p_id = 0
			while True:
				self.placeholder = '__insert' + str(p_id) + '__'
				if not self.placeholder in text:
					break

	def get_insertion_point(self, str):
		if not self.already_inserted:
			self.already_inserted = True
			return self.placeholder
		return ''

def expand_abbreviation(*l_arg, **d_arg):

	profile_name, doc_type = get_profile_name(), get_doc_type()

	cur_line = vim.current.line
	cur_index = vim.current.window.cursor[1]
	cur_line_num = vim.current.window.cursor[0] - 1

	insertion_point = insertion_point_maker()
	get_insertion_point = insertion_point.get_insertion_point
	zen_core.insertion_point = get_insertion_point
	zen_core.sub_insertion_point = get_insertion_point

	abbr, start_index = (None, None)
	if 'prompt' in d_arg and d_arg['prompt']:
		if cur_index + 1 == len(cur_line):
			cur_index += 1
		abbr = vim.eval('input("Expand abbreviation: ")')
		start_index = cur_index
	else:
		if cur_index + 1 == len(cur_line):
			cur_index += 1
			abbr, start_index = zen_core.find_abbr_in_line(cur_line, cur_index)
			if not abbr:
				cur_index -= 1
		if not abbr:
			abbr, start_index = zen_core.find_abbr_in_line(cur_line, cur_index)

	if abbr:
		result = cur_line[0:start_index] + zen_core.expand_abbreviation(abbr, doc_type, profile_name)
		if result:
			cur_line_pad = re.match(r'^(\s+)', cur_line)
			if cur_line_pad:
				result = zen_core.pad_string(result, cur_line_pad.group(1))
			vim.current.buffer[cur_line_num:cur_line_num+1] = (result.replace(insertion_point.placeholder, '', 1) + cur_line[cur_index:]).split('\n')
			if 'set_return' in d_arg and d_arg['set_return']:
				vim.command ('let l:can_replace = 1')
			for line in result.split('\n'):
				cur_line_num += 1
				pos = line.find(insertion_point.placeholder)
				if pos > -1:
					vim.current.window.cursor = (cur_line_num, pos)
					break

def wrap_with_abbreviation():
	
	profile_name, doc_type = get_profile_name(), get_doc_type()
	
	abbr = vim.eval('input("Wrap with abbreviation: ")')
	text = '\n'.join(vim.current.range[:])
	cur_line = vim.current.range[0]
	cur_line_pad = re.match(r'^(\s+)', cur_line)
	cur_line_num = vim.current.range.start
	if cur_line_pad:
		cur_line_pad_str = cur_line_pad.group(1)
		cur_line_pad_len = len(cur_line_pad_str)
		text = text[cur_line_pad_len:].split('\n')
		for line_num in range(len(text)):
			if text[line_num][0:cur_line_pad_len] == cur_line_pad_str:
				text[line_num] = text[line_num][cur_line_pad_len:]
		text = '\n'.join(text)

	insertion_point = insertion_point_maker(text)
	get_insertion_point = insertion_point.get_insertion_point
	zen_core.insertion_point = get_insertion_point
	zen_core.sub_insertion_point = get_insertion_point
	
	result = zen_core.wrap_with_abbreviation(abbr, text, doc_type, profile_name)
	if result:
		if cur_line_pad:
			result = zen_core.pad_string(result, cur_line_pad.group(1))
		result = ((cur_line_pad.group(1) if cur_line_pad else '') + result)
		vim.current.range[:] = result.replace(insertion_point.placeholder, '', 1).split('\n')
		for line in result.split('\n'):
			cur_line_num += 1
			pos = line.find(insertion_point.placeholder)
			if pos > -1:
				vim.current.window.cursor = (cur_line_num, pos - 1)
				break


