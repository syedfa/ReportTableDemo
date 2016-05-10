//
//  AccountDetailsTransactionListDataSource.swift
//  ReportTableDemo
//
//  Created by Lyle Resnick on 2016-05-09.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

private protocol RowInterface {
    func getType() -> RowType
}

//private protocol BindingCell  {
//    func bind(row: RowInterface)
//    
//}

private enum RowType {
    case  HEADER
    case  SUBHEADER
    case  ROW
    case  MESSAGE_ROW
    case  TOTAL_ROW
    case  SUB_FOOTER_ROW
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

    private var dataset = [RowInterface]()
    private var odd = false
    
    enum Cells: String {
        case Header
        case Subheader
        case Detail
        case Message
        case Total
        case Subfooter
    }
    
    func appendHeaderRow(name: String , subtitle: String ) {
    
        dataset.append(HeaderRow(title: name, subtitle: subtitle));
    }
    
    func appendSubHeaderRow( inDateString: String ) {
    
        odd = !odd;
        
        guard
            let date = inboundDateFormat.dateFromString( inDateString )
        else {
            NSLog("Format of Transaction Date  is incorrect")
            abort()
        }
        let outDate = outboundDateFormat.stringFromDate(date)
        dataset.append(SubHeaderRow(title: outDate, odd: odd))
    }
    
    func appendDetailRow(description: String, amount: Double, debit: String) {
    
        let amountString = (debit == "D" ? "" : "-") + String( format: "%.2d", amount )
        dataset.append( DetailRow(description: description, amount: amountString, odd: odd));
    }
    
    func appendSubFooterRow() {
    
        dataset.append( SubFooterRow( odd: odd ));
    }
    
    func appendTotalRow(total: Double) {
    
        odd = !odd;
        let totalString = String( format: "%.2f", total)
        dataset.append(TotalRow(total: totalString, odd: odd));
    }
    
    func appendMessageRow(message: String) {
    
        dataset.append(MessageRow(message: message));
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Cells.Header.rawValue, forIndexPath: indexPath) as! BindingCell
        cell.bind(dataset[ indexPath.row ])
        return cell;
    }
    
//    public void onBindViewCell(UITableViewCell holder, int position) {
//    
//    holder.bind(position);
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataset.count
    }
    
    
    // UITableViewCell
    
    
    static func processBackgroundColour(odd: Bool, view: UIView ) {
    
        if odd {
            view.backgroundColor = UIColor( rgb: oddBandBackground );
        }
        else {
            view.backgroundColor = UIColor( rgb: evenBandBackground );
        }
    }
    
    private struct HeaderRow : RowInterface {
    
        let title: String
        let subtitle: String
        
        func getType() -> RowType  {
        
            return .HEADER;
        }
    }
    
    private struct SubHeaderRow : RowInterface {
    
        let title: String
        let odd: Bool
        
        func getType() -> RowType  {
            return .SUBHEADER;
        }
    }
    
    private struct DetailRow : RowInterface {
    
        let description: String
        let amount: String
        let odd: Bool
        
        func getType() -> RowType  {
        
            return .ROW;
        }
    }
    
    
    private struct SubFooterRow : RowInterface {
    
        let odd : Bool
        
        func getType() -> RowType  {
            return .SUB_FOOTER_ROW;
        }
    }
    
    private struct TotalRow : RowInterface {
    
        let total: String
        let odd: Bool
        
        func getType() -> RowType  {
            return .TOTAL_ROW;
        }
    }
    
    private struct MessageRow : RowInterface {
    
        let message: String
        
        func getType() -> RowType  {
            return .MESSAGE_ROW;
        }
    }
    
    
    // Row
    
    private class BindingCell: UITableViewCell {
        private func bind(row: RowInterface) {
            assert(true, "must override bind")
        }

    }
    
    
     private class HeaderCell: BindingCell {
     
        @IBOutlet var titleLabel: UILabel!
        @IBOutlet var subtitleLabel: UILabel!
    
        private override func bind(row: RowInterface) {
    
            let headerRow =  row as! HeaderRow
            titleLabel.text = headerRow.title
            subtitleLabel.text = headerRow.subtitle
        
        }
    }
    
    private class SubHeaderCell: BindingCell {
    
        @IBOutlet var titleLabel: UILabel!
        
        private override func bind(row: RowInterface) {
        
            let subheaderRow =  row as! SubHeaderRow
            titleLabel.text = subheaderRow.title
        
            DataSource.processBackgroundColour(subheaderRow.odd, view: contentView);
        }
    }
    
    private class DetailCell: BindingCell {
    
        @IBOutlet var descriptionLabel: UILabel!
        @IBOutlet var amountLabel: UILabel!
    
        private override func bind(row: RowInterface) {
    
            let detailRow = row as! DetailRow
            descriptionLabel.text = detailRow.description
            amountLabel.text = detailRow.amount
            
            DataSource.processBackgroundColour(detailRow.odd, view: contentView);
        }
    }
        
    
    private class SubFooterCell: BindingCell {

        private override func bind(row: RowInterface) {
    
            let subfooterRow = row as! SubFooterRow
            DataSource.processBackgroundColour(subfooterRow.odd, view: contentView);
        }
    }
    
    private class TotalCell: BindingCell {
    
        @IBOutlet var totalLabel: UILabel!
        
        
        private override func bind(row: RowInterface) {
        
            let totalRow = row as! TotalRow
            totalLabel.text = totalRow.total
            
            DataSource.processBackgroundColour(totalRow.odd, view: contentView);
        
        }
    }
    
    private class MessageCell: BindingCell {
    
        @IBOutlet var messageLabel: UILabel!
    
        private override func bind(row: RowInterface) {
    
            let messageRow = row as! MessageRow
            messageLabel.text = messageRow.message
            
            DataSource.processBackgroundColour(true, view: contentView);
        }
    }
   
    
    
    
}
