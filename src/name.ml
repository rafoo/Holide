(*
   Since we will use Dedukti variables to represent a lot of things, we need
   to divide the namespace to avoid name clashes.

   The variable name space is divided into
   - HOL names (term variables, type variables, constants, type operators, ...)
   - hypothesis variable names
   - theorem names
   - axiom names
   - dictionary key names
   - intermediary step names
*)

let hyp_prefix = "hyp_"

let thm_prefix = "thm_"

let axm_prefix = "axm_"

let dict_prefix = "dict_"

let step_prefix = "step_"

let var_prefix = "var_"

let cst_prefix = ""

let tyvar_prefix = "tyvar_"

let tyop_prefix = ""

(* If set to false, ignore name mangling for HOL names. This is unsafe, but
   produces more readable code. *)
let mangle_names = ref false

let counter = ref 0

let next () = counter := !counter + 1; !counter

let fresh prefix = prefix ^ string_of_int (next ())

let fresh_hyp () = fresh hyp_prefix

let fresh_thm () = fresh thm_prefix

let fresh_axm () = fresh axm_prefix

let fresh_dict () = fresh dict_prefix

let fresh_step () = fresh step_prefix

let export_dict k = dict_prefix ^ (string_of_int k)

let starts_with prefix name =
  try String.sub name 0 (String.length prefix) = prefix
  with Invalid_argument _ -> false

let export_name prefix name =
(*  let name = escape name in*)
  if !mangle_names then prefix ^ name else
  (* When name mangling is deactivated, at least make sure the name does not
     clash with the ones that we generated. This probably never occurs. *)
  if starts_with hyp_prefix name ||
     starts_with thm_prefix name ||
     starts_with axm_prefix name ||
     starts_with dict_prefix name     
  then name ^ "'" else name

let export_var (idx, a) =
  (* Term variables can have the same name but different types, so we suffix
     the hash of the type to avoid clashes. *)
  let name = idx ^ "_" ^ (string_of_int (Hashtbl.hash a)) in
  export_name var_prefix name

(* Filter logical connectives because Dedukti only accepts alpha-numerical
   characters. *)
let export_cst c = export_name cst_prefix c

let export_tyvar a = export_name tyvar_prefix a

let export_tyop tyop = export_name tyop_prefix tyop

