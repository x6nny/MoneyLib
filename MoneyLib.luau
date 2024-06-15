-- Module
local MoneyLib = {
    Suffixes = {"k","M","B","T","qd","Qn","sx","Sp","O","N","de","Ud","DD","tdD","qdD","QnD","sxD","SpD","OcD","NvD","Vgn","UVg","DVg","TVg","qtV","QnV","SeV","SPG","OVG","NVG","TGN","UTG","DTG","tsTG","qtTG","QnTG","ssTG","SpTG","OcTG","NoTG","QdDR","uQDR","dQDR","tQDR","qdQDR","QnQDR","sxQDR","SpQDR","OQDDr","NQDDr","qQGNT","uQGNT","dQGNT","tQGNT","qdQGNT","QnQGNT","sxQGNT","SpQGNT", "OQQGNT","NQQGNT","SXGNTL"};
    CachedShorts = {};
}

-- Private Functions
local function shorten(Input)
	local Negative = Input < 0
	Input = math.abs(Input)

	local Paired = false
	for i,v in pairs(MoneyLib.Suffixes) do
		if not (Input >= 10^(3*i)) then
			Input = Input / 10^(3*(i-1))
			local isComplex = (string.find(tostring(Input),".") and string.sub(tostring(Input),4,4) ~= ".")
			Input = string.sub(tostring(Input),1,(isComplex and 4) or 3) .. (MoneyLib.Suffixes[i-1] or "")
			Paired = true
			break;
		end
	end
	if not Paired then
		local Rounded = math.floor(Input)
		Input = tostring(Rounded)
	end

	if Negative then
		return "-"..Input
	end
	return Input
end

local function addCommas(number)
    local formattedNumber = tostring(number)
    local reversedNumber = string.reverse(formattedNumber)
    local pattern = "(%d%d%d)"

    local formattedReversedNumber = string.gsub(reversedNumber, pattern, "%1,")
    formattedNumber = string.reverse(formattedReversedNumber)

    if formattedNumber:sub(1, 1) == "," then
        formattedNumber = formattedNumber:sub(2)
    end

    return formattedNumber
end

-- Public Functions
function MoneyLib.ShortToLong(MoneyShort)
	if MoneyLib.CachedShorts[MoneyShort] ~= nil then
		return MoneyLib.CachedShorts[MoneyShort]
	end
	local result
	local eCutoff = string.find(MoneyShort,"e%+")
	if eCutoff ~= nil then
		local Coeff = tonumber(string.sub(tostring(MoneyShort),1,1))
		local Zeros = tonumber(string.sub(tostring(MoneyShort),eCutoff+2))
		result = Coeff * 10^Zeros
	else	
		for i,v in pairs(MoneyLib.Suffixes) do
			local Cutoff = string.find(MoneyShort,v)
			if Cutoff ~= nil and string.sub(MoneyShort,string.len(MoneyShort)-string.len(v)+1) == v then
				local Moneh = string.sub(MoneyShort,1,string.len(MoneyShort)-string.len(v))
				local Answer = tonumber(Moneh) * 10^(3*i)
				result = Answer
			end
		end
	end
	MoneyLib.CachedShorts[MoneyShort] = result
	return result
end

function MoneyLib.HandleMoney(Input)
	local Negative = Input < 0
	if Negative then
		return "(-$"..shorten(math.abs(Input))..")"
	end
	return "$"..shorten(Input)	
end

function MoneyLib.GetSuffix(Input)
	return shorten(Input)
end

function MoneyLib.AddCommas(Input)
    return addCommas(Input)
end

-- Return
return MoneyLib
