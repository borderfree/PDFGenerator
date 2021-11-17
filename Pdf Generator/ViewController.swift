//
//  ViewController.swift
//  Pdf Generator
//
//  Created by Fetih Tunay Yetişir on 12.06.2021.
//

import UIKit
import CoreData
import AVFoundation
import Photos
import PDFGenerator

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let pickerController = UIImagePickerController()
    
    @IBOutlet var btn1:UIButton!
    @IBOutlet var btn2:UIButton!
    @IBOutlet var btn3:UIButton!

    var pdfTitle = String()
    
    var ispassword = Bool()
    
    let del = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn1.layer.borderWidth = 1
        btn2.layer.borderWidth = 1
        btn3.layer.borderWidth = 1
        btn2.layer.cornerRadius = 10
        btn1.layer.cornerRadius = 10
        btn3.layer.cornerRadius = 10
        btn1.layer.borderColor = Main_Color.cgColor
        btn2.layer.borderColor = Main_Color.cgColor
        btn3.layer.borderColor = Main_Color.cgColor

        setnavFont()

    }
    
    // MARK:- IBAction
    @IBAction func btnAction(sender:UIButton)
    {
        if sender.tag == 100
        {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    
                    print("granted")
                    
                    self.pickerController.delegate = self
                    self.pickerController.allowsEditing = false
                    self.pickerController.sourceType = .camera
                    self.present(self.pickerController, animated: true, completion: nil)
                    
                    
                } else {
                    
                    let alert = UIAlertController(title: "Camera", message: "Camera access is absolutely necessary to use this app", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }))
                    self.present(alert, animated: true)
                    
                }
            })
            
        }
        else if sender.tag == 101
        {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{

                    var context:NSManagedObjectContext
                    DispatchQueue.main.async {
                        self.pickerController.delegate = self
                        self.pickerController.allowsEditing = false
                        self.pickerController.mediaTypes = ["public.image"]
                        self.pickerController.sourceType = .photoLibrary
                        self.present(self.pickerController, animated: true, completion: nil)
                    }
                    

                    
                    
                } else
                {
                    
                    let alert = UIAlertController(title: "Photo", message: "Photo access is absolutely necessary to use this app", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }))
                    self.present(alert, animated: true)
                }
            })
        }
        else if sender.tag == 102
        {
              UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
    }
    
    fileprivate func getDestinationPath(_ number: Int) -> URL {
        
        
        let date = Int(NSDate().timeIntervalSince1970)

        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let pdfNameFromUrl = "\(date).pdf"
        self.pdfTitle = pdfNameFromUrl
        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
      
        return actualPath
    }
    
    // MARK:- ImagePicker Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image1 = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        let dst = getDestinationPath(1)
        
        
        do {
            var images = [UIImage]()
            images.append(image1)
            
          let data = try PDFGenerator.generated(by: images)
            try data.write(to:dst)
            
            dismiss(animated: true) {
                
                
                self.openpdf(str: dst)

            }
        } catch let e {
            print(e)
        }
        
        
        
         /*   let document = PDFDocument(format: .a4)
            document.layout.space.header = 0
            document.layout.space.footer = 0
            document.layout.margin.top = 0
            document.layout.margin.bottom = 0
            document.layout.margin.left = 0
            document.layout.margin.right = 0
        
        
            let img = PDFImage(image:image1)
            
            document.addImage(image:img)
            
            do {
                // Generate PDF file and save it in a temporary file. This returns the file URL to the temporary file
                
                let url = try PDFGenerator.generateURL(document: document, filename: "test.pdf", progress: { (time) in
                
                    
                }, debug: true)
                
               
                picker.dismiss(animated: true) {
                    

                self.openpdf(str: url)
                    
                }
                
                // Load PDF into a webview from the temporary file
             //   (self.view as? UIWebView)?.loadRequest(URLRequest(url: url))
            } catch {
                print("Error while generating PDF: " + error.localizedDescription)
            }*/

}
    func openpdf(str:URL)
    {
        
        //let url = URL(fileURLWithPath: str)


        let pdfview = self.storyboard?.instantiateViewController(withIdentifier: "pdfVC") as! pdfVC
        pdfview.pdfurl = str
        pdfview.isfromHome = true
        pdfview.Title = pdfTitle
        self.navigationController?.pushViewController(pdfview, animated: true)
    }
    
   

}

