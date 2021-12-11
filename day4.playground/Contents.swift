import Foundation

let SIZE = 5
typealias InvertedBoard = [Int: (Int, Int)]

let filepath = Bundle.main.path(forResource: "input", ofType: "txt")!
let lines = try String(contentsOfFile: filepath).split(separator: "\n")

let numbers = lines[0].split(separator: ",").compactMap{Int($0)}
let rows = lines[1...].map{$0.split(separator: " ").compactMap{Int($0)}}
let boards = rows.enumerated().reduce(Array(repeating: [[Int]](), count: rows.count/SIZE)) { (acc, pair) in
    var newAcc = acc
    newAcc[pair.offset/SIZE].append(pair.element)
    
    return newAcc
}

func invertBoard(_ board: [[Int]]) -> InvertedBoard {
    board.enumerated().reduce(InvertedBoard()) { (rowAcc, rowPair) in
        rowPair.element.enumerated().reduce(rowAcc) { (elAcc, elPair) in
            var newElAcc = elAcc
            newElAcc[elPair.element] = (rowPair.offset, elPair.offset)
            return newElAcc
        }
    }
}

func buildScoreTable(_ numBoards: Int) -> [[Int]] {
    Array(repeating: Array(repeating: 0, count: SIZE), count: numBoards)
}

func challenge1(_ boards: [[[Int]]], _ numbers: [Int], _ winnerNumber:Int = 1) -> Int {
    var invBoards = boards.map { invertBoard($0) }
    let numBoards = invBoards.count

    var rowsByBoard = buildScoreTable(numBoards)
    var colsByBoard = buildScoreTable(numBoards)
    
    var winners = Array(repeating: false, count: numBoards)

    for n in numbers {
        for i in (0..<numBoards) {
            if let (row, col) = invBoards[i][n] {
                invBoards[i][n] = nil
                rowsByBoard[i][row] += 1
                colsByBoard[i][col] += 1
                
                if rowsByBoard[i][row] == SIZE || colsByBoard[i][col] == SIZE {
                    winners[i] = true
                    if winners.filter({$0}).count == winnerNumber {
                        return n * invBoards[i].map{$0.key}.reduce(0,+)
                    }
                }
            }
        }
    }
    
    return -1
}

func challenge2(_ boards: [[[Int]]], _ numbers: [Int]) -> Int {
    challenge1(boards, numbers, boards.count)
}

print(challenge1(boards, numbers))
print(challenge2(boards, numbers))
