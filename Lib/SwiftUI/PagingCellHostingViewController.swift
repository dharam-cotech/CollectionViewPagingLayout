//
//  PagingCellHostingViewController.swift
//  CollectionViewPagingLayout
//
//  Created by Dharmendra Sharma on 20/11/22.
//  Copyright © 2022 Amir. All rights reserved.
//

import Foundation
import SwiftUI

class PagingCellHostingViewController <Content: View>: UIHostingController<Content> {
    
    public override init(rootView: Content) {
        super.init(rootView: rootView)
    }
    
    /// The hosting controller may in some cases want to make the navigation bar be not hidden.
    /// Restrict the access to the outside world, by setting the navigation controller to nil when internally accessed.
    public override var navigationController: UINavigationController? {
        nil
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
