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
	
	def is_elixir?(module) do
		module_name = Atom.to_string(module)
		String.starts_with?(module_name, "Elixir.")
	end

	def trim(module) do
		module_name = Atom.to_string(module)
		String.replace(module_name, ~r/^Elixir./, "")
	end 

end