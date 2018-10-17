# Copyright, 2017, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'async/io'

require_relative 'generic_examples'

RSpec.describe Async::IO::Generic do
	include_context Async::RSpec::Reactor
	
	it_should_behave_like Async::IO::Generic, [
		:bytes, :chars, :codepoints, :each, :each_byte, :each_char, :each_codepoint, :each_line, :getbyte, :getc, :gets, :lineno, :lineno=, :lines, :print, :printf, :putc, :puts, :readbyte, :readchar, :readline, :readlines, :ungetbyte, :ungetc
	]
	
	let(:pipe) {IO.pipe}
	let(:input) {Async::IO::Generic.new(pipe.first)}
	let(:output) {Async::IO::Generic.new(pipe.last)}
	
	it "should send and receive data within the same reactor" do
		message = nil
		
		output_task = reactor.async do
			message = input.read(1024)
		end
		
		reactor.async do
			output.write("Hello World")
		end
		
		output_task.wait
		expect(message).to be == "Hello World"
		
		input.close
		output.close
	end
end
