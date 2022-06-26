//
//  AddressClient.swift
//  Mercury-Store
//
//  Created by mac hub on 13/06/2022.
//

import RxSwift

protocol AddressProvider: AnyObject {
    func postAddress(with customerId: Int , addressRequest: AddressRequest) -> Observable<AddressResponse>
    func getAddress(with id:Int) -> Observable<AddressesResponse>
    func putAddress(with customerId: Int,with addressId: Int , addressRequest: AddressRequestPut) -> Observable<AddressResponse>
    func deleteAddress(with customerId:Int, and addressId: Int) -> Observable<EmptyObject>

}

class AddressClient: AddressProvider {
    func postAddress(with customerId: Int, addressRequest: AddressRequest) -> Observable<AddressResponse> {
        NetworkService().execute(AddressAPI.postAddress(customerId, addressRequest))
    }
    func getAddress(with id:Int) -> Observable<AddressesResponse>{
        NetworkService().execute(AddressAPI.getAddress(id))
    }
    func putAddress(with customerId: Int,with addressId: Int , addressRequest: AddressRequestPut) -> Observable<AddressResponse>{
        NetworkService().execute(AddressAPI.putAddress(customerId, addressId, addressRequest))
    }
    func deleteAddress(with customerId: Int, and addressId: Int) -> Observable<EmptyObject> {
        NetworkService().execute(AddressAPI.deleteAddress(customerId, addressId))
    }
}


