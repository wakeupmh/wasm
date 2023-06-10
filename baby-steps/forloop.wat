(module
  (func $forLoop (result i32)
    (local $x i32)
    (local $res i32)

    (local.set $x (i32.const 0))
    (local.set $res (i32.const 0))

    (block
        (loop
         (local.set $x (call $increment (local.get $x)))
         (local.set $res (i32.add (local.get $res) (local.get $x)))
         (br_if 1 (i32.eq (local.get $x) (i32.const 20)))
         (br 0)
       )
    )

    (local.get $res)
  )

  (func $increment (param $x i32) (result i32)
     (i32.add (local.get $x) (i32.const 1))
  )

  (export "forLoop" (func $forLoop))
)

