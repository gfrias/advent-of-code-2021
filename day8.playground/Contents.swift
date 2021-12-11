import Foundation

let filepath = Bundle.main.path(forResource: "input", ofType: "txt")!
//let filepath = "/tmp/input.txt"

let lines = try String(contentsOfFile: filepath).split(separator: "\n").map {$0.components(separatedBy: " | ").map{$0.split(separator: " ").map{String($0)}}}


func challenge1(_ lines:[[[String]]]) -> Int {
    let uniques = Set([2,4,3,7])  //1,4,7,8
    
    return lines.flatMap{$0[1].map{$0.count}.filter{uniques.contains($0)}}.count
}

func findDifferent<T>(_ candidates: [Set<T>], _ target: Set<T>) -> Set<T>{
    if candidates[0].union(candidates[1]) == target {
        return candidates[2]
    } else if candidates[1].union(candidates[2]) == target {
        return candidates[0]
    } else {
        return candidates[1]
    }
}

func decode(_ line:[[String]]) -> Int {
    let sets = line[0].map{Set($0)}
    
    var mappings = sets.reduce(into:[Int:Set<String.Element>]()) { (acc, st) in
        let bars = [2:1, 4:4, 3:7, 7:8]
        
        if let n = bars[st.count] {
            acc[n] = st
        }
    }
    
    let segments5 = sets.filter{$0.count == 5}
    
    mappings[3] = findDifferent(segments5, mappings[8]!)
    mappings[2] = segments5.filter{$0.union(mappings[4]!) == mappings[8]}[0]
    mappings[5] = segments5.filter{$0 != mappings[2] && $0 != mappings[3]}[0]
    
    let segments6 = sets.filter{$0.count == 6}
    
    mappings[9] = mappings[3]!.union(mappings[4]!)
    mappings[6] = segments6.filter{$0.union(mappings[7]!) == mappings[8]}[0]
    mappings[0] = segments6.filter{$0 != mappings[9] && $0 != mappings[6]}[0]
    
    let invMappings = mappings.reduce(into: [Set:Int]()) { (acc, el) in
        acc[el.value] = el.key
    }
    
    return line[1].compactMap{invMappings[Set($0)]}.reduce(0) { (acc, d) in
        acc*10+d
    }
}

func challenge2(_ lines:[[[String]]]) -> Int {
    lines.map{decode($0)}.reduce(0,+)
}

print(challenge1(lines))
print(challenge2(lines))

