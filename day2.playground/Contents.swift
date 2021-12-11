import Foundation

let filepath = Bundle.main.path(forResource: "puzzle", ofType: "txt")!

let commands = try String(contentsOfFile: filepath).split(separator: "\n").map{parse($0)}

func parse(_ line:String.SubSequence) -> [Int] {
    let cmd = line.split(separator: " ")
    
    let val = Int(cmd[1])!
    
    switch(cmd[0]) {
        case "forward":
            return [val, 0]
        case "down":
            return [0, val]
        case "up":
            return [0, -val]
        default:
            fatalError("unknown command \(cmd[0])")
    }
}

func challenge1(_ commands:[[Int]]) -> Int {
    commands.reduce([0, 0]) { acc, res in
        [acc[0]+res[0], acc[1]+res[1]]
    }.reduce(1, *)
}

func challenge2(_ commands:[[Int]]) -> Int {
    commands.reduce([0, 0, 0]) { (acc:[Int], res:[Int]) in
        [acc[0]+res[0], acc[1]+res[0]*acc[2], acc[2]+res[1]]
    }.dropLast().reduce(1, *)
}

print(challenge1(commands))
print(challenge2(commands))
