//
//  SQLiteTypesConversionTests.swift
//  AcronisSampleTests
//
//  Created by Maria Kataeva on 11/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

import XCTest
import UIKit
@testable import AcronisSample

class SQLiteTypesConversionTests: XCTestCase {

    func testUIImageSample() {
        let orangeImage = UIColor.orange.image()
        let blueImage = UIColor.blue.image()
        let orangeImage2 = UIColor.orange.image()

        XCTAssertNotNil(orangeImage.pngData())
        XCTAssertNotNil(blueImage.pngData())
        XCTAssertNotNil(orangeImage2.pngData())

        XCTAssertEqual(orangeImage.pngData(), orangeImage.pngData())
        XCTAssertEqual(orangeImage.pngData(), orangeImage2.pngData())
        XCTAssertNotEqual(orangeImage.pngData(), blueImage.pngData())

        XCTAssertEqual(UIImage(data: orangeImage.pngData()!)?.pngData(), orangeImage.pngData())
    }

    func testUIImageToBlobAndBack() {
        let image = UIColor.orange.image()
        let convertedImage = UIImage.fromDatatypeValue(image.datatypeValue)
        XCTAssertEqual(convertedImage.pngData(), image.pngData())
    }

}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
