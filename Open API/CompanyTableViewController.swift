//
//  TableViewController.swift
//  Open API
//
//  Created by Ruslan Yelguldinov on 11.08.2024.
//

enum CellType {
    case type1
    case type2
}

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SVProgressHUD

class CompanyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test data
        
//        var test1 = CompanyModel()
//        var test2 = CompanyModel()
//        
//        test1.name = "test1"
//        test1.city = "test1"
//        test1.street = "test1"
//        test1.typeOfActivity = "test1"
//        
//        test2.name = "test2"
//        test2.city = "test2"
//        test2.street = "test2"
//        test2.typeOfActivity = "test2"
//        
//        companyArray.append(test1)
//        companyArray.append(test2)
//        tableView.reloadData()
        
//        APIrequest()
        fetchAllCompanies()
    }
    
    var companyArray: [CompanyModel] = []
    var logosArray: [String] = [
    "https://media.cnn.com/api/v1/images/stellar/prod/180927122050-apple-logo-gfx.jpg?q=w_3000,h_2250,x_0,y_0,c_fill",
    "https://media.licdn.com/dms/image/D4E12AQGnn7kpXUmM7Q/article-cover_image-shrink_720_1280/0/1701659588476?e=2147483647&v=beta&t=sL1M_CFopwVvFeba_oVU7b2JfuGuc07OoWBE1TNifec",
    "https://www.designyourway.net/blog/wp-content/uploads/2023/08/Featured-1-12.jpg",
    "https://www.logodesignlove.com/wp-content/uploads/2013/11/exxon-signage-01.jpg",
    "https://www.finews.com/images/news/2020/07/jpmorgan.jpg",
    "https://eco-cdn.iqpc.com/eco/images/channel_content/images/chevron.webp",
    "https://www.shutterstock.com/shutterstock/photos/2323812187/display_1500/stock-photo-logo-pfizer-inc-is-an-american-multinational-pharmacological-and-biotechnology-corporation-2323812187.jpg",
    "https://www.investopedia.com/thmb/h8hMcqr82TCrrfX6dyY5ZazAatQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/BankofAmericaShortSale-56a2b3655f9b58b7d0cd877d.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrtKr7aRCrQtyX2F8twA4ifq1awqGV1abkC7tgzvPQaDy8WDJsjfwCr9LY7UOyy8uET9s&usqp=CAU"
    ]
    let cikCodesArray = [
            "0000320193", // Apple
            "0000789019", // Microsoft
            "0001652044", // Alphabet Inc.
            "0001226649", // ExxonMobil Corp
            "0000019617", // JPMorgan Chase & Co
            "0000093410", // Chevron Corp
            "0000078003", // Pfizer Inc
            "0001085917", // Bank of America Corp
            "0001326801"  // Meta Platforms, Inc.
        ]
    
    var cikToCompanyMap: [String: CompanyModel] = [:]
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return companyArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: CompanyTableViewCell
        let cellType: CellType
        
        if indexPath.row % 2 == 0 {
            cellType = .type1
            cell = tableView.dequeueReusableCell(withIdentifier: "TVCell1", for: indexPath) as! CompanyTableViewCell
            cell.setData(for: cellType, with: companyArray[indexPath.row])
        } else {
            cellType = .type2
            cell = tableView.dequeueReusableCell(withIdentifier: "TVCell2", for: indexPath) as! CompanyTableViewCell
            cell.setData(for: cellType, with: companyArray[indexPath.row])
        }
        
        let logoURL = logosArray[indexPath.row]
        cell.photoImageView.sd_setImage(with: URL(string: logoURL), placeholderImage: UIImage.appleLogo)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row % 2 == 0 {
                return 220
            } else {
                return 220
            }
    }
    
// MARK: Functoins
    
    func getLogoURL(forCompanyAt index: Int) -> URL? {
        let logoURLString = logosArray[index]
        return URL(string: logoURLString)
    }
    
// MARK: Fetching API data
    func fetchAllCompanies() {
            let dispatchGroup = DispatchGroup()
            
            for cikCode in cikCodesArray {
                dispatchGroup.enter()
                
                APIrequest(cikCode: cikCode) { company in
                    if let company = company {
                        self.cikToCompanyMap[cikCode] = company
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.companyArray = self.cikCodesArray.compactMap { self.cikToCompanyMap[$0] }
                self.tableView.reloadData()
                
                SVProgressHUD.dismiss()
            }
        }
        
    func APIrequest(cikCode: String, completion: @escaping (CompanyModel?) -> Void) {
        
        let companyURL = "https://data.sec.gov/submissions/CIK\(cikCode).json"
        
        SVProgressHUD.show(withStatus: "Loading...")
        
        AF.request(companyURL).responseData { response in
            
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    let company = CompanyModel(json: json)
                    completion(company)
                } catch {
                    print("Failed to parse JSON: \(error)")
                    completion(nil)
                }
            case .failure(let error):
                print("API request failed: \(error)")
                completion(nil)
            }
        }
    }

    
    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "ChartsVC") as! ChartsViewController
        
        let selectedCikCode = cikCodesArray[indexPath.row]
        detailViewController.cikCode = selectedCikCode
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }


}
