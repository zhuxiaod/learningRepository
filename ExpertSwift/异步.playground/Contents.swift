import UIKit
import SwiftUI
//
////基本任务
//Task {
//    print("Doing some work on a task")
//}
//print("Doing some work on the main actor")
//
////更改顺序
//Task {
//    print("Doing some work on a task")
//    let sum = (1...100).reduce(0, +)
//    print("1 + 2 + 3 ... 100 = \(sum)")
//}
//
//print("Doing some work on the main actor")
//
////取消任务-需要手动取消
//let task = Task {
//    print("Doing some work on a task")
//    let sum = (1...100).reduce(0, +)
//    //接收任务，如果受到停止相当于跳出
//    try Task.checkCancellation()
//    print("1 + 2 + 3 ... 100 = \(sum)")
//}
//
//print("Doing some work on the main actor")
////task.cancel()
//
////暂停任务 异步执行
//Task {
//    print("Hello")
//    try await Task.sleep(nanoseconds: 1_000_000_000)
//    print("Goodbye")
//}
//
////放在函数中运行
//func helloPauseGoodbye() async throws {
//    print("Hello")
//    try await Task.sleep(nanoseconds: 1_000_000_000)
//    print("Goodbye")
//}
//
//
//
//struct Domains: Decodable {
//    let data: [Domain]
//}
//
//struct Domain: Decodable {
//    let attributes: Attributes
//}
//
//struct Attributes: Decodable {
//    let name: String
//    let description: String
//    let level: String
//}
//
//func fetchDomains() async throws -> [Domain] {
//    // 1
//    let url = URL(string: "https://api.raywenderlich.com/api/domains")!
//    // 2
//    let (data, _) = try await URLSession.shared.data(from: url)
//    // 3
//    return try JSONDecoder().decode(Domains.self, from: data).data
//}
//
//
//Task {
//    do{
//        let p = try await fetchDomains()
//        for pModel: Domain in p {
//            print("name:\(pModel.attributes.name) description:\(pModel.attributes.description) level:\(pModel.attributes.level)")
//        }
//    }catch{
//        print(error)
//    }
//}
//
//func findTitle(url: URL) async throws -> String? {
//    for try await line in url.lines {
//        if line.contains("<title>") {
//            return line.trimmingCharacters(in: .whitespaces)
//        }
//    }
//    return nil
//}
//
//Task {
//  if let title = try await findTitle(url: URL(string:
//                                     "https://www.raywenderlich.com")!) {
//    print(title)
//  }
//}
//
//func findTitlesSerial(first: URL, second: URL) async throws -> (String?,
//                                                                String?) {
//    let title1 = try await findTitle(url: first)
//    let title2 = try await findTitle(url: second)
//    return (title1, title2)
//}
//
//Task {
//    let (a,b) = try await findTitlesSerial(first: URL(string: "https://www.raywenderlich.com")!, second: URL(string: "https://www.baidu.com")!)
//    print((a,b))
//}
//
//extension Domains {
//    static var domains: [Domain] {
//        get async throws {
//            try await fetchDomains()
//        }
//    }
//}
//
//Task {
//    dump(try await Domains.domains)
//}
//
//extension Domains {
//    enum Error: Swift.Error { case outOfRange }
//
//    static subscript(_ index: Int) -> String {
//        get async throws {
//            let domains = try await Self.domains
//            guard domains.indices.contains(index) else {
//                throw Error.outOfRange
//            }
//            return domains[index].attributes.name
//        }
//    }
//}
//
//Task {
//    dump(try await Domains[4])  // "Unity", as of this writing
//}

// 1
actor Playlist {
    let title: String
    let author: String
    private(set) var songs: [String]
    
    init(title: String, author: String, songs: [String]) {
        self.title = title
        self.author = author
        self.songs = songs
    }
    
    //添加音乐
    func add(song: String) {
        songs.append(song)
    }
    
    //移除
    func remove(song: String) {
        guard !songs.isEmpty, let index = songs.firstIndex(of: song) else {
            return
        }
        songs.remove(at: index)
    }
    
    //移除后添加
    func move(song: String, from playlist: Playlist) async {
        await playlist.remove(song: song)
        add(song: song)
    }
    
    //添加后移除
    func move(song: String, to playlist: Playlist) async {
        await playlist.add(song: song)
        remove(song: song)
    }
}

//喜爱列表
let favorites = Playlist(title: "Favorite songs",
                         author: "Cosmin",
                         songs: ["Nothing else matters"])

//聚会列表
let partyPlaylist = Playlist(title: "Party songs",
                             author: "Ray",
                             songs: ["Stairway to heaven"])
Task {
    await favorites.move(song: "Stairway to heaven", from: partyPlaylist)
    await favorites.move(song: "Nothing else matters", to: partyPlaylist)
    await print(favorites.songs)
}

extension Playlist: CustomStringConvertible {
    nonisolated var description: String {
        "\(title) by \(author)."
    }
}

print(favorites) // "Favorite songs by Cosmin."

final class BasicPlaylist {
    let title: String
    let author: String
    
    init(title: String, author: String) {
        self.title = title
        self.author = author
    }
}

extension BasicPlaylist: Sendable {}

// 1
func execute(task: @escaping @Sendable () -> Void,
             with priority: TaskPriority? = nil) {
    Task(priority: priority, operation: task)
}

// 2
@Sendable func showRandomNumber() {
    let number = Int.random(in: 1...10)
    print(number)
}

execute(task: showRandomNumber)

var name: String? = "Ray"
//var age: Int = nil
let distance: Float = 26.7
var middleName: String? = nil
