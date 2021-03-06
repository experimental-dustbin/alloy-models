open util/relation
// https://dev.to/davidk01/solving-8-queens-puzzle-with-alloy-1g14
// N Queens: https://en.wikipedia.org/wiki/Eight_queens_puzzle

// Queens are placed on boards.
some sig Queen { }
// The coordinates on the board.
let positions = { i: Int, j: Int | 0 <= i && i <= 7 && 0 <= j && j <= 7 }
// Each position can have at most one queen occupying it and each queen
// has exactly one position assigned.
one sig Board { queens: positions one -> lone Queen }
// Absolute value difference for comparing diagonal attack positions.
fun absDifference(m: Int, n: Int): Int {
  let difference = minus[m, n] {
    difference > 0 => difference else minus[0, difference]
  }
}
// Attack relationship in terms of coordinates.
pred attacks(q1: (Int -> Int), q2: (Int -> Int)) {
  let q1row = dom[q1], q1col = ran[q1],
    q2row = dom[q2], q2col = ran[q2],
    rowDifference = absDifference[q1row, q2row],
    colDifference = absDifference[q1col, q2col] {
    // Same row attacks
    rowDifference = 0 ||
    // Same column attacks
    colDifference = 0 ||
    // Diagonal attacks
    rowDifference = colDifference
  }
}
// Make sure no two queens attack each other.
fact notAttacking {
  all disj q1, q2: Queen | !attacks[Board.queens.q1, Board.queens.q2]
}
// Make sure every queen is assigned a position on the board. I think this is
// redundant and follows from Board signature
// assert assignedPosition { all q: Queen | one Board.queens.q }
// Run
run { } for 1 Board, exactly 8 Queen
