//
//  TagRow.swift
//  Inventory
//
//  Created by Colby L Williams on 4/23/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Eureka

class TagCell: _FieldCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .asciiCapable
    }
}

class _TagRow: FieldRow<TagCell> {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

final class TagRow: _TagRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
