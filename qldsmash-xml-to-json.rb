require 'JSON'
require 'nokogiri'


xml = Nokogiri::XML(File.read "sample-xml-structure")

createDate =DateTime.strptime(xml.xpath("//CreatedDate").content)


eloHash = {:createDate, :gameName, :gameShort, :items => []}
