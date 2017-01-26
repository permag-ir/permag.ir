local function addword(msg, name)
    local hash = 'chat:'..msg.chat_id_..':badword'
    redis:hset(hash, name, 'newword')
    return "کلمه جدید به فیلتر کلمات اضافه شد\n🔹➕ "..name
end

local function get_badword_hash(msg)
    return 'chat:'..msg.chat_id_..':badword'
end 

local function list_badwords(msg)
	local hash = get_badword_hash(msg)
	local result=''
	if hash then
		local names = redis:hkeys(hash)
		local text = '📋لیست کلمات غیرمجاز :\n\n'
		for i=1, #names do
			result = result..'🔹 '..names[i]..'\n'
		end
		if #result>0 then
			return text..result
		else
			return'⭕️لیست کلمات غیرمجاز خالی میباشد.⭕️'
		end
	end
end

local function clear_badwords(msg, var_name) 
	local hash = get_badword_hash(msg)
	redis:del(hash, var_name)
	return '❌لیست کلمات غیرمجاز حذف شد❌'
end

local function list_badword2(msg, arg)
	local hash = get_badword_hash(msg)
	if hash then
		local names = redis:hkeys(hash)
		local text = ''
		for i=1, #names do
			if string.match(arg, names[i]) and not is_mod(msg) then
				if gp_type(chat) == "channel" then
				tdcli.deleteMessages(msg.chat_id_, {[0] = msg.id_}, dl_cb, nil)
			elseif gp_type(chat) == "chat" then
				kick_user(msg.sende_user_id_, msg.chat_id_)
			end
				return 
			end
		end
	end
end

local function clear_badword(msg, cmd_name)  
	local hash = get_badword_hash(msg)
	redis:hdel(hash, cmd_name)
	return '❌کلمه غیرمجاز '..cmd_name..' حذف شد.'
end

local function pre_process(msg)
	msg.text = msg.content_.text_
	local hash = get_badword_hash(msg)
	if hash then
		local names = redis:hkeys(hash)
		local text = ''
		for i=1, #names do
			if string.match(msg.text, names[i]) and not is_mod(msg) then
				if gp_type(chat) == "channel" then
					tdcli.deleteMessages(msg.chat_id_, {[0] = msg.id_}, dl_cb, nil)
				elseif gp_type(chat) == "chat" then
					kick_user(msg.sende_user_id_, msg.chat_id_)
				end
				return 
			end
		end
	end
end

local function run(msg, matches)
	if is_mod(msg) then
		if matches[2]:lower() == 'filter' then
			local name = string.sub(matches[3], 1, 50)
			local text = addword(msg, name)
			return text
		end
		if matches[2]:lower() == 'filterlist' then
			return list_badwords(msg)
		elseif matches[2]:lower() == 'clean' then
			local number = '1'
			return clear_badwords(msg, number)
		elseif matches[2]:lower() == 'unfilter' then
			return clear_badword(msg, matches[3])
		end
	end
end

return {
  patterns = {
	"^([!/#])([Ff][Ii][Ll][Tt][Ee][Rr]) (.*)$",
	"^([!/#])([Uu][Nn][Ff][Ii][Ll][Tt][Ee][Rr]) (.*)$",
    "^([!/#])([Ff][Ii][Ll][Tt][Ee][Rr][Ll][Ii][Ss][Tt])$",
    "^([!/#])([Cc][Ll][Ee][Aa][Nn]) ([Ff][Ii][Ll][Tt][Ee][Rr][Ll][Ii][Ss][Tt])$",
  },
  run = run, 
  pre_process = pre_process
}

-- http://permag.ir
-- @permag_ir
-- @permag_bots