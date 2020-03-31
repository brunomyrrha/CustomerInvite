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

    var dataSource: Observable<[Contact]> { get }
    var isDataLoading: Observable<Bool> { get }
    
    func viewDidLoad()

    func importData()

    func exportData()

    func filterData()

}
