defmodule IexHHelperTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "h works for Elixir module" do
  	assert Iex.HHelper.h(Integer)
  end 

  test "h works for Erlang Module" do 
  	assert Iex.HHelper.h(:erlang)
  end 

  test "h barfs with wrong arguments" do 
    assert String.contains? capture_io(fn -> Iex.HHelper.h("foobar") end) ,  "Invalid arguments for h helper"
  end 

  test "h works for Elixir module and function" do
    assert Iex.HHelper.h(Atom,:to_string)
  end

  test "get_docs works with :first" do 
  	Iex.HHelper.get_docs(:erlang,[ElixirDoc, ErlangDoc, DashDoc], :first )
  end 

  test "get_docs works with :all" do
  	Iex.HHelper.get_docs(:erlang,[ElixirDoc, ErlangDoc, DashDoc], :all)
  end 
end
