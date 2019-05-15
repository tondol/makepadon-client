//
//  UIViewController+StoryboardInstantiable.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/13.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {}

extension StoryboardInstantiable where Self: UIViewController {
    
    static func instantiateFromStoryboard(storyboard: String) -> Self {
        let sb = UIStoryboard(name: storyboard, bundle: Bundle.main)
        return sb.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
}
