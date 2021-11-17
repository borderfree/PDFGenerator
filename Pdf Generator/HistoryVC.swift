//
//  HistoryVC.swift
//  Pdf Generator
//
//  Created by Fetih Tunay Yetişir on 12.06.2021.
//

import UIKit
import CoreData


let ScreenWidth1 = (UIScreen.main.bounds.size.width)
let ScreenHeight1 = (UIScreen.main.bounds.size.height)

class HistoryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    var arrMenu = NSMutableArray()
    
    @IBOutlet var collhistory:UICollectionView!
    @IBOutlet var lblMessage:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.hidesWhenStopped = true

        setnavFont()


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
            
            self.indicator.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                
                self.getdata()
                
                
            })
            
            
        })
    }
    
    func getdata()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pdfs")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        arrMenu.removeAllObjects()
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                arrMenu.add(data)
            }
            
            if  self.arrMenu.count > 0
            {
                self.lblMessage.alpha = 0
            }
            else
            {
                self.lblMessage.alpha = 1
            }
            
        } catch {
            
            print("Failed")
        }
        
        indicator.stopAnimating()
        collhistory.reloadData()

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as? tblCell {
            
            cell.mainview.layer.cornerRadius = 10
            cell.mainview.clipsToBounds = true
            cell.btn.tag = indexPath.row
            
            if arrMenu.count > 0
            {
                let data = arrMenu[indexPath.row] as! NSManagedObject
                
                let date = data.value(forKey: "date") as! String
                
                cell.lblname.text = (data.value(forKey: "name") as! String)
                cell.lbldate.text = "Date: " + date
                
                let ispass = data.value(forKey: "pass") as! String
    
                if ispass == "1"
                {
                    cell.imglock.setImage(UIImage(named: "lock"), for: .normal)
                }
                else
                {
                    cell.imglock.setImage(UIImage(named: "unlock"), for: .normal)
                }
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pdfview = self.storyboard?.instantiateViewController(withIdentifier: "pdfVC") as! pdfVC
        let data = arrMenu[indexPath.row] as! NSManagedObject
        let imgdata = data.value(forKey: "file") as! Data
        pdfview.pdfdata = imgdata
        pdfview.isfromHome = false
        pdfview.Title = data.value(forKey: "name") as! String
        self.navigationController?.pushViewController(pdfview, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width
        let widthPerItem = (availableWidth / 2) - 10
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    

    
   
    
    @IBAction func delete(sender: UIButton) {
        
        let alert = UIAlertController(title: "Are You Sure Want to Delete Pdf?", message:"", preferredStyle: .alert)
        
        let ac1 = UIAlertAction(title: "No", style: .destructive) { (action) in
            
            
        }
        let ac2 = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            let dic = self.arrMenu[sender.tag] as! NSManagedObject
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            context.delete(dic)
            
            do {
                try context.save()
                
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
            
            self.getdata()
            
        }
        alert.addAction(ac1)
        alert.addAction(ac2)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    


}
