#!/usr/bin/env ruby

handle = File.open(ARGV[0])

# skip header
handle.gets
#!/usr/bin/env ruby
# read in numbers
rows = handle.each.collect do |line|
  line = line.strip.split("\t")
  line[1..-1].collect!{ |x| x.to_i } 
end

# transpose rows
columns = rows.transpose

# compute sdi!
sdis = columns.collect do |c|

  # get sum of column
  n = c.inject(:+).to_f

  # calculate sdi 
  -c.collect do |i|
    p = i/n
    if i == 0
      p = 1
    end
    p*Math.log(p)
  end.inject(:+)
end.collect{ |x| "%0.3f" % x  }

puts "SDI \t #{sdis.join("\t")} "
