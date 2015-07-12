defmodule ElixirDoc do
	@moduledoc """
	Stub module for testing. 
	"""

	def documentation(module) do 
		case is_elixir?(module) do
			true -> get_doc(module)
			_	 -> { :unknown, [{inspect( module), ""}]} 
		end 
	end 

	def is_elixir?(module) do
		Atom.to_string(module) |>
		String.starts_with?("Elixir.")
	end

	def get_doc(module) do
		{ _line, doc } = Code.get_docs(module, :moduledoc)
		case doc do 
			nil -> { :not_found, [{ inspect(module), "No moduledocs found\n"}] }
			_   -> { :found, [{ inspect(module), doc}] }
		end 
	end 
end