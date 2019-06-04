//
//  RepeatingTimer.swift
//  STPhotoMap-iOS
//
//  Created by Dimitri Strauneanu on 23/05/2019.
//  Copyright © 2019 mikelanza. All rights reserved.
//

import Foundation

class RepeatingTimer {
    let timeInterval: TimeInterval
    var eventHandler: (() -> Void)?
    
    init(timeInterval: TimeInterval, eventHandler: (() -> Void)? = nil) {
        self.timeInterval = timeInterval
        self.eventHandler = eventHandler
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        self.timer.setEventHandler {}
        self.timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        self.resume()
        self.eventHandler = nil
    }
    
    func resume() {
        if self.state == .resumed {
            return
        }
        self.state = .resumed
        self.timer.resume()
    }
    
    func suspend() {
        if self.state == .suspended {
            return
        }
        self.state = .suspended
        self.timer.suspend()
    }
}
