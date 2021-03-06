require 'spec_helper'

describe Rubex do
  test_case = 'examples'

  examples = ['rcsv'].each do |example|
    context "Case: #{test_case}/#{example}" do
      before do
        @path = path_str test_case, example
      end

      context ".ast" do
        it "generates the AST" do
          t = Rubex::Compiler.ast(@path + '.rubex')
        end
      end

      context ".compile", now: true do
        it "compiles to valid C file" do
          t,c,e = Rubex::Compiler.compile(@path + '.rubex', test: true)
        end
      end

      context "Black Box testing", now: true do
        it "compiles and checks for valid output" do
          setup_and_teardown_compiled_files(test_case, example) do |dir|
            require_relative "#{dir}/#{example}.so"

            a = Rcsv.parse(File.read('spec/fixtures/examples/rcsv.csv'), {})
            puts "\n\n\n>>>>"
            puts "#{a.inspect}"
            puts "\n\n\n<<<<"
          end
        end
      end
    end
  end
end