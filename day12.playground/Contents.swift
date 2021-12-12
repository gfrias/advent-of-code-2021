import Foundation
import Darwin

let filepath = Bundle.main.path(forResource: "sample3", ofType: "txt")!
//let filepath = "/tmp/sample.txt"
typealias AdjDict = [String:Set<String>]

let links = try String(contentsOfFile: filepath).split(separator: "\n").map{ $0.split(separator: "-").map{ String($0) } }
let caves = Array(links.flatMap{$0}.reduce(into:Set<String>()) { (st, el) in st.insert(el) })

func buildAdjDict(_ links: [[String]], _ caves: [String]) -> AdjDict {
    links.reduce(AdjDict()) { (dict, link) in
        (0..<link.count).reduce(into: dict) { (d, i) in
            var set = d[link[i]] ?? Set<String>()
            set.insert(link[1-i])
            d[link[i]] = set
        }
    }
}

func traverse(_ dict: AdjDict, _ cave: String, _ visited:[String:Int], _ limit:(String, Int) -> Int) -> Int {
    if cave == "end" {
        return 1
    }
    
    guard let caves = dict[cave] else {
        assert(false, "cave unknown \(cave)")
        return 0
    }
    
    var newVisited = visited
    
    if cave.lowercased() == cave {
        newVisited[cave, default: 0] += 1
    }

    let maxSeen = newVisited.values.max() ?? 0
    
    return caves.filter{ c in newVisited[c, default: 0] < limit(c, maxSeen) }
                .map{ c in traverse(dict, c, newVisited, limit) }
                .reduce(0, +)
}

func challenge(_ links: [[String]], _ caves: [String], _ limit:(String, Int) -> Int) -> Int {
    traverse(buildAdjDict(links, caves), "start", [String: Int](), limit)
}

func challenge1(_ links: [[String]], _ caves: [String]) -> Int {
    challenge(links, caves) { _, _ in 1 }
}

func challenge2(_ links: [[String]], _ caves: [String]) -> Int {
    challenge(links, caves) { cave, maxSeen in
        if cave == "start" {
            return 1
        }
        return maxSeen < 2 ? 2: 1
    }
}

print(challenge1(links, caves))
print(challenge2(links, caves))

