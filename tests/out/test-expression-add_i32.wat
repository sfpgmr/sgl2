(module
 (type $main (func (result i32)))
 (export "main" (func $main))
 (func $main (; 0 ;) (type $main) (result i32)
  (local $0 i32)
  (local $1 i32)
  (set_local $0
   (i32.const 2)
  )
  (set_local $1
   (i32.const 3)
  )
  (return
   (i32.add
    (get_local $0)
    (get_local $1)
   )
  )
 )
)
