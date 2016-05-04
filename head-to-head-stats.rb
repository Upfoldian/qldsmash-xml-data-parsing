require 'JSON'
require 'date'


results = JSON.parse(File.read('newFormat.json'), quirks_mode: true)

results = results["players"]

results = results.select {|player| ARGV[0] == player['playerName'] }
matchHistory = {}
results.each do |player|
	#player["resultData"] = player["resultData"].select do |result| 
	#	matchDate = Date.strptime(result["date"], "%Y-%m-%d")
	#	targetDate = Date.strptime("2016-03-01", "%Y-%m-%d")
	#	targetDate < matchDate
	#end
	ARGV[1..-1].each do |otherPlayer|

		matchesAgainst = player["matches"].select do |name|

			name["opponentName"].downcase == otherPlayer.downcase
		end
		matchHistory[otherPlayer] = matchesAgainst


	end
end
puts "==========================================================================================\n"
puts "#{ARGV[0]}'s head to head stats against #{ARGV[1]}"

stats = {:lastPlayed => {:date => "", :eventName => ""}, :lastBamStats => [], :last5WinPercent => 0, :totalWinPercent => 0}
matchHistory.each do |name, results|

	puts "#{name}:"
	if results == []
		puts "\t No tournament sets recorded between #{ARGV[0]} and #{name}"
		puts "\n==========================================================================================\n"
	else

		wins = 0
		losses = 0
		results.sort_by {|result| Date.strptime(result["date"], "%Y-%m-%d")}

		results[0..4].each do |last5|
			if last5['win'] == "true"
				wins+=1
			else
				losses+=1
			end
		end

		stats[:last5WinPercent] = (wins / (losses+wins*1.0)*100).round(2)

		wins = 0
		losses = 0

		results.each do |result|
			resultStr = ""
			if result['win'] == "true"
				wins+=1
				resultStr = "W"
			else
				losses+=1
				resultStr = "L"
			end
			#scoreStr = result['data'].strip == "-" ? "N/A" : result['data']

			if result['tournamentName'].size > 40
				result['tournamentName'] = result['tournamentName'][0..40] + "..."
			end

			puts "\t #{resultStr.ljust(4)} #{result['tournamentName'].ljust(45)} #{result['date']}"

			

			if result['tournamentName'].match("BAM")
				resultStr = result['win'] == "true" ? "W" : "L"
				stats[:lastBamStats] = stats[:lastBamStats].push({:won => resultStr})
			end


		end
		stats[:lastPlayed] = {:date => results[0]['date'], :eventName => results[0]['tournamentName']}
		stats[:totalWinPercent] = (wins/(wins+losses*1.0)*100).round(2)

		puts "\n==========================================================================================\n"
		puts "#{ARGV[0]} last played #{name} on #{stats[:lastPlayed][:date]} at #{stats[:lastPlayed][:eventName]}"

		if stats[:lastBamStats] == []
			puts "#{ARGV[0]} has not played #{name} at a BAM event on record"
		else
			puts "#{ARGV[0]} has played #{name} at a BAM event #{stats[:lastBamStats].size} times!"
		end

		puts "#{ARGV[0]} has won #{stats[:totalWinPercent]}% of sets against #{name}, however in their last 5 sets, #{ARGV[0]} has won #{stats[:last5WinPercent]}% of sets"
		puts "\n==========================================================================================\n"
	end

end