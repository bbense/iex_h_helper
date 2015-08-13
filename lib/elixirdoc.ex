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

	def documentation(module,function) do 
		case is_elixir?(module) do
			true -> get_doc(module,function)
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

	def get_doc(module, function) do
		docs = Code.get_docs(module, :docs)
		case docs do 
			nil -> { :not_found, [{ "#{inspect module}.#{function}", "No documentation for #{inspect module}.#{function} found\n"}] }
			_   -> find_doc(docs, module, function)
		end 
	end 

	# This only finds the first, we need to match on all arities.
	def find_doc(docs, module ,function) do
		doc = docs |> Enum.find( fn(x) -> match_function(x,function) end ) 
		case doc do 
			nil -> { :not_found, [{ "#{inspect module}.#{function}", "No documentation for #{inspect module}.#{function} found\n"}] }
			_   -> { :found, [{ "#{inspect module}.#{function}", elem(doc,4)}] }
		end 
	end 

	# Not happy about magic numbers in elem.
	defp match_function(docstring, function) do
		{func, arity} = elem(docstring,0)
		function == func 
	end 
end