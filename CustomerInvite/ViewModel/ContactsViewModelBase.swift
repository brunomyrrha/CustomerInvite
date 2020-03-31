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

    private struct Constants {
        static let fileUrlString = "https://s3.amazonaws.com/intercom-take-home-test/customers.txt"
        static let distanceFromOfficeMessage = "Distance from office: %@"
    }

    private var contacts = [Contact]()
    private var isContactsFiltered = false

    // MARK: - Rx observables

    lazy var dataSource = { _dataSource.asObservable() }()
    lazy var isDataLoading = { _isDataLoading.asObservable() }()
    lazy var isDataFiltered = { _isDataFiltered.asObservable() }()
    lazy var alert = { _alert.asObservable() }()

    // MARK: - Rx publishers

    private let _dataSource = PublishSubject<[Contact]>()
    private let _isDataLoading = BehaviorRelay<Bool>(value: false)
    private let _isDataFiltered = BehaviorRelay<Bool>(value: false)
    private let _alert = PublishSubject<AlertDetails>()

    // MARK: - Public methods

    func viewDidLoad() {
        publishContactList()
        publishDataIsFiltered()
    }


    func importData() {
        downloadTxt()
    }

    func exportData() {
        print("Export")
    }

    func filterData() {
        isContactsFiltered.toggle()
        publishDataIsFiltered()
    }
    
    // MARK: - Private methods

    private func publishContactList() {
        _dataSource.onNext(contacts)
    }

    private func publishDataIsFiltered() {
        _isDataFiltered.accept(isContactsFiltered)
    }

    private func downloadTxt() {
        _isDataLoading.accept(true)
        guard let url = URL(string: Constants.fileUrlString) else { return }
        FileManager.download(url: url) { (data, _, error) in
            guard let list = try? String(contentsOf: data as! URL) else {
                self._alert.onNext(AlertDetails(alertTitle: "NO", alertMessage: "Couldn't parse"))
                return
            }
            self.addToContacts(from: list)
            self.publishContactList()
            self._isDataLoading.accept(false)
        }
    }

    private func addToContacts(from data: String) {
        contacts.append(contentsOf: data.split(separator: "\n").compactMap {
            let jsonData = Data($0.utf8)
            return try? JSONDecoder().decode(Contact.self, from : jsonData)
        })
    }

}
