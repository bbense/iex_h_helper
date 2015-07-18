defmodule IexHHelperTest do
  use ExUnit.Case

  test "h works for Elixir module" do
  	Iex.HHelper.h(Integer)
  end 

  test "h works for Erlang Module" do 
  	Iex.HHelper.h(:erlang)
  end 

  test "h barfs with wrong arguments" do 
  	Iex.HHelper.h("foobar")
  end 

  test "h works for Elixir function" do
    Iex.HHelper.h(Atom,:to_string)
  end

  test "get_docs works with :first" do 
  	Iex.HHelper.get_docs(:erlang,[ElixirDoc, ErlangDoc, DashDoc], :first )
  end 

  test "get_docs works with :all" do
  	Iex.HHelper.get_docs(:erlang,[ElixirDoc, ErlangDoc, DashDoc], :all)
  end 
end
