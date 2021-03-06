defmodule Iex.HHelper do
  @moduledoc """
  Define behaviours for modules that will backend the iex h command. 

  All of the functions for this behaviour return one of the following tuples. 

  {:found, doc_list }  - Documentation found doc_list is a list of {header,doc} tuples.
                         in markdown format.

  {:not_found, doc_list } - Documentation not found, but could have been found by module if 
                            it existed.
  {:unknown, doc_list} - Module does not know how to find documentation for arguements. 

  The intent is that helpers can be stacked and the iex command can do either `:first` or `:all`
  (i.e. attempt to get help using the first helper that returns either :found or :not_found, or
   use all the helpers regardless of return status.)
  """

  # These are for exploring, they should be configured in IEX. 
  @opts :first
  @helpers [ElixirDoc, ErlangDoc, DashDoc]

  # Still working on fleshing out exactly what this should be
  # use Behaviour 

  # @doc """
  # document(module) when is_atom(module)
  # """
  # defcallback document(module) :: { Atom , list }

  # @doc """
  # document(module,function) when is_atom(module) and is_atom(function)
  # """
  # defcallback document(module,function) :: { Atom, list } 

  # @doc """
  #  document(module, function, arity) when is_atom(module) and is_atom(function) and is_integer(arity)
  #  """
  # defcallback document(module,function,arity) :: {Atom, list}

  @doc """
  Prints the documentation for the given module.
  """
  def h(module) when is_atom(module) do
    case Code.ensure_loaded(module) do
      {:module, _} ->
        Iex.HHelper.get_docs(module, @helpers, @opts) |>
        Enum.map( fn { status, doc_list }  -> 
                    display_doc_list(status, doc_list)  
                  end )
      {:error, reason} ->
        puts_error("Could not load module #{inspect module}, got: #{reason}")
    end
    dont_display_result
  end

  def h(_) do
    puts_error("Invalid arguments for h helper")
    dont_display_result
  end

  # Still working on these 
  # @doc """
  # Prints the documentation for the given function
  # with any arity in the list of modules.
  # """
  # def h(modules, function) when is_list(modules) and is_atom(function) do
  #   result =
  #     Enum.find_value modules, false, fn module ->
  #       h_mod_fun(module, function) == :ok
  #     end

  #   unless result, do: nodocs(function)

  #   dont_display_result
  # end

  def h(module, function) when is_atom(module) and is_atom(function) do
     Iex.HHelper.get_docs(module,function, @helpers, @opts) |>
        Enum.map( fn { status, doc_list }  -> 
                     display_doc_list(status, doc_list)  
                  end )
    dont_display_result
  end


  # @doc """
  # Prints the documentation for the given function
  # and arity in the list of modules.
  # """
  # def h(modules, function, arity) when is_list(modules) and is_atom(function) and is_integer(arity) do
  #   result =
  #     Enum.find_value modules, false, fn module ->
  #       h_mod_fun_arity(module, function, arity) == :ok
  #     end

  #   unless result, do: nodocs("#{function}/#{arity}")

  #   dont_display_result
  # end

  # def h(module, function, arity) when is_atom(module) and is_atom(function) and is_integer(arity) do
  #   case h_mod_fun_arity(module, function, arity) do
  #     :ok ->
  #       :ok
  #     :no_docs ->
  #       puts_error("#{inspect module} was not compiled with docs")
  #     :not_found ->
  #       nodocs("#{inspect module}.#{function}/#{arity}")
  #   end
  #   dont_display_result
  # end

  def h(module, function, arity) when is_atom(module) and is_atom(function) and is_integer(arity) do
   Iex.HHelper.get_docs(module, function, arity, @helpers, @opts) |>
        Enum.map( fn { status, doc_list }  -> 
                       display_doc_list(status, doc_list) 
                  end )
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
          nil -> [{:not_found,{inspect(module),"No documentation found for #{inspect module}"}}]
          _   -> doc_list
        end 
      _ -> 
        helpers |> Enum.map( fn(mod) -> mod.documentation(module) end)
        # What about nil result
    end 
  end

  @doc """
  Map over module list and return a list of header, doc tuples.
  """
  def get_docs(module,function,helpers,opts) do
    case opts do 
      :first -> 
        doc_list = helpers |> Enum.find_value( fn(mod) -> can_help(mod,module,function) end)
        case doc_list do 
          nil -> [{:not_found,{inspect(module),"No documentation found for #{inspect module}"}}]
          _   -> doc_list
        end 
      _ -> 
        helpers |> Enum.map( fn(mod) -> mod.documentation(module,function) end)
        # What about nil result
    end 
  end

  @doc """
  Map over module list and return a list of header, doc tuples.
  """
  def get_docs(module,function,arity,helpers,opts) do
    case opts do 
      :first -> 
        doc_list = helpers |> Enum.find_value( fn(mod) -> can_help(mod,module,function,arity) end)
        case doc_list do 
          nil -> [{:not_found,{inspect(module),"No documentation found for #{inspect module}"}}]
          _   -> doc_list
        end 
      _ -> 
        helpers |> Enum.map( fn(mod) -> mod.documentation(module,function,arity) end)
        # What about nil result
    end 
  end

  @doc """
  Return nil if mod.documentation returns :unknown
  """
  def can_help(mod,module) do
    {status, doc_list } = mod.documentation(module)
    case status do
      :unknown      -> nil 
      _             -> [{status, doc_list}]
    end
  end 

  @doc """
  Return nil if mod.documentation returns :unknown
  """
  def can_help(mod,module,function) do
    {status, doc_list } = mod.documentation(module,function)
    case status do
      :unknown      -> nil 
      _             -> [{status, doc_list}]
    end
  end 

  @doc """
  Return nil if mod.documentation returns :unknown
  """
  def can_help(mod,module,function,arity) do
    {status, doc_list } = mod.documentation(module,function,arity)
    case status do
      :unknown      -> nil 
      _             -> [{status, doc_list}]
    end
  end 

  defp display_doc_list(status, doc_list) do
    case status do 
      :found -> 
        Enum.map(doc_list, fn({header,doc})-> print_doc(header, doc) end ) 
      :not_found -> 
        Enum.map(doc_list, fn({header,doc})-> print_error(header, doc) end ) 
    end 
  end

  # Temporary
  defp print_doc(heading, doc) do
    doc = doc || ""
    if opts = IEx.Config.ansi_docs do
      IO.ANSI.Docs.print_heading(heading, opts)
      IO.ANSI.Docs.print(doc, opts)
    else
      IO.puts "* #{heading}\n"
      IO.puts doc
    end
  end

  defp print_error(_heading, doc) do
    doc = doc || ""
    puts_error(doc)
  end 

  defp puts_error(string) do
    IO.puts IEx.color(:eval_error, string)
  end

  defp dont_display_result do
    :"do not show this result in output"
  end 

end
