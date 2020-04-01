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

        static let distanceFromOfficeMessage = "Distance from office: %@"
        static let dublinOfficeCoordinates = Coordinates(53.339428, -6.257664)
        static let maxDistanceFromOffice: Double = 100
        static let defaultErrorMessage = "Something wrong happened. Try again later."
        static let createFileErrorMessage = "Not able to create export file"
        static let errorTitle = "Oops..."

    }

    let api: ContactsApiManager = ContactsApiManagerBase()
    private var contacts = [Contact]()
    private var isFiltered = false

    // MARK: - Rx observables

    lazy var dataSource = { _dataSource.asObservable() }()
    lazy var isDataLoading = { _isDataLoading.asObservable() }()
    lazy var isDataFiltered = { _isDataFiltered.asObservable() }()
    lazy var alert = { _alert.asObservable() }()
    lazy var share = { _share.asObservable() }()

    // MARK: - Rx publishers

    private let _dataSource = PublishSubject<[Contact]>()
    private let _isDataLoading = BehaviorRelay<Bool>(value: false)
    private let _isDataFiltered = BehaviorRelay<Bool>(value: false)
    private let _alert = PublishSubject<AlertDetails>()
    private let _share = PublishSubject<[Any]>()

    // MARK: - Public methods

    func viewDidLoad() {
        importData()
        publishDataSource()
        publishDataIsFiltered()
    }

    func importData() {
        _isDataLoading.accept(true)
        api.downloadTxtAsString { [weak self] (dataString, error) in
            guard let self = self else { return }
            if let dataString = dataString {
                self.contacts = self.convertStringData(from: dataString)
                self.publishDataSource()
            } else {
                let details = AlertDetails(alertTitle: Constants.errorTitle,
                                           alertMessage: error?.localizedDescription ?? Constants.defaultErrorMessage)
                self._alert.onNext(details)
            }
            self._isDataLoading.accept(false)
        }
    }

    func exportData() {
        let data = isFiltered ? contacts.filter { $0.distanceFromOffice <= Constants.maxDistanceFromOffice } : contacts
        if let shareableItem = DataManager.export(data) {
            _share.onNext([shareableItem])
        } else {
            let details = AlertDetails(alertTitle: Constants.errorTitle, alertMessage: Constants.createFileErrorMessage)
            _alert.onNext(details)
        }
    }

    func filterData() {
        isFiltered.toggle()
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

    private func calculateDistanceFromOffice(contact: Response) -> Double {
        let latitude = Double(contact.latitude) ?? 0
        let longitude = Double(contact.longitude) ?? 0
        let coordinates = Coordinates(latitude, longitude)
        return Distance.instance.distance(from: Constants.dublinOfficeCoordinates, to: coordinates)
    }

    private func convertStringData(from data: String) -> [Contact] {
        data.split(separator: "\n")
            .compactMap { try? JSONDecoder().decode(Response.self, from: Data($0.utf8)) }
            .map { Contact(id: $0.userId, name: $0.name, distanceFromOffice: calculateDistanceFromOffice(contact: $0)) }
            .sorted { $0.id < $1.id }
    }

}
