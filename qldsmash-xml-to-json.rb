require 'JSON'
require 'nokogiri'
require 'date'

xml = Nokogiri::XML(File.read "sample-xml-structure.xml")
xml = xml.xpath("//EloXmlModel")

createDate 	= DateTime.parse(xml.xpath("CreatedDate").text).to_s
gameName 	= xml.xpath("GameName").text.strip
gameShort 	= xml.xpath("GameShort").text.strip

#puts "#{createDate}, #{gameName}, #{gameShort}" 

eloHash = {:createDate => createDate, :gameName => gameName, :gameShort => gameShort, :items => []}

xml.xpath("Items//EloItemXmlModel").each do |item|
	
	rank 				= item.xpath("Rank").text.to_i
	localRank 			= item.xpath("LocalRank").text.to_i
	score 				= item.xpath("Score").text.to_i
	rankMovement 		= item.xpath("RankMovement").text.to_i
	localRankMovement	= item.xpath("LocalRankMovement").text.to_i
	scoreMovement 		= item.xpath("ScoreMovement").text.to_i
	movements 			= []

	item.xpath("Movements/EloMovementXmlModel").each do |movement|

		oldScore 		= movement.xpath("OldScore").text.to_i
		newScore 		= movement.xpath("NewScore").text
		oppOldScore 	= movement.xpath("OpponentOldScore").text
		oppNewScore 	= movement.xpath("OpponentNewScore").text
		oppID 			= movement.xpath("OpponentID").text
		oppName 		= movement.xpath("OpponentName").text
		oppIsTagged		= movement.xpath("OpponentIsTagged").text
		tourneyID 		= movement.xpath("TourneyID").text
		eventName 		= movement.xpath("EventName").text
		playerCharImg 	= movement.xpath("PlayerCharImage").text
		isWin 			= movement.xpath("IsWin").text
		change 			= movement.xpath("Change").text
		winnerName 		= movement.xpath("WinnerName").text
		note 			= movement.xpath("Note").text


		movementHash = {:oldScore => oldScore, :newScore => newScore, :oppOldScore => oppOldScore, :oppNewScore => oppNewScore,
						:oppID => oppID, :oppName => oppName, :oppIsTagged => oppIsTagged, :tourneyID => tourneyID,
						:eventName => eventName, :playerCharImg => playerCharImg, :isWin => isWin, :change => change,
						:winnerName => winnerName, :note => note}
		#puts "#{oldScore}, #{newScore}, #{oppOldScore}, #{oppNewScore}, #{oppID}, #{oppName}, #{oppIsTagged}, #{tourneyID}"
		#puts "#{eventName}, #{playerCharImg}, #{isWin}, #{change}, #{winnerName}, #{note}"
		#puts movementHash.to_s

		movements.push movementHash

	end


	playerID 			= item.xpath("PlayerID").text.to_i
	characters 			= []


	item.xpath("Characters/int").each do |character|

		characterID 	= character.text.to_i
		characters.push characterID

	end


	hasCharacterData 	= item.xpath("HasCharacterData").text
	characterUsage 		= []


	item.xpath("CharacterUsage/EloItemCharacterUsageItem").each do |charUsage|
		
		overallCharUse 	= charUsage.xpath("OverallCharacterUsage").text.to_i
		relativeCharUse = charUsage.xpath("RelativeCharacterUsage").text.to_i
		characterID	= charUsage.xpath("CharacterID").text.to_i

		characterHash = {:overallCharUse => overallCharUse, :relativeCharUse => relativeCharUse, :characterID => characterID}
		characterUsage.push characterHash
		#puts characterHash.to_s
	end

	itemHash = {:rank => rank, :localRank => localRank, :score => score, :rankMovement => rankMovement, :localRankMovement => localRankMovement,
				:scoreMovement => scoreMovement, :movements => movements, :playerID => playerID, :characters => characters, 
				:hasCharacterData => hasCharacterData, :characterUsage => characterUsage}

	#puts itemHash.to_s

	eloHash[:items].push itemHash

end
puts eloHash.to_s
