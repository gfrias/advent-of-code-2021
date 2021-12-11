import Foundation

let filepath = Bundle.main.path(forResource: "sample", ofType: "txt")!
//let filepath = "/tmp/input.txt"

let matrix = try String(contentsOfFile: filepath).split(separator: "\n").map{ $0.compactMap{ Int(String($0)) } }

func neighbours(_ r:Int, _ c:Int, _ rows:Int, _ cols:Int) -> [(Int, Int)] {
    let deltas = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    
    return deltas.map{ (i,j) in (i+r, j+c) }.filter { (i, j) in
       i >= 0 && i < rows && j >= 0 && j < cols
    }
}

func lowPoints(_ matrix: [[Int]]) -> [(Int, Int)] {
    let (rows, cols) = (matrix.count, matrix[0].count)

    return (0..<rows).flatMap { r in
        (0..<cols).compactMap { c in
            let mn: Int = neighbours(r, c, rows, cols).map { (i,j) in matrix[i][j] }.min()!

            return matrix[r][c] < mn ? (r, c) : nil
        }
    }
}

func challenge1(_ matrix: [[Int]]) -> Int {
    lowPoints(matrix).map{ (i, j) in
        matrix[i][j] + 1
    }.reduce(0, +)
}

func flood(_ matrix: [[Int]], _ r:Int, _ c:Int, _ rows:Int, _ cols:Int, _ visited: inout [[Bool]]) -> Int {
    if matrix[r][c] < 9 && !visited[r][c] {
        visited[r][c] = true
        return 1 + neighbours(r, c, rows, cols).map { (i,j) in
            flood(matrix, i, j, rows, cols, &visited)
        }.reduce(0, +)
    }
    return 0
}

func challenge2(_ matrix: [[Int]]) -> Int {
    let (rows, cols) = (matrix.count, matrix[0].count)
    var visited = Array(repeating: Array(repeating: false, count: cols), count: rows)
    
    return lowPoints(matrix).map { (i, j) in
        flood(matrix, i, j, rows, cols, &visited)
    }.sorted().reversed()[...2].reduce(1, *)
}

print(challenge1(matrix))
print(challenge2(matrix))
