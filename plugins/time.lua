function run(msg, matches)
local url , res = http.request('http://api.gpmod.ir/time/')
if res ~= 200 then return "No connection" end
local jdat = json:decode(url)
local text = '*Ir Time:*`'..jdat.FAtime..'` \n* Ir Data:*`'..jdat.FAdate..'`\n    ------------\n*En Time:*_'..jdat.ENtime..'_\n*En Data:*_'..jdat.ENdate.. '_'
return text
end
return {
  patterns = {"^[/!#]([Tt][iI][Mm][Ee])$"}, 
run = run 
}

--by:@MahDiRoO