//
//  TransactionViewModel.swift
//  ReportTableDemo
//
//  Created by Lyle Resnick on 2016-05-19.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit


class TransactionViewModel {
    
    enum Group: String {
        case Authorized
        case Posted
    }
    
    static let groupList: [TransactionViewModel.Group] = [.Authorized, .Posted]
    
    private let inboundDateFormat = NSDateFormatter()
    private let outboundDateFormat = NSDateFormatter()
    
    
    var group: TransactionViewModel.Group { return transaction.group == "A" ? Group.Authorized : Group.Posted }
    
    var date: String {
        guard
            let dateAsDate = inboundDateFormat.dateFromString( transaction.date )
            else {
                NSLog("Format of Transaction Date is incorrect")
                abort()
        }
        return outboundDateFormat.stringFromDate(dateAsDate)
    }
    
    var description: String { return transaction.description }
    
    var amount: String {
        return (transaction.debit == "D" ? transaction.amount : "-" + transaction.amount )
    }
    
    var amountDouble: Double {
        let aDouble = Double( transaction.amount )!
        return (transaction.debit == "D" ? aDouble : -aDouble )
    }
    
    private let transaction: TransactionModel

    
    init?( transaction: TransactionModel? ) {
        guard let transaction = transaction else { return nil }
        self.transaction = transaction
        inboundDateFormat.dateFormat = "yyyy'-'MM'-'dd"
        outboundDateFormat.dateFormat = "MMM' 'dd', 'yyyy"
    }
    
}