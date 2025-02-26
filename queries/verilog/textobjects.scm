;; Original textobjects, which are overriden:
;; https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/verilog/textobjects.scm

; =====================
; = MADE BY BUTTERSUS =
; =====================

;; Do you want to know how to write your own textobject?
;; Welp, turns out it's a Lisp, which I found out really weird
;; https://en.wikipedia.org/wiki/S-expression

; NOTE: Author of nvim-treesitter-textobjects is planning to add negate syntax from tree-sitter
; It'll make it able to select @parameter.outer even if there are comments in between
; https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/python/textobjects.scm



;; Modules & Interfaces (+block)
;; ====================

; Outer
(module_declaration) @module.outer @block.outer

(interface_declaration) @module.outer @block.outer

; Inner
(module_ansi_header
  name: (simple_identifier) @module.inner)

(interface_ansi_header
  name: (simple_identifier) @module.inner)

(module_ansi_header
  (list_of_port_declarations
    . "("
    . (_) @_start
    (_)? @_end
    . ")"
    (#make-range! "module.inner" @_start @_end)))

(interface_ansi_header
  (list_of_port_declarations
    . "("
    . (_) @_start
    (_)? @_end
    . ")"
    (#make-range! "module.inner" @_start @_end)))

(module_declaration
  . (module_ansi_header)
  . (_) @_start
  (_)? @_end
  . "endmodule"
  (#make-range! "module.inner" @_start @_end)
  (#make-range! "block.inner" @_start @_end))

(interface_declaration
  . (interface_ansi_header)
  . (_) @_start
  (_)? @_end
  . "endinterface"
  (#make-range! "module.inner" @_start @_end)
  (#make-range! "block.inner" @_start @_end))



;; Parameters
;; ==========

; NOTE: Parameters are hard to match correctly when it comes to commas.
; I did my best to enhance it, but still there are many cases where it does match wrong
; element, so I'll leave it as it is for now

; DIMENSIONS & BIT SELECTS
; ------------------------

(bit_select (_) @parameter.inner @parameter.outer)
(packed_dimension (_) @parameter.inner @parameter.outer)
(unpacked_dimension (_) @parameter.inner @parameter.outer)

; Inner
(constant_range (_) @parameter.inner)
(value_range (_) @parameter.inner)

; RANGES
; ------

; Outer, case 1
(constant_range
  . (_) @_start
  . ":"? @_end
  (#make-range! "parameter.outer" @_start @_end))

(value_range
  . (_) @_start
  . ":"? @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(constant_range
  ":" @_start
  . (_) @_end
  (#make-range! "parameter.outer" @_start @_end))

(value_range
  ":" @_start
  . (_) @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(constant_range
  (_) @_start
  . ":" @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))

(value_range
  (_) @_start
  . ":" @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))

; DELAY CONTROL
; -------------

(delay_control . (_) @parameter.inner @parameter.outer)

; WAIT STATEMENT
; --------------

(wait_statement . (expression) @parameter.inner @parameter.outer)

; CLOCKING EVENTS
; ---------------

(clocking_event (_) @parameter.inner @parameter.outer)

; Inner
(event_expression
  (event_expression)  ; At least one more parameter
  (event_expression) @parameter.inner)

; Outer, case 1
(event_expression
  . (event_expression) @_start
  . "," @_end
  (event_expression)  ; Guarantee at least one more parameter
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(event_expression
  (event_expression)  ; Guarantee at least one more parameter
  "," @_start
  . (event_expression) @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(event_expression
  (event_expression) @_start
  . "," @_end
  . (comment)
  (event_expression)  ; Guarantee at least one more parameter
  (#make-range! "parameter.outer" @_start @_end))

; CLASS CONSTRUCTOR PARAMETERS
; ----------------------------

; Inner
(class_constructor_arg_list
  (class_constructor_arg) @parameter.inner)

; Outer, case 1
(class_constructor_arg_list
  . (class_constructor_arg) @_start
  . ","? @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(class_constructor_arg_list
  "," @_start
  . (class_constructor_arg) @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(class_constructor_arg_list
  (class_constructor_arg) @_start
  . "," @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))

; PORT DECLARATIONS
; -----------------

; Inner
(list_of_port_declarations
  (ansi_port_declaration) @parameter.inner)

; Outer, case 1
(list_of_port_declarations
  . (ansi_port_declaration) @_start
  . ","? @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(list_of_port_declarations
  "," @_start
  . (ansi_port_declaration) @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(list_of_port_declarations
  (ansi_port_declaration) @_start
  . "," @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))

; Task/Function PORT DECLARATIONS
; -------------------------------

; Inner
(tf_port_list
  (tf_port_item) @parameter.inner)

; Outer, case 1
(tf_port_list
  . (tf_port_item) @_start
  . ","? @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(tf_port_list
  "," @_start
  . (tf_port_item) @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(tf_port_list
  (tf_port_item) @_start
  . "," @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))

; CASE PARAMETERS
; ---------------

; NOTE: There is only one parameter

; Inner
(case_statement
  (case_expression) @parameter.inner @parameter.outer)

; VARIABLE IDENTIFIERS
; --------------------

; Inner
(variable_identifier_list
  (_) @parameter.inner)

; Outer, case 1
(variable_identifier_list
  . (_) @_start
  . ","? @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(variable_identifier_list
  "," @_start
  . (_) @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(variable_identifier_list
  (_) @_start
  . "," @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))

; CONCATENATION
; -------------

; Inner
(concatenation
  (_) @parameter.inner)

; Outer, case 1
(concatenation
  . (_) @_start
  . ","? @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(concatenation
  "," @_start
  . (_) @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(concatenation
  (_) @_start
  . "," @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))

; PARAMETER PORTS
; ---------------

; Inner
(parameter_port_list
  (parameter_port_declaration) @parameter.inner)

; Outer, case 1
(parameter_port_list
  . (parameter_port_declaration) @_start
  . ","? @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(parameter_port_list
  "," @_start
  . (parameter_port_declaration) @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(parameter_port_list
  (parameter_port_declaration) @_start
  . "," @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))

; PARAMETER ASSIGNMENTS
; ---------------------

; Inner
; NOTE: I'll detect it as an explicit parameter only if there are at least 2 elements
; Order of additional param_assignment actually matters in this case
(list_of_param_assignments
  (param_assignment)  ; At least one more parameter
  (param_assignment) @parameter.inner)

; Outer, case 1
(list_of_param_assignments
  . (param_assignment) @_start
  . "," @_end  ; Comma is necessary in this case
  (param_assignment)  ; Guarantee at least one more parameter
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(list_of_param_assignments
  (param_assignment)  ; Guarantee at least one more parameter
  "," @_start
  . (param_assignment) @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(list_of_param_assignments
  (param_assignment) @_start
  . "," @_end
  . (comment)
  (param_assignment)  ; Guarantee at least one more parameter
  (#make-range! "parameter.outer" @_start @_end))

; CALL ARGUMENTS
; --------------

; Inner
(list_of_arguments
  (_) @parameter.inner)

; Outer, case 1
(list_of_arguments
  . (_) @_start
  . ","? @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(list_of_arguments
  "," @_start
  . (_) @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(list_of_arguments
  (_) @_start
  . "," @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))

; PORT CONNECTIONS
; ----------------

; Inner
(list_of_port_connections
  [ (ordered_port_connection) (named_port_connection) ] @parameter.inner)

; Outer, case 1
(list_of_port_connections
  . [ (ordered_port_connection) (named_port_connection) ] @_start
  . ","? @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(list_of_port_connections
  "," @_start
  . [ (ordered_port_connection) (named_port_connection) ] @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(list_of_port_connections
  [ (ordered_port_connection) (named_port_connection) ] @_start
  . "," @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))

; PARAMETER VALUE ASSIGNMENTS
; ---------------------------

; Inner
(list_of_parameter_value_assignments
  [ (ordered_parameter_assignment) (named_parameter_assignment) ] @parameter.inner)

; Outer, case 1
(list_of_parameter_value_assignments
  . [ (ordered_parameter_assignment) (named_parameter_assignment) ] @_start
  . ","? @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 2
(list_of_parameter_value_assignments
  "," @_start
  . [ (ordered_parameter_assignment) (named_parameter_assignment) ] @_end
  (#make-range! "parameter.outer" @_start @_end))

; Outer, case 3 (for convenient use with trailing commentaries)
(list_of_parameter_value_assignments
  [ (ordered_parameter_assignment) (named_parameter_assignment) ] @_start
  . "," @_end
  . (comment)
  (#make-range! "parameter.outer" @_start @_end))



;; Assignments
;; ===========

(continuous_assign
  (list_of_net_assignments
    (net_assignment
      (net_lvalue) @assignment.lhs
      . (_) @assignment.rhs @assignment.inner))) @assignment.outer

(nonblocking_assignment
  (variable_lvalue) @assignment.lhs
  . (_) @assignment.rhs @assignment.inner) @assignment.outer



;; Statements
;; ==========

; MODULE-LEVEL
; ------------

(module_declaration
  . (module_ansi_header)
  (_) @statement.inner @statement.outer
  (#not-kind-eq? @statement.inner "comment")
  (#lua-match? @statement.inner ";$")
  (#offset! @statement.inner 0 0 0 -1))

(module_declaration
  . (module_ansi_header)
  (_) @statement.inner @statement.outer
  (#not-kind-eq? @statement.inner "comment")
  (#lua-match? @statement.inner "[^;]$"))

(interface_declaration
  . (interface_ansi_header)
  (_) @statement.inner @statement.outer
  (#not-kind-eq? @statement.inner "comment")
  (#lua-match? @statement.inner ";$")
  (#offset! @statement.inner 0 0 0 -1))

(interface_declaration
  . (interface_ansi_header)
  (_) @statement.inner @statement.outer
  (#not-kind-eq? @statement.inner "comment")
  (#lua-match? @statement.inner "[^;]$"))

; ITEMS
; -----

; Class items
(class_item) @statement.outer

(class_item (_) @statement.inner
  (#lua-match? @statement.inner ";$")
  (#offset! @statement.inner 0 0 0 -1))

(class_item (_) @statement.inner
  (#lua-match? @statement.inner "[^;]$"))

; Constraint items
(constraint_block_item) @statement.outer

(constraint_block_item (_) @statement.inner
  (#lua-match? @statement.inner ";$")
  (#offset! @statement.inner 0 0 0 -1))

(constraint_block_item (_) @statement.inner
  (#lua-match? @statement.inner "[^;]$"))

; Block declarations
(block_item_declaration) @statement.outer

(block_item_declaration (_) @statement.inner
  (#lua-match? @statement.inner ";$")
  (#offset! @statement.inner 0 0 0 -1))

(block_item_declaration (_) @statement.inner
  (#lua-match? @statement.inner "[^;]$"))

; Statement items
(statement_item) @statement.outer

(statement_item (_) @statement.inner
  (#not-kind-eq? @statement.inner "seq_block")
  (#not-kind-eq? @statement.inner "generate_block")
  (#lua-match? @statement.inner ";$")
  (#offset! @statement.inner 0 0 0 -1))

(statement_item (_) @statement.inner
  (#not-kind-eq? @statement.inner "seq_block")
  (#not-kind-eq? @statement.inner "generate_block")
  (#lua-match? @statement.inner "[^;]$"))



;; Macros
;; ======

; DEFINE
; ------

; Outer
(text_macro_definition) @macro.outer

; Inner
(text_macro_definition
  . (text_macro_name)
  . (macro_text) @macro.inner)



;; Conditionals
;; ============

; IFDEF (+block)
; -----

(ifdef_condition) @conditional.inner

(_
  (conditional_compilation_directive) @_start_outer
  . (_)?
  . (conditional_compilation_directive) @_end_outer
  (#match? @_start_outer "^[\\`]ifn?def")
  (#match? @_end_outer "^[\\`]endif")
  (#make-range! "conditional.outer" @_start_outer @_end_outer)
  (#make-range! "block.outer" @_start_outer @_end_outer))

; NOTE: This part is also tricky. I use RegEx to distinguish between `ifdef`, `else` and `endif`.

(_
  (conditional_compilation_directive) @_start_outer
  . (_) @_start
  (_)? @_end
  . (conditional_compilation_directive) @_end_outer
  (#match? @_start_outer "^[\\`]ifn?def|else|elsif")
  (#match? @_end_outer "^[\\`](endif|elsif|else)")
  (#make-range! "conditional.inner" @_start @_end)
  (#make-range! "block.inner" @_start @_end))

; IF-ELSE-END
; -----------

; Outer
(conditional_statement) @conditional.outer @block.outer

; Inner
(cond_predicate) @conditional.inner @parameter.inner @parameter.outer

(conditional_statement 
  . (cond_predicate)
  (_) @conditional.inner)

; Outer, <contraint> if (...) else ...
(constraint_expression
  . "if" . (expression)) @conditional.outer @block.outer

; Inner
(constraint_expression
  . "if" . (expression) @conditional.inner @parameter.inner @parameter.outer)

(constraint_expression
  . "if" . (expression)
  . (_) @conditional.inner)

(constraint_expression
  . "if" . (expression)
  . (_) . "else"
  . (_) @conditional.inner)



;; Comments
;; ========

(comment) @comment.outer
(_ (comment) @comment.inner
  (#lua-match? @comment.inner "^//[^ ]")
  (#offset! @comment.inner 0 2 0 0))
(_ (comment) @comment.inner
  (#lua-match? @comment.inner "^// ")
  (#offset! @comment.inner 0 3 0 0))
(_ (comment) @comment.inner
  (#lua-match? @comment.inner "^/[*]")
  (#offset! @comment.inner 0 2 0 -2))



;; Loops (+block)
;; =====

; NOTE: Loops inner does match statement including begin/end tokens of sequential blocks in constrast to blocks

; STANDARD LOOPS
; --------------

; Outer
(loop_statement) @loop.outer @block.outer

; Inner, for (...; ...; ...) ...
(loop_statement
  . "for" . (for_initialization) @loop.inner @parameter.inner)

(loop_statement
  . "for" . (for_initialization)
  . (expression) @loop.inner @parameter.inner)

(loop_statement
  . "for" . (for_initialization)
  . (expression)
  . (for_step) @loop.inner @parameter.inner)

(loop_statement
  . "for" . "(" . (for_initialization) @_start
  . (expression)
  . (for_step) @_end
  . ")" . (_) @loop.inner
  (#make-range! "parameter.outer" @_start @_end))

; Inner, while (...) ... + repeat (...) ...
(loop_statement
  . [ "while" "repeat" ]
  . (expression) @loop.inner @parameter.inner @parameter.outer)

(loop_statement
  . [ "while" "repeat" ]
  . (expression)
  . (_) @loop.inner)

; Inner, foreach (...[...]) ...
(loop_statement
  . "foreach"
  . (hierarchical_identifier) @_start @parameter.inner
  . "[" . (loop_variables) @parameter.inner
  . "]" @_end
  (#make-range! "loop.inner" @_start @_end)
  (#make-range! "parameter.outer" @_start @_end))

(loop_statement
  . "foreach"
  . (hierarchical_identifier)
  . (loop_variables)
  . (_) @loop.inner)

; Inner, do (...) while (...)
(loop_statement
  . "do"
  . (_) @loop.inner
  . "while"
  . (expression))

(loop_statement
  . "do"
  . (_)
  . "while"
  . (expression) @loop.inner @parameter.inner @parameter.outer)

; Inner, forever ...
(loop_statement
  . "forever"
  . (_) @loop.inner)

; Outer, <constraint> foreach (...[...]) ...
(constraint_expression
  . "foreach"
  . (hierarchical_identifier)
  . (loop_variables)) @loop.outer @block.outer

; Inner, <constraint> foreach (...[...]) ...
(constraint_expression
  . "foreach"
  . (hierarchical_identifier) @_start @parameter.inner
  . "[" . (loop_variables) @parameter.inner
  . "]" @_end
  (#make-range! "loop.inner" @_start @_end)
  (#make-range! "parameter.outer" @_start @_end))

(constraint_expression
  . "foreach"
  . (hierarchical_identifier)
  . (loop_variables)
  . (_) @loop.inner)

; GENERATE LOOPS (+block)
; --------------

; Outer
(loop_generate_construct) @loop.outer @block.outer

; Inner
(loop_generate_construct
  . "for" . (genvar_initialization) @loop.inner @parameter.inner)

(loop_generate_construct
  . "for" . (genvar_initialization)
  . (constant_expression) @loop.inner @parameter.inner)

(loop_generate_construct
  . "for" . (genvar_initialization)
  . (constant_expression)
  . (genvar_iteration) @loop.inner @parameter.inner)

(loop_generate_construct
  . "for" . "(" . (genvar_initialization) @_start
  . (constant_expression)
  . (genvar_iteration) @_end
  . ")" . (_) @loop.inner
  (#make-range! "parameter.outer" @_start @_end))



;; Generate Region Blocks
;; ======================

; Outer
(generate_region) @block.outer

; Inner
(generate_region
  . (_) @_start
  (_)? @_end
  . "endgenerate"
  (#make-range! "block.inner" @_start @_end))



;; Constraint Blocks
;; =================

; Outer
(constraint_declaration) @block.outer
((_
  (constraint_block) @block.outer) @_parent
  (#not-kind-eq? @_parent "constraint_declaration"))

; Inner
(constraint_block
  . "{"
  . (_) @_start
  (_)? @_end
  . "}"
  (#make-range! "block.inner" @_start @_end))

(constraint_set
  . "{" . (constraint_expression) @block.inner . "}") 



;; Classes
;; =======

; Outer
(class_declaration) @class.outer @block.outer

; Inner
(class_declaration . name: (simple_identifier) @class.inner)

(class_declaration
  . name: (simple_identifier)
  . (class_type)?
  . (_) @_start
  (#not-kind-eq? @_start "class_type")
  (_)? @_end
  . "endclass"
  (#make-range! "class.inner" @_start @_end)
  (#make-range! "block.inner" @_start @_end))

;; Other Blocks
;; ============

; NOTE: To match full block, we don't define general seq_block query for outer scope,
; since then it will match any kind of block without keyword sometimes.

; OUTER
; -----

; Always construct
(always_construct) @block.outer

; Fork block
(par_block) @block.outer

; INNER
; -----

; Sequential
(seq_block
  . "begin" . (simple_identifier)?
  . (_) @_start
  (#not-kind-eq? @_start "simple_identifier")
  (_)? @_end
  . "end"
  (#make-range! "block.inner" @_start @_end))

; Generate
; NOTE: Don't confuse with generate_region

(generate_block
  . "begin" . (simple_identifier)?
  . (_) @_start
  (#not-kind-eq? @_start "simple_identifier")
  (_)? @_end
  . "end"
  (#make-range! "block.inner" @_start @_end))

; Forks
(par_block
  . (_) @_start
  (_)? @_end
  . (join_keyword)
  (#make-range! "block.inner" @_start @_end))



;; Functions (+block)
;; =========

; Outer
(class_method) @function.outer @block.outer

((_
  (function_declaration) @function.outer @block.outer) @_parent
  (#not-kind-eq? @_parent "class_method"))

((_
  (task_declaration) @function.outer @block.outer) @_parent
  (#not-kind-eq? @_parent "class_method"))

; Inner, method
(class_method
  . (method_qualifier) @_start
  (method_qualifier)? @_end
  . (function_declaration)
  (#make-range! "function.inner" @_start @_end))

; Inner, function
(function_body_declaration
  [
    (data_type_or_void) @function.inner
    name: (simple_identifier) @function.inner
  ])

(function_body_declaration
  name : (simple_identifier)
  . (tf_port_list
      . (tf_port_item) @_start
      . (tf_port_item)* @_end
      . (#make-range! "function.inner" @_start @_end)))

(function_body_declaration
  name : (simple_identifier)
  . (tf_port_list)? . ";"
  . (_) @_start
  (_)? @_end
  . "endfunction"
  (#make-range! "function.inner" @_start @_end)
  (#make-range! "block.inner" @_start @_end))

; Inner, task
(task_body_declaration
  . name: (simple_identifier) @function.inner)

(task_body_declaration
  . name: (simple_identifier)
  . (tf_port_list
      . (tf_port_item) @_start
      . (tf_port_item)* @_end
      . (#make-range! "function.inner" @_start @_end)))

(task_body_declaration
  . name: (simple_identifier)
  . (tf_port_list)? . ";"
  . (_) @_start
  (_)? @_end
  . "endtask"
  (#make-range! "function.inner" @_start @_end)
  (#make-range! "block.inner" @_start @_end))

; Inner, constructor
(class_constructor_declaration
  . (class_constructor_arg_list
      . (class_constructor_arg) @_start
      . (class_constructor_arg)* @_end
      . (#make-range! "function.inner" @_start @_end)))

(class_constructor_declaration
  . (class_constructor_arg_list)? . ";"
  . (_) @_start
  (_)? @_end
  . "endfunction"
  (#make-range! "function.inner" @_start @_end)
  (#make-range! "block.inner" @_start @_end))



;; CALLS
;; =====

; NOTE: It's hard to implement all calls, since there are a few tricky ones like $finish, std::randomize

; Outer
(method_call) @call.outer
((_
  [ (system_tf_call)
    (simulation_control_task) 
    (severity_system_task)
    (array_or_queue_method_call)
    (tf_call)
    (class_new)
    (module_instantiation) ] @call.outer) @_parent
  (#not-kind-eq? @_parent "method_call_body"))

; Inner
(system_tf_call (list_of_arguments) @call.inner)
(simulation_control_task (list_of_arguments)  @call.inner)
(severity_system_task (list_of_arguments) @call.inner)
(array_or_queue_method_call (list_of_arguments) @call.inner)
(tf_call (list_of_arguments) @call.inner)
(method_call_body arguments: (list_of_arguments) @call.inner)
(class_new (list_of_arguments) @call.inner)
(hierarchical_instance (list_of_port_connections) @call.inner)

; RANDOMIZE
; ---------

; Outer
(function_subroutine_call (subroutine_call (randomize_call))) @call.outer

; Inner
(randomize_call
  [ (variable_identifier_list)
    (constraint_block) ] @call.inner)



;; Fields
;; ======

; NOTE: Field is a variable. This means that it stores a real value.

; Outer
(class_property) @field.outer
((_
  (data_declaration (list_of_variable_decl_assignments)) @field.outer ) @_parent
  (#not-kind-eq? @_parent "class_property"))
(for_variable_declaration) @field.outer
(parameter_declaration) @field.outer
(ansi_port_declaration) @field.outer
(module_instantiation) @field.outer
(enum_name_declaration) @field.outer
(tf_port_item) @field.outer

; Inner
(data_declaration 
  (list_of_variable_decl_assignments 
    (variable_decl_assignment 
      name: (simple_identifier) @field.inner)))
(for_variable_declaration (simple_identifier) @field.inner)
(parameter_declaration
  (list_of_param_assignments
    (param_assignment
      (simple_identifier) @field.inner)))
(ansi_port_declaration port_name: (simple_identifier) @field.inner)
(hierarchical_instance (name_of_instance) @field.inner)
(enum_name_declaration (simple_identifier) @field.inner)
(tf_port_item name: (simple_identifier) @field.inner)

