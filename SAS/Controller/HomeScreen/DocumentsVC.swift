//
//  DocumentsVC.swift
//  SAS
//
//  Created by macmini on 05/07/18.
//  Copyright © 2018 self. All rights reserved.
//

import UIKit

class DocumentsVC: UIViewController {
    //MARK:- IBOUTLET VARIABLE
    
    //MARK:- VARIABLE
    
    //MARK:- VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    //MARK:- BUTTON ACTIONMETHODS
    
    
    //MARK:- CALLER METHODS
    
    
    //MARK:- CUSTOM METHODS
    
    
    //MARK:- VIEW CYCYLE END
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//MARK: - EXTENTION OF TABLEVIEW DELEGATE AND DATA SOURCE
extension DocumentsVC : UITableViewDelegate, UITableViewDataSource {
    /*
     @IBOutlet weak var tblJobs : UITableView!
     private var arrJobs = [Jobs]()
     
     var page = 1
     var intTotalPage = 1
     self.navigationItem.title = "Jobs"
     tblJobs.register(UINib(nibName: "JobsCell", bundle: nil), forCellReuseIdentifier: "JobsCell")
     
     tblJobs.estimatedRowHeight = 70
     tblJobs.rowHeight = UITableViewAutomaticDimension
     
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /*if indexPath.section == 0 {
         if self.arrJobs.count >= 10  && self.page <= self.intTotalPage {
         if indexPath.row == arrJobs.count - 2 {
         //self.GetRecordsWithType(query: "", strType: strType)
         }
         }
         }*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  10//arrJobs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "JobsCell", for: indexPath) as! JobsCell
        //cell.loadDataOfCell(data: arrJobs[indexPath.row])
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let storyboard = UIStoryboard(name: MyStoryboard.job, bundle: nil)
         let aJobDetails = storyboard.instantiateViewController(withIdentifier: "JobDetailsVC") as! JobDetailsVC
         aJobDetails.currentJobs = arrJobs[indexPath.row]
         navigationController?.pushViewController(aJobDetails, animated: true)*/
    }
}
//MARK:- EXTENSION FOR COLLECTIONVIEW
extension DocumentsVC: UICollectionViewDataSource {
    
    
     
    //@IBOutlet private weak var collectionLocation: UICollectionView!
    
    /*  // LAYOUT METHODS
        if let flowLayout = collectionLocation.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.estimatedItemSize = CGSize(width: 1, height: collectionLocation.frame.height)
        }
     //https://stackoverflow.com/questions/13970950/uicollectionview-spacing-margins
     */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 //arrSelectedLocation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnboardingSkillCollectionViewCell
        cell.nameLabel.text = "Index"//arrSelectedLocation[indexPath.row].name
        cell.indexPath = indexPath*/
        return UICollectionViewCell()
    }
}
