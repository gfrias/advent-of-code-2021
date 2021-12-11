import Foundation

let filepath = Bundle.main.path(forResource: "sample", ofType: "txt")!
//let filepath = "/tmp/input.txt"

let positions = try String(contentsOfFile: filepath).split(separator: "\n").flatMap{
    $0.split(separator: ",").compactMap{Int($0)}
}

func challenge(_ positions: [Int], _ fuel:(Int, Int) -> Int) -> Int {
    (0...positions.max()!).reduce(Int.max) { (mn, pos) in
        min(mn, positions.map{fuel($0, pos)}.reduce(0, +))
    }
}

func challenge1(_ positions: [Int]) -> Int {
    challenge(positions) { abs($0-$1) }
}

func challenge2(_ positions: [Int]) -> Int {
    challenge(positions) {
        let Δ = abs($0-$1)
        return Δ*(Δ+1)/2
    }
}

print(challenge1(positions))
print(challenge2(positions))
