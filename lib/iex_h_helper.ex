defmodule Iex.HHelper do
	@moduledoc """
	Define behaviours for modules that will backend the iex h command. 

	All of the functions for this behaviour return one of the following tuples. 

	{:found, doc_list }  - Documentation found doc_list is a list {header,doc} tuples.
	                       in markdown format.

	{:not_found, doc_list } - Documentation not found, but could have been found by module if 
	                          it existed.
	{:can_not_help, doc_list} - Module does not know how to find documentation for arguements. 

	The intent is that helpers can be stacked and the iex command can do either `:first` or `:all`
	(i.e. attempt to get help using the first helper that returns either :found or :not_found, or
	 use all the helpers regardless of return status.)
	"""

	use Behaviour 

	@doc """
	document(module) when is_atom(module)
	"""
	defcallback document(module) :: { Atom , list }

	@doc """
	document(module,function) when is_atom(module) and is_atom(function)
	"""
	defcallback document(module,function) :: { Atom, list } 

	@doc """
     document(modules, function) when is_list(modules) and is_atom(function)
	"""
	defcallback document(module_list,function) :: {Atom, list}

	@doc """
	 document(modules, function, arity) when is_list(modules) and is_atom(function) and is_integer(arity)
	"""
	defcallback document(module_list,function,arity) :: {Atom, list}

	@doc """
	 document(module, function, arity) when is_atom(module) and is_atom(function) and is_integer(arity)
	"""
	defcallback document(module,function,arity) :: {Atom, list}

end
