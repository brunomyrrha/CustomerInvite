//
//  ContactsViewModelBase.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 30/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ContactsViewModelBase: ContactsViewModel {

    private var contacts = [Contact]()

    // MARK: - Rx observables

    lazy var dataSource = { _dataSource.asObservable() }()
    lazy var isDataLoading = { _isDataLoading.asObservable() }()

    // MARK: - Rx publishers

    private let _dataSource = PublishSubject<[Contact]>()
    private let _isDataLoading = BehaviorRelay<Bool>(value: false)

    // MARK: - Public methods

    func viewDidLoad() {
        publishContactList()
    }


    func importData() {
        print("Import")
    }

    func exportData() {
        print("Export")
    }

    func filterData() {
        print("Filter")
    }
    
    // MARK: - Private methods

    private func publishContactList() {
        contacts.append(Contact(userId: 0, name: "Bruno", latitude: 0, longitude: 0))
        _dataSource.onNext(contacts)
    }


}
