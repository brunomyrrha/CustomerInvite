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
        static let dublinOfficeCoordinates = Coordinates(53.339428, -6.257664)
        static let maxDistanceFromOffice: Double = 100
    }

    private var contacts = [Contact]()
    private var isFiltered = false

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
        publishDataSource()
        publishDataIsFiltered()
    }


    func importData() {
        downloadTxt()
    }

    func exportData() {
        print("Export")
    }

    func filterData() {
        isFiltered.toggle()
        print(isFiltered)
        publishDataSource()
        publishDataIsFiltered()
    }
    
    // MARK: - Private methods

    private func publishDataSource() {
        let data = isFiltered ? contacts.filter { $0.distanceFromOffice <= Constants.maxDistanceFromOffice } : contacts
        _dataSource.onNext(data)
    }

    private func publishDataIsFiltered() {
        _isDataFiltered.accept(isFiltered)
    }

    private func downloadTxt() {
        _isDataLoading.accept(true)
        guard let url = URL(string: Constants.fileUrlString) else { return }
        FileManager.download(url: url) { (data, _, error) in
            guard let list = try? String(contentsOf: data as! URL) else {
                self._alert.onNext(AlertDetails(alertTitle: "NO", alertMessage: "Couldn't parse"))
                return
            }
            self.contacts.removeAll()
            self.appendToContacts(from: list)
            self.publishDataSource()
            self._isDataLoading.accept(false)
        }
    }

    private func appendToContacts(from data: String) {
        contacts.append(contentsOf: data
            .split(separator: "\n")
            .compactMap { try? JSONDecoder().decode(Response.self, from : Data($0.utf8)) }
            .map { Contact(id: String($0.userId),
                           name: $0.name,
                           distanceFromOffice: calculateDistanceFromOffice(contact: $0)) }
        )
        contacts.sort { $0.id < $1.id }
    }

    private func calculateDistanceFromOffice(contact: Response) -> Double {
        101
    }

}
