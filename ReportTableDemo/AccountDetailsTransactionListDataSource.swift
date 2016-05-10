//
//  AccountDetailsTransactionListDataSource.swift
//  ReportTableDemo
//
//  Created by Lyle Resnick on 2016-05-09.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

private enum Cells: String {
    case Header
    case Subheader
    case Detail
    case Message
    case Total
    case Subfooter
}

private enum Row {
    case  HeaderRow( title: String, subtitle: String )
    case  SubheaderRow( title: String, odd: Bool )
    case  DetailRow( description: String, amount: String, odd: Bool )
    case  MessageRow( message: String )
    case  TotalRow( total: String, odd: Bool )
    case  SubfooterRow( odd : Bool )
    
    var cellId: Cells {
        get {
            switch self {
            case HeaderRow:
                return .Header
            case SubheaderRow:
                return .Subheader
            case  DetailRow:
                return .Detail
            case MessageRow:
                return .Message
            case TotalRow:
                return .Total
            case SubfooterRow:
                return .Subfooter
            }
        }
    }
}




class AccountDetailsTransactionListDataSource: NSObject, UITableViewDataSource {
    
    typealias DataSource = AccountDetailsTransactionListDataSource
    
    let inboundDateFormat = NSDateFormatter()
    let outboundDateFormat = NSDateFormatter()
    
    
    static let oddBandBackground = 0xF7F8FC
    static let evenBandBackground = 0xFAFBFD
    
    override init() {
        inboundDateFormat.dateFormat = "yyyy'-'MM'-'dd"
        outboundDateFormat.dateFormat = "MMM' 'dd', 'yyyy"
    }

    private var dataset = [Row]()
    private var odd = false
    
    func appendHeaderRow(name: String , subtitle: String ) {
    
        dataset.append(.HeaderRow(title: name, subtitle: subtitle));
    }
    
    func appendSubheaderRow( inDateString: String ) {
    
        odd = !odd;
        
        guard
            let date = inboundDateFormat.dateFromString( inDateString )
        else {
            NSLog("Format of Transaction Date  is incorrect")
            abort()
        }
        let outDate = outboundDateFormat.stringFromDate(date)
        dataset.append(.SubheaderRow(title: outDate, odd: odd))
    }
    
    func appendDetailRow(description: String, amount: Double, debit: String) {
    
        let amountString = (debit == "D" ? "" : "-") + String( format: "%.2d", amount )
        dataset.append( .DetailRow(description: description, amount: amountString, odd: odd));
    }
    
    func appendSubfooterRow() {
    
        dataset.append(.SubfooterRow( odd: odd ));
    }
    
    func appendTotalRow(total: Double) {
    
        odd = !odd;
        let totalString = String( format: "%.2f", total)
        dataset.append(.TotalRow(total: totalString, odd: odd));
    }
    
    func appendMessageRow(message: String) {
    
        dataset.append(.MessageRow(message: message));
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = dataset[ indexPath.row ]
        let cell = tableView.dequeueReusableCellWithIdentifier(data.cellId.rawValue, forIndexPath: indexPath) as! BindingCell
        cell.bind(data)
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataset.count
    }
    
    
    // UITableViewCell
    
    
    
    // Row
    
    private class BindingCell: UITableViewCell {
        private func bind(row: Row) {
            assert(false, "must override bind")
        }
        
        func processBackgroundColour(odd: Bool ) {
            
            if odd {
                //contentView ?
                backgroundColor = UIColor( rgb: oddBandBackground );
            }
            else {
                backgroundColor = UIColor( rgb: evenBandBackground );
            }
        }
        

    }
    
     private class HeaderCell: BindingCell {
     
        @IBOutlet var titleLabel: UILabel!
        @IBOutlet var subtitleLabel: UILabel!
    
        private override func bind(row: Row) {
    
            switch row {
            case let .HeaderRow( title, subtitle):
                titleLabel.text = title
                subtitleLabel.text = subtitle
            default:
                break
            }
        }
    }
    
    private class SubHeaderCell: BindingCell {
    
        @IBOutlet var titleLabel: UILabel!
        
        private override func bind(row: Row) {
        
            switch row {
            case let .SubheaderRow( title, odd ):
                titleLabel.text = title
                processBackgroundColour(odd);
            default:
                break
            }
        }
    }
    
    private class DetailCell: BindingCell {
    
        @IBOutlet var descriptionLabel: UILabel!
        @IBOutlet var amountLabel: UILabel!
    
        private override func bind(row: Row) {
    
            switch row {
            case let .DetailRow( description, amount, odd ):
                descriptionLabel.text = description
                amountLabel.text = amount
                processBackgroundColour(odd)
            default:
                break
            }
        }
    }
        
    
    private class SubfooterCell: BindingCell {

        private override func bind(row: Row) {
    
            switch row {
            case let .SubfooterRow( odd ):
                processBackgroundColour(odd);
            default:
                break
            }
        }
    }
    
    private class TotalCell: BindingCell {
    
        @IBOutlet var totalLabel: UILabel!
        
        private override func bind(row: Row) {
        
            switch row {
            case let .TotalRow(total, odd):
                totalLabel.text = total
                processBackgroundColour(odd);
            default:
                break
            }
        
        }
    }
    
    private class MessageCell: BindingCell {
    
        @IBOutlet var messageLabel: UILabel!
    
        private override func bind(row: Row) {
    
            switch row {
            case let .MessageRow( message ):
                messageLabel.text = message
                processBackgroundColour(true);
            default:
                break
            }
        }
    }
   
}
