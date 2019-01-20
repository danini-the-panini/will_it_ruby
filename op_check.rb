numerics = [1+2.i, Rational(1, 2), 1.2, 3]

ops = %i(+ - * / % ** & | ^ << >>)

ops.each do |op|
  puts "#{op},#{numerics.map(&:class).join(',')}"
  numerics.map do |n|
    puts "#{n.class.name},#{numerics.map { |m|
      if !n.respond_to?(op)
        "-"
      else
        begin
          n.send(op, m).class.name
        rescue => e
          "#{e.message}"
        end
      end
    }.join(',')}"
  end
  puts
end