import Foundation

let filepath = Bundle.main.path(forResource: "day1", ofType: "txt")!

let nums = try String(contentsOfFile: filepath).split(separator: "\n").compactMap{Int($0)}

func challenge1(_ nums:[Int]) -> Int {
    zip(nums, nums[1...]).filter{$0.1 > $0.0}.count
}

func challenge2(_ nums:[Int]) -> Int {
    let sums = zip(zip(nums, nums[1...]), nums[2...]).map {$0.0.0 + $0.0.1 + $0.1}
    return challenge1(sums)
}

print(challenge1(nums))
print(challenge2(nums))
