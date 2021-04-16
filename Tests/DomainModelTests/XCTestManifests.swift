import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DomainModelTests.allTests),
        testCase(JobTests.allTests),
        testCase(MoneyTests.allTests),
        testCase(PersonTests.allTests),
    ]
}
#endif
