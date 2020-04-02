//
//  ContactsViewModel.swift
//  CustomerInvite
//
//  Created by Bruno Diniz on 30/03/2020.
//  Copyright © 2020 Bruno Diniz. All rights reserved.
//

import Foundation
import RxSwift

protocol ContactsViewModel: AnyObject {

    var api: ContactsApiManager { get set }
    var dataSource: Observable<[Contact]> { get }
    var isDataLoading: Observable<Bool> { get }
    var isDataFiltered: Observable<Bool> { get }
    var isRefreshing: Observable<Bool> { get }
    var alert: Observable<AlertDetails> { get }
    var share: Observable<[Any]> { get }

    func viewDidLoad()

    func importData()

    func exportData()

    func filterData()

    func refreshData()

}
