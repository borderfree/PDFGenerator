//
//  pdfVC.swift
//  Pdf Generator
//
//  Created by Fetih Tunay Yetişir on 12.06.2021.
//


import UIKit
import WebKit
import CoreData
import MessageUI


class pdfVC: UIViewController,WKNavigationDelegate,WKUIDelegate,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var webParentView: UIView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    
    var isfromHome = Bool()

    lazy var webView : WKWebView = {
        
        let config = WKWebViewConfiguration()
        return WKWebView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height));
    }();

    var pdfdata = Data()

    var pdfurl: URL!
    var Title = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        setnavFont()
        
        webView.navigationDelegate = self
        webParentView.addSubview(webView)
        
        self.title = Title

        
        if isfromHome
        {
            
           savePdf1()
        }
        else
        {
            webView.load(pdfdata, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: NSURL() as URL)
        }
    }
    
     // MARK:-  IBAction
    @IBAction func btnshareAction()
    {
        let mailComposeViewController = configureMailComposer()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("Can't send email")
        }
        
    
    }
    @IBAction func btndoneAction()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btndelAction()
    {
        
        
        let alert = UIAlertController(title: "Are You Sure Want to Delete Pdf?", message:"", preferredStyle: .alert)
        
        let ac1 = UIAlertAction(title: "No", style: .destructive) { (action) in
            
            
        }
        let ac2 = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            
            
            let quoteID = self.Title
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pdfs")
            request.predicate = NSPredicate(format: "name = %@",quoteID)
            request.returnsObjectsAsFaults = false
            
            
            do {
                let result = try context.fetch(request)
                
                if result.count > 0
                {
                    let obj = result[0] as! NSManagedObject
                    
                    print(obj)
                    
                    context.delete(obj)
                    
                    
                    
                    do {
                        try context.save()
                        
                        let alert = UIAlertController(
                            title: "Alert",
                            message: "Pdf Deleted Sucessfully",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                            
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    } catch let error as NSError {
                        print(error)
                    }
                }
                
                
                
            } catch {
                
                print("Failed")
            }
            
        }
        
        
        alert.addAction(ac1)
        alert.addAction(ac2)
        
        
        self.present(alert, animated: true, completion: nil)
      
    }

    // MARK:-  WEB DELEGATE
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        indicator.startAnimating()
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        DispatchQueue.main.async
            {
                self.indicator.stopAnimating()
        }
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       indicator.stopAnimating()
        print("Error while loading")
    }
    
    func savePdf1() {
        
        DispatchQueue.main.async {
            
            let pdfData1 = try? Data.init(contentsOf: self.pdfurl)
            

            self.webView.load(pdfData1!, mimeType: "application/pdf", characterEncodingName: "UTF-8", baseURL: NSURL() as URL)
            
            self.pdfdata = pdfData1!


            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Pdfs", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            
        
            newUser.setValue(self.Title, forKey: "name")
            
            let date1 = Date()
            let format1 = DateFormatter()
            format1.dateFormat = "dd-MM-yyyy HH:mm"
            let formattedDate1 = format1.string(from: date1)
            newUser.setValue(formattedDate1, forKey: "date")
            newUser.setValue(pdfData1, forKey: "file")
            newUser.setValue("0", forKey: "pass")
            
            do {
                
                try context.save()
                
                print("file saved")

                
                
            } catch {
                
                print("Failed saving")
            }
           
        }
        
        
    }
    
    func configureMailComposer() -> MFMailComposeViewController{
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([""])
        mailComposeVC.setSubject(self.Title)
        mailComposeVC.addAttachmentData(pdfdata, mimeType: "application/pdf", fileName: self.Title)
                return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
