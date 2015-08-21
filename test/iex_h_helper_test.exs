defmodule IexHHelperTest do
  use ExUnit.Case

  ExUnit.configure(exclude: [get_docs: true])

  import ExUnit.CaptureIO

  test "h works for Elixir module" do
  	assert capture_io(fn -> Iex.HHelper.h(Integer) end) == "\e[0m\n\e[7m\e[33m                                    Integer                                     \e[0m\n\e[0m\nFunctions for working with integers.\n\e[0m\n"
  end 

  test "h works for Erlang Module" do 
  	assert String.contains? capture_io(fn -> Iex.HHelper.h(:erlang) end), "erlang"
  end 

  test "h barfs with wrong arguments" do 
    assert String.contains? capture_io(fn -> Iex.HHelper.h("foobar") end) ,  "Invalid arguments for h helper"
  end 

  test "h works for Elixir module and function" do
    assert String.contains? capture_io(fn -> Iex.HHelper.h(Atom,:to_string) end), "Converts an atom to string"
  end

  test "h works for Elixir module and function with multiple arities" do
    docs =  capture_io(fn -> Iex.HHelper.h(Kernel,:raise) end)
    assert String.contains? docs,  "defmacro raise(msg)"
    assert String.contains? docs,  "defmacro raise(exception, attrs)"
  end 

  test "h works for Elixir module and function with zero arities" do
    assert String.contains? capture_io(fn -> Iex.HHelper.h(Node,:get_cookie) end ), "def get_cookie()"
  end 


  @tag :get_docs
  test "get_docs works with :first" do 
  	[found: [{ mod , doc }]] = Iex.HHelper.get_docs(:erlang,[ElixirDoc, ErlangDoc, DashDoc], :first )
    assert mod == ":erlang"
    assert String.contains? doc, "erlang"
  end 

  @tag :get_docs
  test "get_docs works with :all" do
  	[ unknown: _ , found: _ , found: _ ] = Iex.HHelper.get_docs(:erlang,[ElixirDoc, ErlangDoc, DashDoc], :all)
  end 

end
