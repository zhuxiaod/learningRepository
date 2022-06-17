/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

struct CountdownIterator: IteratorProtocol {
    var count: Int
    mutating func next() -> Int? {
        guard count >= 0 else {  // 1
            return nil
        }
        defer { count -= 1 }     // 2
        return count
    }
}

struct Countdown: Sequence {
    let start: Int
    func makeIterator() -> CountdownIterator {
        CountdownIterator(count: start)
    }
}

for value in Countdown(start: 5) {
    print(value)
}

print("---")
for value in stride(from: 5, through: 0, by: -1) {
    print(value)
}
print("---")
for value in stride(from: 5, to: -1, by: -1) {
    print(value)
}

//UnfoldFirstSequence 和 UnfoldSequence
let countDownFrom5 = sequence(first: 5) { value in
    value-1 >= 0 ? value-1 : nil
}
print("---")
for value in countDownFrom5 {
    print(value)
}

let countDownFrom5State = sequence(state: 5) { (state: inout Int) -> Int? in
  defer { state -= 1 }
  return state >= 0 ? state : nil
}
print("---")
for value in countDownFrom5State {
  print(value)
}

//使用 AnySequence 进行类型擦除
extension Sequence {
    func eraseToAnySequence() -> AnySequence<Element> {
        AnySequence(self)
    }
}

let seq = countDownFrom5State.eraseToAnySequence()
print("---")
for value in seq {
    print(value)
}
print(type(of: countDownFrom5State))
print(type(of: seq))

//使用 AnySequence 和 AnyIterator 实现序列
let anotherCountdown5 = AnySequence<Int> { () -> AnyIterator<Int> in
    var count = 5
    return AnyIterator<Int> {
        defer { count -= 1}
        return count >= 0 ? count : nil
    }
}

print("---")
for value in anotherCountdown5 {
    print(value)
}

