//
//  IDXTests.swift
//  LoaderIDXTests
//
//  Created by Marcus Florentin on 25/10/2019.
//

import XCTest
@testable import LoaderIDX

final class IDXTests: XCTestCase {

	func testFileLoading() throws {

		// Testing the creation of the interface for a labels file
		XCTAssertNoThrow(try IDX(try file(named: "t10k-labels.idx1-ubyte")), "Can't load IDX class with data")


		// Testing the creation of the interface for a images file
		XCTAssertNoThrow(try IDX(try file(named: "t10k-images.idx3-ubyte")), "Can't load IDX class with data")
	}

	func testFileInformationLabel() throws {
		let data = try file(named: "t10k-labels.idx1-ubyte")

		var file : IDX!

		// Testing the creation of the interface.
		XCTAssertNoThrow(file = try IDX(data), "Can't load IDX class with data")


		// Testing if the file as usigned bytes data.
		XCTAssertEqual(file.byte, IDX.ByteType.unsigned, "The file data are not unsigned bytes")

		// Testing if the file as one depth values
		XCTAssertEqual(file.depth, IDX.Depth.vector, "The file has a wrong data dimension")

		// Verify the file info amount of data.
		XCTAssertEqual(file.count, 10_000, "The file info count isn't 10 000")

		// Verify that the interface doesn't have a dimension.
		XCTAssert(file.dimension.isEmpty, "The file has a dimension")

		// Verify that the value have a size of one.
		XCTAssertEqual(file.valueSize, 1, "The value are not right size")

	}

	func testFileInformationImage() throws {
		let data = try file(named: "t10k-images.idx3-ubyte")

		var file : IDX!

		// Testing the creation of the interface.
		XCTAssertNoThrow(file = try IDX(data), "Can't load IDX class with data")

		// Testing if the file as usigned bytes data.
		XCTAssertEqual(file.byte, IDX.ByteType.unsigned, "The file data are not unsigned bytes")

		// Testing if the file as 3 depth values
		XCTAssertEqual(file.depth, IDX.Depth.images, "The file has a wrong data dimension")

		// Verify the file info amount of data.
		XCTAssertEqual(file.count, 10_000, "The file info count isn't 10 000")

		// Verify that the interface have a dimension.
		XCTAssertFalse(file.dimension.isEmpty, "The file has a dimension")

		// Verify that the value have a size of one.
		XCTAssertEqual(file.valueSize, 1 * 28 * 28, "The value are not right size")

	}



	static var allTests = [
		("testFileLoading", testFileLoading),
		("testFileInformation", testFileInformationLabel),
		("testFileInformationImage", testFileInformationImage)
	]
}
