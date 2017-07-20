//
//  MainScreenViewController.swift
//  Ear Training
//
//  Created by Vardaan Aashish on 5/2/17.
//  Copyright © 2017 Booz Productions. All rights reserved.
//

import UIKit

class MainScreenVC: UIViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func practiceButton(_ sender: UIButton)
    {
        mode = "practice"
    }
    
    
    @IBAction func survivalButton(_ sender: UIButton)
    {
        mode = "survival"
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
