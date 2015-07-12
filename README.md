# iex_h_helper
Trying out some ideas around extending the iex h command 

Define behaviours for modules that will backend the iex h command. 

  All of the functions for this behaviour return one of the following tuples. 

  `{:found, doc_list }`    - Documentation found `doc_list` is a list of `{header,doc}` tuples in markdown format.

  `{:not_found, doc_list }` - Documentation not found, but could have been found by module if it existed.

  `{:unknown, doc_list}` - Module does not know how to find documentation for arguements. 

  The intent is that helpers can be stacked and the iex command can do either `:first` or `:all`
  (i.e. attempt to get help using the first helper that returns either `:found` or `:not_found`, or
   use all the helpers regardless of return status.)
