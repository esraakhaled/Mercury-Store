//
//  CustomerClient.swift
//  Mercury-Store
//
//  Created by mac hub on 08/06/2022.
//

import RxSwift

protocol CustomerProvider: AnyObject {
    func postCustomer(_ customer: Customer) -> Observable<RegisterResponse>
    func checkEmailExists(_ email: String) -> Observable<AllCustomers>
    func getCustomer(id:Int) -> Observable<RegisterResponse>
    func editCustomer(id: Int, editCustomer: EditCustomer) -> Observable<RegisterResponse>
}

class CustomerClient: CustomerProvider {
    func postCustomer(_ customer: Customer) -> Observable<RegisterResponse> {
        NetworkService().execute(CustomerAPI.postCustomer(customer))
    }
    func checkEmailExists(_ email: String) -> Observable<AllCustomers> {
        NetworkService().execute(CustomerAPI.getCustomerByEmail(email))
    }
    func getCustomer(id:Int) -> Observable<RegisterResponse>{
        NetworkService().execute(CustomerAPI.getCustomer(id))
    }
    
    func editCustomer(id: Int, editCustomer: EditCustomer) -> Observable<RegisterResponse> {
        NetworkService().execute(CustomerAPI.editCustomer(id, editCustomer))
    }
}
