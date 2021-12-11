import Foundation

let filepath = Bundle.main.path(forResource: "sample", ofType: "txt")!
let lines = try String(contentsOfFile: filepath).split(separator: "\n")

typealias Point = (Int, Int)
typealias Line = (Point, Point)

let coords = lines.map{ line -> (Point, Point) in
    let comps = line.components(separatedBy: " -> ").map{ pair -> Point in
        let comps = pair.split(separator: ",").compactMap {Int($0)}
        return (comps[0], comps[1])
    }
    return (comps[0], comps[1])
}

func initMatrix(_ coords: [Line]) -> [[Int]] {
    let maxY = coords.flatMap{ (orig, dest) in
        [orig.0, dest.0]
    }.max()!

    let maxX = coords.flatMap{ (orig, dest) in
        [orig.1, dest.1]
    }.max()!

    return Array(repeating: Array(repeating: 0, count: maxX+1), count: maxY+1)
}

func increasingRange(_ from: Int, _ through: Int) -> ClosedRange<Int>{
    min(from, through)...max(from, through)
}

func expandLine(_ line: Line) -> [Point] {
    let ((y0, x0), (y1, x1)) = line

    if x0 == x1 {
        return increasingRange(y0, y1).map {($0, x0)}
    }

    let delta = Double(x0 - x1)
    let m = Int(Double(y0 - y1)/delta)
    let b = Int(Double(x0*y1-x1*y0)/delta)

    return increasingRange(x0, x1).map { x in
        (m*x+b, x)
    }
}

func challenge1(_ coords: [Line]) -> Int {
    challenge2(coords.filter{ (orig, dest) in
        orig.0 == dest.0 || orig.1 == dest.1
    })
}

func challenge2(_ coords: [Line]) -> Int {
    let points = coords.flatMap{expandLine($0)}
    
    let matrix = points.reduce(into: initMatrix(coords)) { (acc, point) in
        let (y, x) = point
        acc[y][x] += 1
    }

    return matrix.flatMap{$0}.filter{$0 > 1}.count
}

print(challenge1(coords))
print(challenge2(coords))
