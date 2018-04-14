//
//  MenuViewController.swift
//  Ozkor
//
//  Created by Ahmed Ramy on 4/8/18.
//  Copyright © 2018 Ahmed Ramy. All rights reserved.
//

import UIKit
import JTMaterialTransition

struct MenuItemModel
{
    var imageViewString: String
    var cellBackgroundColor: UIColor
}

class MenuViewController: UIViewController
{
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    
    var menuModel: [MenuItemModel] = []
    let menuItem1 : MenuItemModel = MenuItemModel(imageViewString: "prayer-beads", cellBackgroundColor: UIColor.rgb(r: 0, g: 252, b: 108))
    let menuItem2 : MenuItemModel = MenuItemModel(imageViewString: "islamic-friday-prayer", cellBackgroundColor: UIColor.rgb(r: 40, g: 36, b: 58))
    var transition: JTMaterialTransition?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeUI()
        initMenuTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TasbeehAfterSalaaViewController
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = self.transition
        
    }
    
    fileprivate func initMenuTableView()
    {
        menuModel.append(menuItem1)
        menuModel.append(menuItem2)
        menuTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        //TODO:- Reload with animations here
    }
    
    fileprivate func customizeUI()
    {
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
    }
    
    @IBAction func dismissMenu(_ sender: Any)
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension MenuViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        self.transition = JTMaterialTransition(animatedView: cell.cellView)
        cell.setModel(model: menuModel[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return menuTableView.frame.height / CGFloat(menuModel.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = indexPath.row
        switch row {
        case 0:
            //GoTo Endless Tasbeeh
            break
        default:
            //GoTo Tasbeeh After Salaa
            
            
            self.performSegue(withIdentifier: "goToTasbeehAfterSalaa", sender: self)
            break
        }
    }
    
}
