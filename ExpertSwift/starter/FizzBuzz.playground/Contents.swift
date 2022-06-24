/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift
///
///
struct FizzBuzz: Collection {
    
    typealias Index = Int
    
    var startIndex: Index { 1 }
    var endIndex: Index { 101 }
//    func index(after i: Index) -> Index {
//        print("Calling \(#function) with \(i)")
//        return i + 1
//    }
    
    // .... subscript with index ....
    subscript (index: Index) -> String {
        
        precondition(indices.contains(index), "out of 1-100")
        
        switch (index.isMultiple(of: 3), index.isMultiple(of: 5)) {
        case (false, false):
            return String(index)
        case (true, false):
            return "Fizz"
        case (false, true):
            return "Buzz"
        case (true, true):
            return "FizzBuzz"
        }
    }
}

extension FizzBuzz: BidirectionalCollection {
//    func index(before i: Index) -> Index {
//        print("Calling \(#function) with \(i)")
//        return i - 1
//    }
}

extension FizzBuzz: RandomAccessCollection {
    
}


let fizzBuzz = FizzBuzz()
for value in fizzBuzz {
    print(value, terminator: " ")
}
//print()
//
//let fizzBuzzPositions =
//fizzBuzz.enumerated().reduce(into: []) { list, item in
//    if item.element == "FizzBuzz" {
//        list.append(item.offset + fizzBuzz.startIndex)
//    }
//}
//
//print(fizzBuzzPositions)

print(fizzBuzz.dropLast(40).count)

