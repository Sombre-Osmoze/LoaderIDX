import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LoaderIDXTests.allTests),
		testCase(IDXTests.allTests),
    ]
}
#endif
