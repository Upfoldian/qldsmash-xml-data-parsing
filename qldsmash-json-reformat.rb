require 'JSON'
require 'nokogiri'
require 'date'
require './helpers.rb'

qldsmashData = JSON.parse(File.read('test_xml_parse.json'))

newFormatHash = {:lastUpdated => qldsmashData['createDate'], :game => qldsmashData['gameShort'], :players => []}



playerIDHash 	= Helpers.getPlayerIDHash qldsmashData
tourneyIDHash 	= Helpers.getTourneyIDHash qldsmashData
charIDHash 		= Helpers.getCharIDHash qldsmashData
regionIDHash 	= Helpers.getRegionIDHash qldsmashData


#puts playerIDHash.to_s
#puts tourneyIDHash.to_s
puts charIDHash.to_s
#puts regionIDHash.to_s

playerDataItems = qldsmashData['items']



playerDataItems.each do |item|

	playerID 	= item["playerID"]
	regionID 	= playerIDHash[playerID][:regionID].to_i
	region 		= regionIDHash[regionID][:short]
	playerName	= playerIDHash[playerID][:name]
	elo 		= item['score'].to_i
	mains 		= item['characters'].map {|char| charIDHash[char][:short]}
	
	playerInfo = {:playerName => playerName, :id => playerID, :region => region, :elo => elo, :mains => mains, :matches => []}

	puts playerInfo.to_s
end