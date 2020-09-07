//
//  ImageAnnotation.swift
//  APPDFHandDrawSignature
//
//  Created by Chindanai Peerapattanapaiboon on 7/9/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import UIKit
import PDFKit

class ImageAnnotation: PDFAnnotation {

    private var image: UIImage!
    
    init(with image: UIImage!, forBounds bounds: CGRect, withProperties properties: [AnyHashable : Any]?) {
        super.init(bounds: bounds, forType: PDFAnnotationSubtype.stamp, withProperties: properties)
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        guard let cgImage = self.image.cgImage else { return }
        context.draw(cgImage, in: self.bounds)
    }
}
