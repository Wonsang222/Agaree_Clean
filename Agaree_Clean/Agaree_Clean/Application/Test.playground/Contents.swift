import UIKit



protocol Testqueue {
    func execution(completion: @escaping () -> Void)
}

extension DispatchQueue: Testqueue {
    func execution(completion: @escaping () -> Void) {
        async(group: nil, execute: completion)
    }
}


func test(on queue: Testqueue, completion: @escaping (String) -> Void) {
    queue.execution {
        completion("hahaah")
        print(Thread.isMainThread)
    }
}


test(on: DispatchQueue.main) { text in
    print(text)
}

test(on: DispatchQueue.global()) { text in
    print(text)
}


