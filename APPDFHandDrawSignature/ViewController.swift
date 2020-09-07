//
//  ViewController.swift
//  APPDFHandDrawSignature
//
//  Created by Chindanai Peerapattanapaiboon on 7/9/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pdfContainerView: PDFView!
    
    var currentlySelectedAnnotation: PDFAnnotation?
    var signatureImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PDF Viewer"
        setupPdfView()
    }
    
    func setupPdfView() {
        if let documentURL = URL(string: "https://file-examples-com.github.io/uploads/2017/10/file-example_PDF_1MB.pdf"),
            let data = try? Data(contentsOf: documentURL),
            let document = PDFDocument(data: data) {
            
            // Set document to the view, center it, and set background color
            pdfContainerView.document = document
            pdfContainerView.autoScales = true
            pdfContainerView.backgroundColor = UIColor.lightGray
            
            let panAnnotationGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanAnnotation(sender:)))
            pdfContainerView.addGestureRecognizer(panAnnotationGesture)
            
        }
    }
    
    private func redrawImageAnnotation() {
        guard let signatureImage = signatureImage, let page = pdfContainerView.currentPage else { return }
        let pageBounds = page.bounds(for: .cropBox)
        let imageBounds = CGRect(x: pageBounds.midX, y: pageBounds.midY, width: 200, height: 100)
        let imageStamp = ImageAnnotation(with: signatureImage, forBounds: imageBounds, withProperties: nil)
        page.addAnnotation(imageStamp)
    }
    
    @objc func didPanAnnotation(sender: UIPanGestureRecognizer) {
        let touchLocation = sender.location(in: pdfContainerView)
        
        guard let page = pdfContainerView.page(for: touchLocation, nearest: true)
            else {
                return
        }
        let locationOnPage = pdfContainerView.convert(touchLocation, to: page)
        
        switch sender.state {
        case .began:
            
            guard let annotation = page.annotation(at: locationOnPage) else {
                return
            }
            
            if annotation.isKind(of: ImageAnnotation.self) {
                currentlySelectedAnnotation = annotation
            }
            
        case .changed:
            
            guard let annotation = currentlySelectedAnnotation else {
                return
            }
            let initialBounds = annotation.bounds
            // Set the center of the annotation to the spot of our finger
            annotation.bounds = CGRect(x: locationOnPage.x - (initialBounds.width / 2), y: locationOnPage.y - (initialBounds.height / 2), width: initialBounds.width, height: initialBounds.height)
            
            
            print("move to \(locationOnPage)")
        case .ended, .cancelled, .failed:
            currentlySelectedAnnotation = nil
        default:
            break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DrawSignatureViewController" {
            if let destination = segue.destination as? DrawSignatureViewController {
                destination.delegate = self
            }
        }
    }
}

extension ViewController: DrawSignatureViewControllerDelegate {
    func drawSignatureViewController(didFinishedWith image: UIImage, sender: DrawSignatureViewController) {
        self.signatureImage = image
        redrawImageAnnotation()
        sender.navigationController?.popViewController(animated: true)
    }
}
