//
//  main.swift
//  projectAir
//
//  Created by Takano Taiga on 2022/01/03.
//

import Foundation
import Vision
import CoreML
import CoreImage

class MacInference{
    
    private let model = try? testml(configuration: MLModelConfiguration()).model //CoreML model
    
    var TopResultConfidence : Float = 0.0
    var TopResultId = ""
    
    var debug = false

    func startML(fileURL : String){
        let coreMLModel = try? VNCoreMLModel(for: self.model!)
        let request = VNCoreMLRequest(model: coreMLModel!){ request, error in
            if let results = request.results as? [VNClassificationObservation]{
                self.TopResultConfidence = results[0].confidence
                self.TopResultId = results[0].identifier
                
                if self.debug {
                    for result in results {
                        print(result.confidence * 100, result.identifier)
                    }
                }
            }
        }
        
        let ciimage = CIImage(contentsOf: URL(string: fileURL)!)
        let handler = VNImageRequestHandler(ciImage: ciimage!, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

let macML = MacInference()

macML.debug = true


let start = Date()
macML.startML(fileURL: "/Volumes/Ultra HDD/TAIGA_server/ProgramingServer/CoreML/project_air/projectAir/projectAir/test.jpg")

let el = Date().timeIntervalSince(start)
print(el)

