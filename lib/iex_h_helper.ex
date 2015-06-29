defmodule Iex.HHelper do
  @moduledoc """
  Define behaviours for modules that will backend the iex h command. 

  All of the functions for this behaviour return one of the following tuples. 

  {:found, doc_list }  - Documentation found doc_list is a list of {header,doc} tuples.
                         in markdown format.

  {:not_found, doc_list } - Documentation not found, but could have been found by module if 
                            it existed.
  {:can_not_help, doc_list} - Module does not know how to find documentation for arguements. 

  The intent is that helpers can be stacked and the iex command can do either `:first` or `:all`
  (i.e. attempt to get help using the first helper that returns either :found or :not_found, or
   use all the helpers regardless of return status.)
  """

  # These are for exploring, they should be configured in IEX. 
  @opts :first
  @helpers [ElixirDoc, ErlangDoc, DashDoc]

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
   document(module, function, arity) when is_atom(module) and is_atom(function) and is_integer(arity)
   """
  defcallback document(module,function,arity) :: {Atom, list}

  @doc """
  Prints the documentation for the given module.
  """
  def h(module) when is_atom(module) do
    case Code.ensure_loaded(module) do
      {:module, _} ->
        Iex.HHelper.get_docs(module, @helpers, @opts) |>
        Enum.map( fn { _status, {header, doc}} -> print_doc(header, doc) end )
      {:error, reason} ->
        puts_error("Could not load module #{inspect module}, got: #{reason}")
    end
    dont_display_result
  end

  def h(_) do
    puts_error("Invalid arguments for h helper")
    dont_display_result
  end

  @doc """
  Prints the documentation for the given function
  with any arity in the list of modules.
  """
  def h(modules, function) when is_list(modules) and is_atom(function) do
    result =
      Enum.find_value modules, false, fn module ->
        h_mod_fun(module, function) == :ok
      end

    unless result, do: nodocs(function)

    dont_display_result
  end

  def h(module, function) when is_atom(module) and is_atom(function) do
    case h_mod_fun(module, function) do
      :ok ->
        :ok
      :no_docs ->
        puts_error("#{inspect module} was not compiled with docs")
      :not_found ->
        nodocs("#{inspect module}.#{function}")
    end

    dont_display_result
  end

  defp h_mod_fun(mod, fun) when is_atom(mod) do
    if docs = Code.get_docs(mod, :docs) do
      result = for {{f, arity}, _line, _type, _args, doc} <- docs, fun == f, doc != false do
        h(mod, fun, arity)
      end

      if result != [], do: :ok, else: :not_found
    else
      :no_docs
    end
  end

  @doc """
  Prints the documentation for the given function
  and arity in the list of modules.
  """
  def h(modules, function, arity) when is_list(modules) and is_atom(function) and is_integer(arity) do
    result =
      Enum.find_value modules, false, fn module ->
        h_mod_fun_arity(module, function, arity) == :ok
      end

    unless result, do: nodocs("#{function}/#{arity}")

    dont_display_result
  end

  def h(module, function, arity) when is_atom(module) and is_atom(function) and is_integer(arity) do
    case h_mod_fun_arity(module, function, arity) do
      :ok ->
        :ok
      :no_docs ->
        puts_error("#{inspect module} was not compiled with docs")
      :not_found ->
        nodocs("#{inspect module}.#{function}/#{arity}")
    end

    dont_display_result
  end

  @doc """
  Map over module list and return a list of header, doc tuples.
  """
  def get_docs(module,helpers,opts) do
    case opts do 
      :first -> 
        doc_list = helpers |> Enum.find_value( fn(mod) -> can_help(mod,module) end)
        case doc_list do 
          nil -> [{:not_found,{default_header(module),"No documentation found for #{inspect module}"}}]
          -   -> doc_list
        end 
      _ -> 
        helpers |> Enum.map( fn(mod) -> mod.documentation(module) end)
    end 
  end

  @doc """
  Return nil if mod.documentation returns :can_not_help
  """
  def can_help(mod,module) do
    {status, doc_list } = mod.documentation(module)
    case status do
      :can_not_help -> nil 
      _             -> [{status, doc_list}]
    end
  end 

end
