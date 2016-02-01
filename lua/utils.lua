function split(sourceString, pattern)
	local tokens = {}
 	for k, v in string.gmatch(sourceString, pattern) do
		table.insert(tokens, k)
 	end
	return tokens
end
