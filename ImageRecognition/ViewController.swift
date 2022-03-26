/*
Filename:   ViewController.swift
Author:     Feiliang Zhou
StudentId:  301216989
Date:       2022-03-25.
App Description: machine learning app
Version:    1.001
*/

import UIKit
import CoreML
import Vision


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let imagePath = Bundle.main.path(forResource: "dog", ofType: "jpg")
        
        let imageURL = NSURL.fileURL(withPath: imagePath!)
        
        let modelFile = MobileNetV2()
        
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        let handler = VNImageRequestHandler(url: imageURL)
        let request = VNCoreMLRequest(model: model, completionHandler: findResults)
            try! handler.perform([request])
        
    }
    
    func findResults(request: VNRequest, error: Error?) {
       guard let results = request.results as?
       [VNClassificationObservation] else {
           
           showSimpleAlert(msg: "Unable to get results")
           
           return
       }
       var bestGuess = ""
       var bestConfidence: VNConfidence = 0
       for classification in results {
          if (classification.confidence > bestConfidence) {
             bestConfidence = classification.confidence
             bestGuess = classification.identifier
          }
       }
       labelDescription.text = "Image is: \(bestGuess) with confidence \(bestConfidence) out of 1"
    }
    
    func showSimpleAlert(msg: String) {
        let alert = UIAlertController(title: nil, message: msg,         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "OK",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            //ok action
            }))
            self.present(alert, animated: true, completion: nil)
        }


}

