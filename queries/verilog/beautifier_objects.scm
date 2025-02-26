; =====================
; = MADE BY BUTTERSUS =
; =====================

;; Blocks
;; ======

(module_declaration) @block.outer
(interface_declaration) @block.outer
(conditional_statement) @block.outer
(loop_statement) @block.outer
(loop_generate_construct) @block.outer
(generate_region) @block.outer
(constraint_declaration) @block.outer
(class_declaration) @block.outer
(always_construct) @block.outer
(par_block) @block.outer
(class_method) @block.outer

(_ (conditional_compilation_directive) @_start_outer
  . (_)? . (conditional_compilation_directive) @_end_outer
  (#match? @_start_outer "^[\\`]ifn?def")
  (#match? @_end_outer "^[\\`]endif")
  (#make-range! "block.outer" @_start_outer @_end_outer))
(constraint_expression . "if" . (expression)) @block.outer
(constraint_expression
  . "foreach" . (hierarchical_identifier)
  . (loop_variables)) @block.outer
(constraint_block) @block.outer
(function_declaration) @block.outer
(task_declaration) @block.outer

;; Fields
;; ======

(data_declaration (list_of_variable_decl_assignments)) @field.outer
(for_variable_declaration) @field.outer
(parameter_declaration) @field.outer
(ansi_port_declaration) @field.outer
(module_instantiation) @field.outer
(enum_name_declaration) @field.outer
(tf_port_item) @field.outer

