//
//  ViewController.swift
//  ReportTableDemo
//
//  Created by Lyle Resnick on "2016-05-06.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit




class AccountDetailsTransactionListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let dataSourceDelegate = AccountDetailsTransactionListDataSourceDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        processTransactions( authorizedData, title: "Authorized Transactions" )
        processTransactions( postedData, title: "Posted Transactions" )

        tableView.dataSource = dataSourceDelegate
        tableView.delegate = dataSourceDelegate
        
    }
    
    private func processTransactions( data: [Transaction], title: String ) {
        
        dataSourceDelegate.appendHeader(title, subtitle: "")
        
        if (data.count == 0) {
            dataSourceDelegate.appendMessage("\(title) are not currently Available. You might want to call us and tell us what you think ")
            return
        }
        
        var i = 0
        var currentTransaction: Transaction? = (i < data.count) ? data[i++] : nil
        
        var total = 0.0
        while currentTransaction != nil {
        
            let curDate = currentTransaction!.date
            dataSourceDelegate.appendSubheader(curDate)
            
            while (currentTransaction != nil) && (currentTransaction!.date == curDate) {
            
                if currentTransaction!.debit == "D" {
                    total += currentTransaction!.amount
                }
                else {
                    total -= currentTransaction!.amount
                }
                dataSourceDelegate.appendDetail(currentTransaction!.description, amount: currentTransaction!.amount, debit: currentTransaction!.debit)
                
                currentTransaction = (i < data.count) ? data[i++] : nil
            }
            dataSourceDelegate.appendSubfooter()
        
        }
        dataSourceDelegate.appendTotal(total)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

