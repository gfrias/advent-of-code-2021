import Foundation

let filepath = Bundle.main.path(forResource: "puzzle", ofType: "txt")!

let numbers = try String(contentsOfFile: filepath).split(separator: "\n").map {
    Array($0).compactMap{c in
        Int(String(c))
    }
}

func mostCommon(_ numbers:[[Int]], _ i: Int) -> Int {
    let ones = numbers.reduce(0) { (acc, number) in
        acc + number[i]
    }
    return 2*ones >= numbers.count ? 1: 0
}

func leastCommon(_ numbers:[[Int]], _ i: Int) -> Int {
    1 - mostCommon(numbers, i)
}

func decode(_ number:[Int]) -> Int {
    let length = number.count
    
    return number.enumerated().map { (i, bit) in
        bit * (1 << (length-1-i))
    }.reduce(0, +)
}

func challenge1(_ numbers:[[Int]]) -> Int {
    let length = numbers[0].count
    
    let mostCommons = (0..<length).map { mostCommon(numbers, $0) }
  
    let gamma = decode(mostCommons)
    let epsilon = (~gamma) & ((1<<length)-1)
    
    return gamma*epsilon
}

func gas(_ numbers:[[Int]], _ i:Int, _ criteria:([[Int]], Int) -> Int) -> Int {
    if numbers.count == 1 {
        return decode(numbers.first!)
    }

    let bitByCriteria = criteria(numbers, i)
    
    return gas(numbers.filter{$0[i] == bitByCriteria}, i+1, criteria)
}

func challenge2(_ numbers:[[Int]]) -> Int {
    let o2 = gas(numbers, 0, mostCommon)
    let co2 = gas(numbers, 0, leastCommon)
    
    return o2*co2
}

print(challenge1(numbers))
print(challenge2(numbers))
