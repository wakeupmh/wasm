(module
    (memory $mem 1)
    ;; X plays first
    (global $currentTurn (mut i32) (i32.const 1))
    (global $X i32 (i32.const 1))
    (global $Y i32 (i32.const 2))
    (global $EMPTY i32 (i32.const 0))

    ;; Linearize a 3x3 tic-tac-toe board
    (func $indexForPosition (param $row i32) (param $col i32) (result i32)
        (i32.add
            (i32.mul
                (i32.const 3)
                (local.get $row)
            )
            (local.get $col)
        )
    )

    ;; Offset = ( index ) * 4
  (func $offsetForPosition (param $row i32) (param $col i32) (result i32)
    (i32.mul
      (call $indexForPosition (local.get $row) (local.get $col))
      (i32.const 4)
    )
  )


    ;; Sets a piece in the board. No error checking is done here
    (func $setPiece (param $row i32) (param $col i32) (param $piece i32)
        (i32.store
            (call $offsetForPosition
                (local.get $row)
                (local.get $col)
            )
            (local.get $piece)
        )
    )

    ;; Places the current player's piece in the given location
    ;; advances to next player
    (func $takeTurn (param $row i32) (param $col i32)
        (call $setPiece
            (local.get $row)
            (local.get $col)
            (global.get $currentTurn)
        )
        (call $advanceTurn)
    )

    ;; Retrieves the value of the piece at a given position on
    ;; the board. No error checking done here.
    (func $getPiece (param $row i32) (param $col i32) (result i32)
        (i32.load
            (call $offsetForPosition
                (local.get $row)
                (local.get $col)
            )
        )
    )

    ;; Called to switch the current turn
    (func $advanceTurn
        (if (i32.eq (global.get $currentTurn) (global.get $X))
            (then (global.set $currentTurn (global.get $Y)))
            (else (global.set $currentTurn (global.get $X)))
        )
    )

    (func $getCurrent (result i32)
        (global.get $currentTurn)
    )

    ;; Initializes the game board
    (func $initGame
        (local $r i32)
        (local $c i32)

        (block
            (loop
                                
                (local.set $r (i32.const 0))
                (block
                    (loop
                        (call $setPiece
                            (local.get $r)
                            (local.get $c)
                            (global.get $EMPTY)
                        )
                        (local.set $c (call $inc (local.get $c)))
                        (br_if 1 (i32.eq (local.get $c) (i32.const 3)))
                        (br 0)
                    )
                )

                (local.set $r (call $inc (local.get $r)))
                (br_if 1 (i32.eq (local.get $r) (i32.const 3)))
                (br 0)
            )
        )        
    )

    ;; Shortcut for adding 1
    (func $inc (param $a i32) (result i32)
        (i32.add
            (local.get $a)
            (i32.const 1)
        )
    )

    (export "initGame" (func $initGame))
    (export "getPiece" (func $getPiece))
    (export "currentTurn" (func $getCurrent))
    (export "takeTurn" (func $takeTurn))
    (export "memory" (memory $mem))
)