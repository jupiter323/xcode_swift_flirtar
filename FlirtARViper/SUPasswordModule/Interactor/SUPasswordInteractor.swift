//
//  SUPasswordInteractor.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation

class SUPasswordInteractor: SUPasswordInteractorInputProtocol {
    func savePassword(password: String?) {
        ProfileService.currentUser?.password = password
    }
}
