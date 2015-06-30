defmodule ErlangDoc do
	@moduledoc """
	Stub module for testing. 
	"""

	def documentation(module) do 
		case is_erlang?(module) do
			true -> get_doc(module)
			_	 -> { :can_not_help, [{inspect(module), "" }]} 
		end 
	end 
	
	def is_erlang?(module) do
		case is_elixir?(module) do 
			true -> false
			_    -> true
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

	def get_doc(module) do
		{ :found, [{ inspect(module), "Found the erlang man page\n"}] }
	end 

end