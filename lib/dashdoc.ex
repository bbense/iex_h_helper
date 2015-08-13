defmodule DashDoc do
	@moduledoc """
	Stub module for testing. 
	"""

	def documentation(module) do 
		case is_elixir?(module) do
			true -> System.cmd("open", [ "dash://elixir:"<>trim(module) ])
				    { :found, [{ inspect(module), "Searching in Dash\n"}] }
			_	 -> System.cmd("open", [ "dash://erl:"<>Atom.to_string(module) ] ) 
				    { :found, [{ inspect(module), "Searching in Dash\n"}] } 
		end 
	end 

	def documentation(module, function) do 
		case is_elixir?(module) do
			true -> System.cmd("open", [ "dash://elixir:"<>trim(module)<>"."<>Atom.to_string(function) ])
				    { :found, [{ inspect(module), "Searching in Dash\n"}] }
			_	 -> System.cmd("open", [ "dash://erl:"<>Atom.to_string(module)<>":"<>Atom.to_string(function) ] ) 
				    { :found, [{ inspect(module), "Searching in Dash\n"}] } 
		end 
	end 
	
	def is_elixir?(module) do
		Atom.to_string(module) |>
		String.starts_with?("Elixir.")
	end

	def trim(module) do
		Atom.to_string(module) |>
		String.replace( ~r/^Elixir./, "")
	end 

end