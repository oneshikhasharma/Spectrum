//
//  MembersViewController.swift
//  spectrum
//
//  Created by Shikha Sharma on 1/29/20.
//  Copyright © 2020 Shikha Sharma. All rights reserved.
//

import UIKit
import DropDown

class MembersViewController: UIViewController {
    
    var membersData : [Members]?
    var membersData1 : [Members]?
    
    @IBOutlet weak var memberTable: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var companyNameLbl: UILabel!
    var companyName : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberTable.estimatedRowHeight =  100.0
        memberTable.rowHeight = UITableView.automaticDimension
        memberTable.tableFooterView = UIView()
        
        companyNameLbl.text = "\(companyName)'s Members"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonACtion(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ascendingBtnAction(_ sender: UIButton)
    {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = ["Name", "Age"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
           
            if item == "Name" {
                
                self.membersData = self.membersData!.sorted { ($0.name!.first!).localizedCaseInsensitiveCompare($1.name!.first!) == ComparisonResult.orderedAscending }
                self.memberTable.reloadData()
                
            } else if item == "Age" {
                
                self.membersData = self.membersData!.sorted { $0.age! < $1.age!  }
                self.memberTable.reloadData()
                
            }
         
            dropDown.hide()
        }
        dropDown.width = sender.frame.width
        dropDown.show()
      
    }
    
    
    @IBAction func descendingBtnAction(_ sender: UIButton)
    {
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = ["Name", "Age"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          
            if item == "Name" {
               
            self.membersData = self.membersData!.sorted { ($0.name!.first!).localizedCaseInsensitiveCompare($1.name!.first!) == ComparisonResult.orderedDescending }
                self.memberTable.reloadData()
                
            } else if item == "Age" {
                
                self.membersData = self.membersData!.sorted { $0.age! > $1.age!  }
                self.memberTable.reloadData()
                
            }
          
            
            dropDown.hide()
        }
        dropDown.width = sender.frame.width
        dropDown.show()
     
    
    }
    
    @IBAction func resetBtnAction(_ sender: AnyObject)
    {
        self.membersData = self.membersData1
        self.memberTable.reloadData()
        self.SearchBar.text = ""
    }
}

extension MembersViewController : UISearchBarDelegate
{
    
    // MARK:- Search bar Delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == ""
        {
            self.membersData = self.membersData1
            self.memberTable.reloadData()
        }
        else
        {
            self.membersData = self.membersData1!.filter{ ($0.name!.first!.lowercased().contains(searchBar.text!.lowercased())) }
            self.memberTable.reloadData()
        }
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.SearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.showsCancelButton = false
        SearchBar.text = ""
        SearchBar.resignFirstResponder()
        self.membersData = self.membersData1
        self.memberTable.reloadData()
    }
}

extension MembersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memberTable.dequeueReusableCell(withIdentifier: "memberCell") as! memberTableViewCell
        
        if let member = self.membersData?[indexPath.item]{
            
            
            let nameBe = "\(member.name?.first ?? "") \(member.name?.last  ?? ""), \(member.age ?? 0)"
            let range = NSMakeRange(0, nameBe.count - 2)
            
            cell.memberDescLbl.attributedText = Utility.attributedString(from: nameBe, boldRange: range)
            
            
            cell.memberEmailLbl.text = member.email ?? ""
            cell.memberPhoneLbl.text = member.phone ?? ""
            
            let favorite = member.favorite ?? ""
            if favorite == "1"
            {
                cell.favoriteBtn.isSelected = false
            }
            else
            {
                cell.favoriteBtn.isSelected = true
            }
            
            cell.favoriteBtn.tag = indexPath.row
            cell.favoriteBtn.addTarget(self, action: #selector(favoriteBtnAction(sender:)), for: .touchUpInside)
            
            
        }
        
        return cell
        
    }
    
    @objc func favoriteBtnAction(sender : UIButton){
        
        if let member = self.membersData?[sender.tag]{
            let nameBe = member.name as Name?
            
            if sender.isSelected == true
            {
                self.membersData?[sender.tag].favorite = "1"
                self.view.makeToast("You unfavorited \(nameBe?.first ?? "") \(nameBe?.last  ?? "")")
                sender.isSelected = false
            }
            else
            {
                self.membersData?[sender.tag].favorite = "0"
                self.view.makeToast("You favorited \(nameBe?.first ?? "") \(nameBe?.last  ?? "")")
                sender.isSelected = true
            }
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    
}

