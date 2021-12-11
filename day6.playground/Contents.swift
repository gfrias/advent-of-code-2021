import Foundation

let filepath = Bundle.main.path(forResource: "input", ofType: "txt")!

let ages = try String(contentsOfFile: filepath).split(separator: "\n").flatMap{
    $0.split(separator: ",").compactMap{Int($0)}
}

let creationAge = 8
let rebirthAge = 6
let maxAge = max(creationAge, rebirthAge)

func nextDay(_ ages: [Int]) -> [Int] {
    ages.flatMap { age in
        age > 0 ? [age-1] : [creationAge, rebirthAge]
    }
}

func challenge1(_ ages: [Int], _ days: Int) -> Int {
    (1...days).reduce(ages) { (ages, _) in
        nextDay(ages)
    }.count
}

func nextDay2(_ countByAges: [Int]) -> [Int] {
    countByAges.enumerated().reversed().reduce(into: Array(repeating: 0, count: maxAge+1)) { (acc, count) in
        if count.offset == 0 {
            acc[rebirthAge] += count.element
            acc[creationAge] = count.element
        } else {
            acc[count.offset-1] = count.element
        }
    }
}

func challenge2(_ ages: [Int], _ days: Int) -> Int {
    let countByAges = ages.reduce(into: Array(repeating: 0, count: maxAge+1)) { (acc, age) in
        acc[age] += 1
    }
    
    return (1...days).reduce(countByAges) { (counts, d) in
        nextDay2(counts)
    }.reduce(0,+)
}

print(challenge1(ages, 18))
print(challenge2(ages, 256))
