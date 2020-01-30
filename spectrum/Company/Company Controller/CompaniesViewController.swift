//
//  CompaniesViewController.swift
//  spectrum
//
//  Created by Shikha Sharma on 1/29/20.
//  Copyright © 2020 Shikha Sharma. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftSpinner
import SDWebImage

class CompaniesViewController: UIViewController {
    
    var dataList : NSArray = []
    var dataList1: NSArray = []
    var companyModel: [Company]!
    var companyModel1: [Company]!
    var followFavoriteStatus = [[String : Any]]()
    
    var companyName : String = ""
    
    @IBOutlet weak var companyTable: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyTable.estimatedRowHeight =  100.0
        companyTable.rowHeight = UITableView.automaticDimension
        companyTable.tableFooterView = UIView()
        
        DispatchQueue.main.async {
            if UIApplication.shared.keyWindow != nil {
                
                self.fetchData()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchData()
    {
        if isConnectedToNetwork() {
            SwiftSpinner.show("Loading")
            let parmas = [:] as [String: AnyObject]
            self.companyModel = []
            APIServices.sharedInstance.getData(params: parmas) { (response, status) in
                for comp in response!{
                    let c = comp as! [String: Any]
                    let compModel = Company(JSON: c )
                    
                    self.companyModel.append(compModel!)
                }
                
                if (self.companyModel.count != 0){
                    
                    self.companyModel1 = self.companyModel
                    self.companyTable.reloadData()
                }  else {
                    self.view.makeToast("No Data Found!")
                }
            }
        } else {
            self.view.makeToast("Not Connected To Network! Sorry!")
        }
    }
    
    
    @IBAction func ascendingBtnAction(_ sender: AnyObject)
    {
        self.companyModel = self.companyModel.sorted { ($0.company!).localizedCaseInsensitiveCompare($1.company!) == ComparisonResult.orderedAscending }
        self.companyTable.reloadData()
    }
    
    
    @IBAction func descendingBtnAction(_ sender: AnyObject)
    {
        self.companyModel = self.companyModel.sorted { ($0.company!).localizedCaseInsensitiveCompare($1.company!) == ComparisonResult.orderedDescending }
        self.companyTable.reloadData()
        
    }
    
    @IBAction func resetBtnAction(_ sender: AnyObject)
    {
        self.companyModel = self.companyModel1
        self.companyTable.reloadData()
        self.SearchBar.text = ""
    }
    
}

extension CompaniesViewController : UISearchBarDelegate
{
    
    // MARK:- Search bar Delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == ""
        {
            self.companyModel = self.companyModel1
            self.companyTable.reloadData()
        }
        else
        {
            self.companyModel = self.companyModel.filter{ ($0.company!.lowercased().contains(searchBar.text!.lowercased())) }
            self.companyTable.reloadData()
        }
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.SearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.showsCancelButton = false
        SearchBar.text = ""
        SearchBar.resignFirstResponder()
        self.companyModel = self.companyModel1
        self.companyTable.reloadData()
    }
}

extension CompaniesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = companyTable.dequeueReusableCell(withIdentifier: "companyCell") as! companyTableViewCell
        
        if let company = self.companyModel?[indexPath.item]{
            
            cell.companyNameLbl.text = company.company ?? ""
            cell.companyDescLbl.text = company.about ?? ""
            
            let follow = company.follow ?? ""
            if follow == "1"
            {
                cell.followBtn.isSelected = false
            }
            else
            {
                cell.followBtn.isSelected = true
            }
            
            let favorite = company.favorite ?? ""
            if favorite == "1"
            {
                cell.favoriteBtn.isSelected = false
            }
            else
            {
                cell.favoriteBtn.isSelected = true
            }
            
            let imageUrlBe = company.logo ?? ""
            cell.logoImageView.sd_setImage(with: URL(string:  imageUrlBe), placeholderImage: UIImage(named: "logo"))
            
            cell.companyWebsiteBtn.tag = indexPath.row
            cell.companyWebsiteBtn.addTarget(self, action: #selector(companyWebsiteBtnAction(sender:)), for: .touchUpInside)
            cell.companyWebsiteBtn.setTitle( company.website ?? "", for: .normal)
            
            cell.followBtn.tag = indexPath.row
            cell.followBtn.addTarget(self, action: #selector(followBtnAction(sender:)), for: .touchUpInside)
            
            cell.favoriteBtn.tag = indexPath.row
            cell.favoriteBtn.addTarget(self, action: #selector(favoriteBtnAction(sender:)), for: .touchUpInside)
            
        }
        
        return cell
        
    }
    
    @objc func followBtnAction(sender : UIButton){
        
        if let company = self.companyModel?[sender.tag]{
            
            if sender.isSelected == true
            {
                self.companyModel?[sender.tag].follow = "1"
                self.view.makeToast("You unfollowed \(company.company ?? "")")
                sender.isSelected = false
            }
            else
            {
                
                self.companyModel?[sender.tag].follow = "0"
                self.view.makeToast("You followed \(company.company ?? "")")
                sender.isSelected = true
            }
            
        }
        
    }
    
    @objc func favoriteBtnAction(sender : UIButton){
        
        if let company = self.companyModel?[sender.tag]{
            
            if sender.isSelected == true
            {
                self.companyModel?[sender.tag].favorite = "1"
                self.view.makeToast("You unfavorited \(company.company ?? "")")
                sender.isSelected = false
            }
            else
            {
                self.companyModel?[sender.tag].favorite = "0"
                self.view.makeToast("You favorited \(company.company ?? "")")
                sender.isSelected = true
            }
            
        }
    }
    
    @objc func companyWebsiteBtnAction(sender : AnyObject){
        
        if let company = self.companyModel?[sender.tag]{
            
            let urlBe = company.website ?? ""
            
            guard let url = URL(string: urlBe) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let member = self.companyModel?[indexPath.row]
        companyName = self.companyModel?[indexPath.row].company ?? ""
        self.performSegue(withIdentifier: "memberDetail", sender: member?.members)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "memberDetail" {
            let member = sender as! [Members]
            let vc =  segue.destination as! MembersViewController
            vc.companyName = companyName
            vc.membersData = member
            vc.membersData1 = member
        }
    }
    
}


