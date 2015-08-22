defmodule ErlangDoc do
  @moduledoc """
  Stub module for testing. 
  """

  def documentation(module) do 
    case is_erlang?(module) do
      true -> get_doc(module)
      _  -> { :unknown, [{inspect(module), "" }]} 
    end 
  end 
  
  def documentation(module, function) do 
    case is_erlang?(module) do
      true -> get_doc(module, function)
      _  -> { :unknown, [{inspect(module), "" }]} 
    end 
  end 

  def documentation(module, function,arity) do 
    case is_erlang?(module) do
      true -> get_doc(module, function,arity)
      _  -> { :unknown, [{inspect(module), "" }]} 
    end 
  end 
  
  def is_erlang?(module) do
    case is_elixir?(module) do 
      true -> false
      _    -> true
    end 
  end

  def is_elixir?(module) do
    Atom.to_string(module) |>
    String.starts_with?("Elixir.")
  end

  def get_doc(module) do
    { :found, [{ inspect(module), "Found the erlang man page\n"}] }
  end 

  def get_doc(module, function) do 
    { :found, [{ inspect(module), "Found the erlang man page\n"}] }
  end 

   def get_doc(module, function,arity) do 
    { :found, [{ inspect(module), "Found the erlang man page\n"}] }
  end 

end