import Foundation
import Darwin

let filepath = Bundle.main.path(forResource: "input", ofType: "txt")!
//let filepath = "/tmp/sample.txt"

struct Location: Hashable {
    let row: Int
    let col: Int
}

let energies = try String(contentsOfFile: filepath).split(separator: "\n").map{line in line.compactMap{c in Int(String(c))}}

let (ROWS, COLS, CYCLES) = (10, 10, 100)

func neighbours(_ location: Location) -> [Location] {
    let incs = [-1, 0, 1]
    let positions:[(Int, Int)] = incs.flatMap{row in incs.map{col in (location.row+row, location.col+col)}}
        .filter{(row, col) in row != location.row || col != location.col}
        .filter{(row, col) in row >= 0 && col >= 0 && row < ROWS && col < COLS}
    
    return positions.map{(row, col) in Location(row: row, col: col)}
}

func nextStep(_ energies: [[Int]]) -> (Int, Int, [[Int]]) {
    var flashing = Set<Location>()
    var updates = [Location]()
    var zeroes = 0
    
    var newEnergies:[[Int]] = energies.enumerated().map { (i: Int,row:[Int]) in
        row.enumerated().map { (j: Int, energy:Int) in
            let newEnergy = energy+1
            
            if newEnergy > 9 {
                let location = Location(row: i, col: j)
                flashing.insert(location)
                updates.append(contentsOf: neighbours(location))
                zeroes += 1
                return 0
            }
            return newEnergy
        }
    }
    
    while !updates.isEmpty {
        updates = updates.reduce(into: [Location]()) { (newUpdates, location) in
            if !flashing.contains(location) {
                newEnergies[location.row][location.col] += 1

                if newEnergies[location.row][location.col] > 9 {
                    flashing.insert(location)
                    zeroes += 1
                    newUpdates.append(contentsOf: neighbours(location))
                    
                    newEnergies[location.row][location.col] = 0
                }
            }
        }
    }
    
    return (zeroes, flashing.count, newEnergies)
}

func printEnergies(_ energies: [[Int]]) {
    for row in energies {
        print(row)
    }
    print("")
}

func challenge1(_ energies: [[Int]]) -> Int {
    var currEnergies = energies
    
    return (1...CYCLES).reduce(0) { (totalFlashes, i) in
        let (_, newFlashes, newEnergies) = nextStep(currEnergies)
        currEnergies = newEnergies
        
        if i < 11 {
            print("i: \(i)")
            printEnergies(currEnergies)
        }

        return totalFlashes+newFlashes
    }
}

func challenge2(_ energies: [[Int]]) -> Int {
    var currEnergies = energies
    var i = 0
    var totalZeroes = 0
    
    while (totalZeroes < ROWS*COLS) {
        let (zeroes, _, newEnergies) = nextStep(currEnergies)
        currEnergies = newEnergies
        totalZeroes = zeroes
        i += 1
    }
    
    return i
}

//print(challenge1(energies))
print(challenge2(energies))
