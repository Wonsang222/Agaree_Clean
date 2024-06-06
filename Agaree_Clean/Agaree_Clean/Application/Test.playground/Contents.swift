import UIKit

enum TestError: Error {
    case Testing
}

enum TestError2: Error {
    case Testing2
}


func Test() throws {
    do {
        
    } catch {
        
    }
}

func insideTest() throws {
    do {
        try insideTest2()
    } catch {
        throw TestError2.Testing2
    }
    
}

func insideTest2() throws {
    throw TestError.Testing
}

do {
    try  insideTest()
} catch {
    print(error)
}
