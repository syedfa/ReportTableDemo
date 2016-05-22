
//  Created by Lyle Resnick on 2016-05-09.
//  Copyright © 2016 Cellarpoint. All rights reserved.
//

import UIKit

private enum Cell: String {
    case Header
    case Subheader
    case Detail
    case Subfooter
    case Footer
    case Message
}

private enum Row {
    case Header( title: String, subtitle: String )
    case Subheader( title: String, odd: Bool )
    case Detail( description: String, amount: String, odd: Bool )
    case Subfooter( odd : Bool )
    case Footer( total: String, odd: Bool )
    case Message( message: String )
   
    var cellId: Cell {
        get {
            switch self {
            case Header:
                return .Header
            case Subheader:
                return .Subheader
            case  Detail:
                return .Detail
            case Message:
                return .Message
            case Footer:
                return .Footer
            case Subfooter:
                return .Subfooter
            }
        }
    }
    var height: CGFloat {
        get {
            switch self {
            case Header:
                return 60.0
            case Subheader:
                return 34.0
            case Detail:
                return 18.0
            case Message:
                return 100.0
            case Footer:
                return 44.0
            case Subfooter:
                return 18.0
            }
        }
    }
}

class AccountDetailsTransactionListDataSourceDelegate: NSObject {
    
//    override init() {
//    }

    private var rows = [Row]()
    private var odd = false
    
    func appendHeaderWithTitle( title: String , subtitle: String ) {
    
        rows.append(.Header(title: title, subtitle: subtitle));
    }
    
    func appendSubheaderWithDate( date: String ) {
    
        odd = !odd;
        
        rows.append(.Subheader(title: date, odd: odd))
    }
    
    func appendDetailWithDescription( description: String, amount: String) {
    
        rows.append( .Detail(description: description, amount: amount, odd: odd));
    }
    
    func appendSubfooter() {
    
        rows.append(.Subfooter( odd: odd ));
    }
    
    func appendFooterWithTotal( total: String) {
    
        odd = !odd;
        rows.append(.Footer(total: total, odd: odd));
    }
    
    func appendMessage( message: String) {
    
        rows.append(.Message(message: message));
    }
}

// MARK: - UITableViewDataSource

extension AccountDetailsTransactionListDataSourceDelegate: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = rows[ indexPath.row ]
        let cell = tableView.dequeueReusableCellWithIdentifier(data.cellId.rawValue, forIndexPath: indexPath)
        (cell as! TransactionCell).bind(data)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
}

// MARK: - UITableViewDelegate

extension AccountDetailsTransactionListDataSourceDelegate: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rows[ indexPath.row ].height
    }
}

// MARK: - Cells

private protocol TransactionCell {
    func bind(row: Row)
}

extension TransactionCell where Self: UITableViewCell {
    
    private var oddBandBackground: Int { return 0xF7F8FC }
    private var evenBandBackground: Int { return 0xFAFBFD }
    
    private func setBackgroundColourAsOdd(odd: Bool ) {
        
        if odd {
            backgroundColor = UIColor( rgb: oddBandBackground );
        }
        else {
            backgroundColor = UIColor( rgb: evenBandBackground );
        }
    }
}

class HeaderCell: UITableViewCell, TransactionCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    private func bind(row: Row) {
        
        guard case let .Header( title, subtitle) = row else { assert(false) }
        titleLabel.text = title + " Transactions"
        subtitleLabel.text = subtitle
    }
}

class SubheaderCell: UITableViewCell, TransactionCell {
    
    @IBOutlet private var titleLabel: UILabel!
    
    private func bind(row: Row) {
        
        guard case let .Subheader( title, odd ) = row else { assert(false) }
        titleLabel.text = title
        setBackgroundColourAsOdd(odd)
    }
}

class DetailCell: UITableViewCell, TransactionCell {
    
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    
    private func bind(row: Row) {
        
        guard case let .Detail( description, amount, odd ) = row else { assert(false) }
        descriptionLabel.text = description
        amountLabel.text = amount
        setBackgroundColourAsOdd(odd)
    }
}


class SubfooterCell: UITableViewCell, TransactionCell {
    
    private func bind(row: Row) {
        
        guard case let .Subfooter( odd ) = row else { assert(false) }
        setBackgroundColourAsOdd(odd);
    }
}

class TotalCell: UITableViewCell, TransactionCell {
    
    @IBOutlet private var totalLabel: UILabel!
    
    private func bind(row: Row) {
        
        guard case let .Footer(total, odd) = row else { assert(false) }
        totalLabel.text = total
        setBackgroundColourAsOdd(odd)
    }
}

class MessageCell: UITableViewCell, TransactionCell {
    
    @IBOutlet private var messageLabel: UILabel!
    
    private  func bind(row: Row) {
        
        guard case let .Message( message ) = row else { assert(false) }
        messageLabel.text = message
        setBackgroundColourAsOdd(true)
    }
}


