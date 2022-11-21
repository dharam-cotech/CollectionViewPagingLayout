//
//  PagingCollectionViewControllerBuilder.swift
//  CollectionViewPagingLayout
//
//  Created by Amir on 28/03/2021.
//  Copyright © 2021 Amir Khorsandi. All rights reserved.
//

import SwiftUI

public class PagingCollectionViewControllerBuilder<ValueType: Identifiable, PageContent: View> {

    public typealias ViewController = PagingCollectionViewController<ValueType, PageContent>

    // MARK: Properties

    let data: [ValueType]
    let pageViewBuilder: (ValueType, CGFloat) -> PageContent
    let selection: Binding<ValueType.ID?>?

    var modifierData: PagingCollectionViewModifierData = .init()

    weak var viewController: ViewController?
    var onCurrentPageChanged: ((Int) -> Void)?


    // MARK: Lifecycle

    public init(
        data: [ValueType],
        pageViewBuilder: @escaping (ValueType, CGFloat) -> PageContent,
        selection: Binding<ValueType.ID?>?,
        onCurrentPageChanged: ((Int) -> Void)? = nil
    ) {
        self.data = data
        self.pageViewBuilder = pageViewBuilder
        self.selection = selection
        self.onCurrentPageChanged = onCurrentPageChanged
    }

    public init(
        data: [ValueType],
        pageViewBuilder: @escaping (ValueType) -> PageContent,
        selection: Binding<ValueType.ID?>?,
        onCurrentPageChanged: ((Int) -> Void)? = nil
    ) {
        self.data = data
        self.pageViewBuilder = { value, _ in pageViewBuilder(value) }
        self.selection = selection
        self.onCurrentPageChanged = onCurrentPageChanged
    }


    // MARK: Public functions
    
    func make() -> ViewController {
        let viewController = ViewController()
        viewController.pageViewBuilder = pageViewBuilder
        viewController.modifierData = modifierData
        viewController.update(list: data, currentIndex: nil)
        setupOnCurrentPageChanged(viewController)
        return viewController
    }

    func update(viewController: ViewController) {
        let selectedIndex = data.enumerated().first {
            $0.element.id == selection?.wrappedValue
        }?.offset
        viewController.modifierData = modifierData
        viewController.update(list: data, currentIndex: selectedIndex)
        setupOnCurrentPageChanged(viewController)
    }


    // MARK: Private functions

    private func setupOnCurrentPageChanged(_ viewController: ViewController) {
        viewController.onCurrentPageChanged = { [data, selection] in
            guard $0 >= 0 && $0 < data.count else { return }
            selection?.wrappedValue = data[$0].id
            self.onCurrentPageChanged?($0)
        }
    }
}
