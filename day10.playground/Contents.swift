import Foundation

let filepath = Bundle.main.path(forResource: "input", ofType: "txt")!
//let filepath = "/tmp/input.txt"

let lines = try String(contentsOfFile: filepath).split(separator: "\n").map{String($0)}

let openings: [Character:Character] =  [")": "(", "]": "[", "}": "{", ">": "<"]
let closings: [Character:Character] =  ["(": ")", "[": "]", "{": "}", "<": ">"]
let faultScores: [Character?: Int] = [")": 3, "]": 57, "}": 1197, ">": 25137]
let missingScores: [Character: Int] = [")": 1, "]": 2, "}": 3, ">": 4]

func firstInvalid(_ line: String) -> (Character?, [Character]) {
    var stack = [Character]()
    
    let invalid = line.first(where: { c in
        switch(c) {
            case "(", "[", "{", "<":
                stack.append(c)
            case ")", "]", "}", ">":
                guard let top = stack.last, top == openings[c] else {
                    return true
                }
                stack.removeLast()
            default:
                assert(false, "unexpected character: '\(c)'")
        }
        return false
    })
    
    return (invalid, stack)
}

func challenge1(_ lines: [String]) -> Int {
    lines.compactMap { line in
        faultScores[firstInvalid(line).0]
    }.reduce(0, +)
}

func challenge2(_ lines: [String]) -> Int {
    let scores = lines.compactMap { (line:String) in
        let (invalid, stack) = firstInvalid(line)
        
        return invalid == nil ? stack : nil
    }.map { (stack:[Character]) in
        stack.compactMap{ c in closings[c] }
             .compactMap{ c in missingScores[c] }
             .reversed()
             .reduce(0) { (total, score) in 5*total+score }
    }.sorted()
    
    return scores[scores.count/2]
}

print(challenge1(lines))
print(challenge2(lines))
