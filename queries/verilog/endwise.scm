; NOTE: Uncomment queries you need. If you don't need some of these, please comment them out.
; It will improve the performance.

; Module
((module_declaration
   . [(module_nonansi_header ";") (module_ansi_header ";")] @cursor) @endable @indent
 (#endwise! "endmodule"))

([(module_nonansi_header ";" @cursor)
  (module_ansi_header ";" @cursor)] @endable @indent
 (#endwise! "endmodule"))

((ERROR ("module" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor) @indent) (#endwise! "endmodule"))

; Interface
((interface_declaration
   . [(interface_nonansi_header ";") (interface_ansi_header ";")] @cursor) @endable @indent
 (#endwise! "endinterface"))

([(interface_nonansi_header ";" @cursor)
  (interface_ansi_header ";" @cursor)] @endable @indent
 (#endwise! "endinterface"))

((ERROR ("interface" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor) @indent) (#endwise! "endinterface"))

; ; Program
; ([(program_nonansi_header ";" @cursor)
;   (program_ansi_header ";" @cursor)] @endable @indent
;  (#endwise! "endprogram"))
;
; ((ERROR ("program" ";" @cursor) @indent) (#endwise! "endprogram"))

; ; Checker 
; ((checker_declaration . "checker" ";" @cursor) @endable @indent
;  (#endwise! "endchecker"))
;
; ((ERROR ("checker" ";" @cursor) @indent) (#endwise! "endchecker"))

; Class
((class_declaration . "virtual"? . "class" ";" @cursor) @endable @indent
 (#endwise! "endclass"))

((ERROR ("class" . [ (simple_identifier) (escaped_identifier) ]? . ";" @cursor) @indent (#endwise! "endclass")))

; Interface Class
((interface_class_declaration . "interface" . "class" ";" @cursor) @endable @indent
 (#endwise! "endclass"))

((ERROR ("interface" . "class" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor) @indent (#endwise! "endclass")))

; Package
((package_declaration . "package" ";" @cursor) @endable @indent
 (#endwise! "endpackage"))

((ERROR ("package" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor) @indent) (#endwise! "endpackage"))

; ; Config
; ((config_declaration . "config" ";" @cursor) @endable @indent
;  (#endwise! "endconfig"))
;
; ((ERROR ("config" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor) @indent)
;  (#endwise! "endconfig"))

; Class Constructor
((class_constructor_declaration . "function" ";" @cursor) @endable @indent
 (#endwise! "endfunction: new"))

((ERROR 
   [("function" . "new" . ";" @cursor)
    ("function" . "new" . "(" . (class_constructor_arg_list)? . ")" . ";" @cursor)]
   @indent) (#endwise! "endfunction: new"))

; ; Anonymous Program
; ((anonymous_program . "program" ";" @cursor) @endable @indent
;  (#endwise! "endprogram"))
;
; ((ERROR ("program" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor) @indent)
;  (#endwise! "endprogram"))

; Function Body
((function_body_declaration . (_) ";" @cursor) @endable @indent
 (#endwise! "endfunction"))

((ERROR 
   [("function" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor)
    ("function" . [ (simple_identifier) (escaped_identifier) ] . "(" . (tf_port_list)? . ")" . ";" @cursor)]
   @indent) (#endwise! "endfunction"))

; Task Body
((task_body_declaration . (_) ";" @cursor) @endable @indent
 (#endwise! "endtask"))

((ERROR 
   [("task" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor)
    ("task" . [ (simple_identifier) (escaped_identifier) ] . "(" . (tf_port_list)? . ")" . ";" @cursor)]
   @indent) (#endwise! "endtask"))

; Property
((property_declaration . "property" ";" @cursor) @endable @indent
 (#endwise! "endproperty"))

((ERROR 
   [("property" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor)
    ("property" . [ (simple_identifier) (escaped_identifier) ] . "(" . (property_port_list)? . ")" . ";" @cursor)]
   @indent) (#endwise! "endproperty"))

; ; Sequence
; ((sequence_declaration . "sequence" ";" @cursor) @endable @indent
;  (#endwise! "endsequence"))
;
; ((ERROR 
;    [("sequence" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor)
;     ("sequence" . [ (simple_identifier) (escaped_identifier) ] . "(" . (sequence_port_list)? . ")" . ";" @cursor)]
;    @indent) (#endwise! "endsequence"))

; ; Covergroup
; ((covergroup_declaration . "covergroup" ";" @cursor) @endable @indent
;  (#endwise! "endgroup"))
;
; ((ERROR 
;    [("covergroup" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor)
;     ("covergroup" . [ (simple_identifier) (escaped_identifier) ] . "(" . (tf_port_list)? . ")" . ";" @cursor)]
;    @indent) (#endwise! "endgroup"))

; Generate Region
((generate_region . "generate" @cursor) @endable @indent
 (#endwise! "endgenerate"))

((ERROR ("generate" @cursor) @indent) (#endwise! "endgenerate"))

; Case Generate
((case_generate_construct . "case" "(" (_) ")" @cursor) @endable @indent
 (#endwise! "endcase"))

; Generate Block
([(generate_block . (_) . "begin" @cursor)
  (generate_block . (_) . "begin" ":" name: (_) @cursor)] @endable @indent
 (#endwise! "end"))

; ; Primitive
; ((udp_declaration . [ ("primitive" ";") (udp_nonansi_declaration ";") (udp_ansi_declaration ";") ] @cursor) @endable @indent
;  (#endwise! "endprimitive"))
;
; ((ERROR ("primitive" . [ (simple_identifier) (escaped_identifier) ] . ";" @cursor) @indent) (#endwise! "endprimitive"))

; ; Combinational & Sequential
; ((combinational_body . "table" @cursor) @endable @indent
;  (#endwise! "endtable"))
;
; ((sequential_body . (_) . "table" @cursor) @endable @indent
;  (#endwise! "endtable"))
;
; ((ERROR ("table" @cursor) @indent) 
;  (#endwise! "endtable"))

; Seq Block
([(seq_block . "begin" @cursor) 
  (seq_block . "begin" ":" (_) @cursor)] @endable @indent
 (#endwise! "end"))

((ERROR ("begin" @cursor) @indent) (#endwise! "end"))

; Par Block
((par_block
   . [ "fork" ("fork" ":" (_)) ] @cursor
 ) @endable @indent
 (#endwise! "join"))

((ERROR ("fork" @cursor) @indent) (#endwise! "join"))

; Case Statement
([(case_statement . [ "case" (case_keyword) ] "(" (_) ")" "inside" @cursor)
  (case_statement . [ "case" (case_keyword) ] "(" (_) ")" @cursor)] @endable @indent
 (#endwise! "endcase"))

((ERROR
   [("case" . "(" . (_) . ")" . "inside" @cursor)
    ("case" . "(" . (_) . ")" @cursor)]
   @indent) (#endwise! "endcase"))

; ; RandCase Statement
; ((randcase_statement
;    . "randcase" @cursor
;  ) @endable @indent
;  (#endwise! "endcase"))
;
; ((ERROR ("randcase" @cursor) @indent) (#endwise! "endcase"))

; ; Clocking
; ((clocking_declaration
;    . [ "default" "global" ]? . "clocking" ";" @cursor
;  ) @endable @indent
;  (#endwise! "endclocking"))
;
; ((ERROR ("clocking" ";" @cursor) @indent) (#endwise! "endclocking"))

; ; RandSequence Statement
; ((randsequence_statement
;    . "randsequence" "(" (_) ")" @cursor
;  ) @endable @indent
;  (#endwise! "endsequence"))
;
; ((ERROR ("randsequence" "(" (_) ")" @cursor) @indent) (#endwise! "endsequence"))

; ; RsCase
; ((rs_case
;    . "case" "(" (_) ")" @cursor
;  ) @endable @indent
;  (#endwise! "endcase"))

; ; Specify Block
; ((specify_block
;    . "specify" @cursor
;  ) @endable @indent
;  (#endwise! "endspecify"))
;
; ((ERROR ("specify" @cursor) @indent) (#endwise! "endspecify"))

