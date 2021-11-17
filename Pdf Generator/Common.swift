//
//  Common.swift
//  Pdf Generator
//
//  Created by Fetih Tunay Yetişir on 12.06.2021.
//


import UIKit

let Main_Color = UIColor(red: 170.0/255.0, green: 121.0/255.0, blue: 66.0/255.0, alpha: 1.0)

extension UIViewController {
    
    func setnavFont()
    {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = Main_Color
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font:UIFont(name: "Rubik-Medium", size: 19.0) as Any]
    }
    
}
