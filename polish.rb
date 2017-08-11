def main
	puts "Enter an expression:"
  Converter.new.convert(gets.chomp)
end

class Converter
  NUMBERS = /[0-9]/
  WHITESPACE = /\s/

	def convert(str)
    #tokens = parse(
      #tokenize(str)
    #)

    output(
      tokenize(str)
    )
		#puts tokens
	end

	private

  def output(tokens)
    puts tokens

    current = 0
    token = tokens[current]

    walk = lambda do
      while(token[:type] != 'operation') do
        current += 1
        token = tokens[current]
      end

      begin
        if token[:type] == 'operation'
          puts "#{tokens[current-1][:value]} #{tokens[current +=1][:value]} #{token[:value]}"
        end
      rescue Exception => e
        require 'pry'; binding.pry
      end

      walk.call
    end

    walk.call
  end

  def parse(tokens)
    current = 0

    walk = lambda do
      token = tokens[current]

      if token[:type] == 'number'
        current += 1
        return { type: 'NumberLiteral', value: token[:value] }
      end

      if token[:type] == 'lparen'
        token = tokens[current += 1]

        node = {
          type: 'CallExpression',
          name: token[:value],
          params: []
        }

        while(token[:type] != 'rparen') do
          node[:params].push(walk.call);
          token = tokens[current];
        end

        current += 1

        return node
      end

      if token[:type] == 'add'
        token = tokens[current += 1]

        node = {
          type: 'CallExpression',
          name: token[:value],
          params: []
        }

        while(token[:type] != 'rparen') do
          node[:params].push(walk.call);
          token = tokens[current];
        end

        node
      end
    end

    ast = {
      type: 'Program',
      body: [],
    }

    while (current < tokens.length) do
      ast[:body].push(walk.call)
    end

    ast
  end

	def tokenize(str)
		current = 0
		tokens = []

		while (current < str.length) do
			char = str[current]

			if char == '('
				tokens << { value: char, type: 'lparen' }
				current += 1
       elsif char == ')'
         tokens << { value: char, type: 'rparen' }
         current += 1
       elsif char == '+'
         tokens << { value: char, type: 'operation' }
         current += 1
       elsif char == '-'
         tokens << { value: char, type: 'operation' }
         current += 1
       elsif char == '*'
         tokens << { value: char, type: 'operation' }
         current += 1
       elsif char == '/'
         tokens << { value: char, type: 'operation' }
         current += 1
       elsif char =~ NUMBERS
         value = ''

         while (char =~ NUMBERS) do
           value += char
           char = str[current += 1]
         end

         tokens << { value: value, type: 'number' }
       elsif char =~ WHITESPACE
         current +=1
       else
         raise 'idk man'
		  end
		end

		tokens
	end
end

main()
