defmodule Iex.HHelper do
	@moduledoc """
	Define behaviours for modules that will backend the iex h command. 

	All of the functions for this behaviour return one of the following tuples. 

	{:found, doc_list }  - Documentation found help command prints list of {header,doc} tuples.
	{:not_found, doc_list } - Documentation not found, but should have been found by module.
	{:can_not_help, doc_list} - Module does not know how to find documentation for arguements. 

	The intent is that helpers can be stacked and the iex command can do either `:first` or `:all`
	(i.e. attempt to get help using the first helper that returns either :found or :not_found, or
	 use all the helpers regardless of return status.)
	"""

	use Behaviour 

	@doc """
	h(module) when is_atom(module)
	"""
	defcallback h(module) :: { Atom , list }
end
