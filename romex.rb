# Pad the begining of the ISO format
# $ dd if=/dev/zero of=blank.iso bs=1 count=32768
#
# Look for ISO 9660 headers
# $ grep -oba CD001 Naomi1/StreetFighterZero3Upper.bin
# 3813312:CD001
# 16809985:CD001
# 16812033:CD001

# Subtract one byte so we get the ISO version, it should be 0x01 
# dd if=Naomi1/StreetFighterZero3Upper.bin skip=16809984 iflag=skip_bytes,count_bytes count=6 2>/dev/null| xxd 

# Copy the game iso out. 
# $ dd if=Naomi1/StreetFighterZero3Upper.bin skip=16809984 iflag=skip_bytes of=xxx.bin

# Usage romex.rb <infile> <outfile>

p [ARGV[0]]
blank = %x[dd status=none if=/dev/zero of=blank.iso bs=1 count=32768] 
offsets = %x[grep -oba CD001 #{ARGV[0]}]
part = 0
offsets.split("\n").each { |offset|
	part = part +1
	p "Offset: " + offset.split(":")[0]
	header = %x[dd status=none if=#{ARGV[0]} skip=#{offset.split(":")[0].to_i-1} iflag=skip_bytes,count_bytes count=6| xxd ]
	p header.split(":")[1][1..-2]
	gameexract = %x[dd status=none if=#{ARGV[0]} skip=#{offset.split(":")[0].to_i-1} iflag=skip_bytes,count_bytes of=tmp.iso]
	isoize = %x[cat blank.iso tmp.iso > #{ARGV[1]}#{part}.iso]
	fileinfo = %x[file #{ARGV[1]}#{part}.iso]
	p fileinfo
}
