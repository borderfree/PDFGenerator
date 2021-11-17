//
//  SettingVC.swift
//  Pdf Generator
//
//  Created by Fetih Tunay Yetişir on 12.06.2021.
//


import UIKit
import MessageUI

class SettingVC: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {
    
    @IBOutlet var tblsetting:UITableView!
    
    var arrMenu = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        setnavFont()

        arrMenu = ["App Version - 1.0","More apps","Share App","Support"]
        
        tblsetting.tableFooterView = UIView()
        tblsetting.reloadData()
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMenu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?
        
        let lblText = cell?.contentView.viewWithTag(100) as! UILabel
        let mainview = cell?.contentView.viewWithTag(111) as UIView?
        
        mainview!.layer.cornerRadius = 10

        lblText.text = arrMenu[indexPath.row] as? String
        
        
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        if arrMenu.object(at: indexPath.row) as? String == "Support"
        {
            
            let mailComposeViewController = configureMailComposer()
            if MFMailComposeViewController.canSendMail(){
                self.present(mailComposeViewController, animated: true, completion: nil)
            }else{
                print("Can't send email")
            }
        }
        if arrMenu.object(at: indexPath.row) as? String == "More apps"
        {
            let urlStr = "https://apps.apple.com/us/developer/binitkumar-hirapara/id1467006300"
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(URL(string: urlStr)!)
            }
        }
        if arrMenu.object(at: indexPath.row) as? String == "Share App"
        {
            let imageToShare = ["Hello! Make pdf using this application download it from here:- https://itunes.apple.com/us/app/id1470636582&mt=8"]
            let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    // MARK: - MAIL DELEGATE
    
    func configureMailComposer() -> MFMailComposeViewController{
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["binithirpara1@gmail.com"])
        mailComposeVC.setSubject("Photo to Pdf Maker")
       

        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
