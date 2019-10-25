//
//  IDX.swift
//  LoaderIDX
//
//  Created by Marcus Florentin on 25/10/2019.
//

import Foundation

public class IDX {

	init(_ data: Data) throws {
		// Verify that we have data and file information
		let infoSizeInt = MemoryLayout<Int32>.stride

		guard !data.isEmpty && data.count > infoSizeInt else { throw FileError.fileEmpty }

		// Magic Number

		byte = ByteType(rawValue: data[data.startIndex + 2]) ?? .unknown
		// TODO: Handle bytes type

		depth = Depth(rawValue: Int(data[data.startIndex + 3])) ?? .unknown


		// Information

		/// Skipping *magic number* information then fetching.
		let detail = data.dropFirst(infoSizeInt).prefix(infoSizeInt * depth.rawValue)

		count = Int(detail.withUnsafeBytes({ CFSwapInt32BigToHost($0.load(as: UInt32.self)) }))

		var dim : [UInt32] = []

		if depth != .vector, depth != .unknown {
			for info in 1..<depth.rawValue {
				dim.append(detail.dropFirst(info * infoSizeInt).withUnsafeBytes({ CFSwapInt32BigToHost($0.load(as: UInt32.self)) }))
			}
		}
		dimension = dim.map({ Int($0) })

		// Values

		self.data = data.dropFirst(infoSizeInt * (depth.rawValue + 1))

		valueSize = dimension.reduce(1, *) * IDX.size(byte)

		// Checks
		let total = valueSize * count
		guard self.data.count >= total else { throw FileError.Data.notEnough }

		guard self.data.count == total else { throw FileError.Data.tooMuch }
	}

	// MARK: - Collection

	/// The number of value.
	public let count : Int

	/// T
	public let valueSize : Int


	// MARK: - Bytes Type

	public let byte : ByteType

	/// The bytes types of the values
	public enum ByteType: UInt8 {
		case unsigned = 0x08
		case signed = 0x09
		case short = 0x0B
		case int = 0xC
		case float = 0x0D
		case double = 0x0E
		/// Unkwown byte type.
		/// - important: The behavior of the class can't be unpredictable.
		case unknown
	}

	/// Get the size of the value data type.
	/// - Parameter type: The type to get the size.
	/// - Returns: The bytes in bit of the type.
	private class func size(_ type: ByteType) -> Int {

		switch type {
		case .unsigned: return MemoryLayout<UInt8>.stride

		case .signed: return MemoryLayout<Int8>.stride

		case .short: return MemoryLayout<CShort>.stride

		case .int: return MemoryLayout<Int32>.stride

		case .float: return MemoryLayout<Float>.stride

		case .double: return MemoryLayout<Double>.stride

		default:
			return MemoryLayout<UInt8>.stride
		}
	}

	// MARK: - Dimension

	/// The file values dimension depth;
	public let depth : Depth

	public let dimension : [Int]

	public enum Depth: Int {
		/// Vector values.
		case vector = 1
		/// Matrice values.
		case matrice = 2
		/// Images values.
		case images = 3
		/// Unkwown values.
		/// - important: The behavior of the class can't be unpredictable.
		case unknown = -1
	}


	// MARK: - Values

	/// Raw data of the file.
	public let data : Data


	subscript(index: Int) -> Data.SubSequence {
		let realIndex = (data.startIndex + index) * valueSize

		return data[realIndex...(realIndex + valueSize - 1)]
	}


	// MARK: - Error

	public enum FileError: Error {
		case fileEmpty
		public enum Data: Error {
			case notEnough
			case corrupted
			case tooMuch
		}
	}
}
