//
//  DrawSignatureViewController.swift
//  APPDFHandDrawSignature
//
//  Created by Chindanai Peerapattanapaiboon on 7/9/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import UIKit
import Sketch

protocol DrawSignatureViewControllerDelegate: class {
    func drawSignatureViewController(didFinishedWith image: UIImage, sender: DrawSignatureViewController)
}

class DrawSignatureViewController: UIViewController {

    @IBOutlet weak var sketchView: SketchView!
    weak var delegate: DrawSignatureViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sketchView.lineWidth = 4
    }
    
    @IBAction func done(_ sender: Any) {
        let image = sketchView.asImage()
        delegate?.drawSignatureViewController(didFinishedWith: image, sender: self)
    }
    @IBAction func clear(_ sender: Any) {
        sketchView.clear()
    }
}
