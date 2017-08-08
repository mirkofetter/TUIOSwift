//// Osc.swift by aike
//// licenced under MIT License.
//
//import Foundation
//import CFNetwork
//
//
//class Osc {
//    var host_: String = ""
//    var port_: UInt16 = 0
//    var message_: String = ""
//    
//    var sock_: Int32 = 0
//    var sa_family_: sa_family_t = sa_family_t(AF_INET)
//    var addr4_: sockaddr_in = sockaddr_in()
//    var addr6_: sockaddr_in6 = sockaddr_in6()
//    var address_list_: CFArray? = []
//    var socketReady_: Bool = false
//    
//    var argcount_: Int = 0
//    var sendbuf_: [UInt8] = []
//    var databuf_: [UInt8] = []
//    
//    var callback_: () -> Void = {}
//    
//    init() {
//        
//    }
//    
//    func SetHost(host: String, callback: @escaping () -> Void) {
//        socketReady_ = false;
//        host_ = host
//        if sock_ > 0 {
//            close(sock_)
//            sock_ = 0
//        }
//        callback_ = callback
//        GetHostByName(hostname: host)
//    }
//    
//    func SetPort(port: Int) {
//        let port:UInt16 = UInt16(port)
//        if !socketReady_ {
//            port_ = port
//            return
//        }
//        if port == port_ {
//            return
//        }
//        port_ = port
//        
//        if sock_ > 0 {
//            close(sock_)
//            sock_ = 0
//        }
//        if sa_family_ == sa_family_t(AF_INET) {
//            // IPv4
//            sa_family_ = UInt8(AF_INET)
//            addr4_.sin_family = sa_family_
//            addr4_.sin_len = UInt8(MemoryLayout.size(ofValue: addr4_))
//            addr4_.sin_port = port_.bigEndian
//            sock_ = socket(AF_INET, SOCK_DGRAM, 0)
//            socketReady_ = true
//            print("Osc: ready IPv4")
//        } else {
//            // IPv6
//            sa_family_ = UInt8(AF_INET6)
//            addr6_.sin6_family = sa_family_
//            addr6_.sin6_len = UInt8(MemoryLayout.size(ofValue: addr6_))
//            addr6_.sin6_port = port_.bigEndian
//            sock_ = socket(AF_INET6, SOCK_DGRAM, 0)
//            socketReady_ = true
//            print("Osc: ready IPv6")
//        }
//    }
//    
//    func GetHost() -> String {
//        return host_
//    }
//    
//    func GetPort() -> UInt16 {
//        return port_
//    }
//    
//    func GetMessage()-> String {
//        return message_
//    }
//    
//    func IsReady() -> Bool {
//        return socketReady_
//    }
//    
//    func ResetReadyFlag() {
//        socketReady_ = false;
//        host_ = ""
//    }
//    
//    func Close() {
//        if sock_ > 0 {
//            close(sock_)
//            sock_ = 0
//        }
//    }
//    
//    func GetHostByName(hostname: String) {
//        var ctx = CFHostClientContext(
//            version: 0,
//            info: unsafeBitCast(self, to: UnsafeMutableRawPointer.self),
//            retain: nil,
//            release: nil,
//            copyDescription: unsafeBitCast(0, to: CFAllocatorCopyDescriptionCallBack.self))
//        
//        let hostref = CFHostCreateWithName(nil, hostname as CFString)
//        let host:CFHost = hostref.takeRetainedValue()
//        
//        CFHostSetClient(host, { (host, infoType, error, info) in
//            if info == nil {
//                return
//            }
//            let obj = unsafeBitCast(info, to: Osc.self)
//            obj.GetAddress(host: host)
//            CFHostUnscheduleFromRunLoop(host, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)
//            obj.callback_()
//        }, &ctx)
//        
//        CFHostScheduleWithRunLoop(host, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)
//        CFHostStartInfoResolution(host, CFHostInfoType.addresses, nil)
//    }
//    
//    func GetAddress(host:CFHost) {
//        var resolved: DarwinBoolean = false
//        let addresses:Unmanaged<CFArray>? = CFHostGetAddressing(host, &resolved)
//        if addresses == nil {
//            return
//        }
//        address_list_ = addresses!.takeUnretainedValue()
//        if address_list_ == nil {
//            return
//        }
//        
//        // IPv4
//        for i in 0 ..< CFArrayGetCount(address_list_) {
//            let data = unsafeBitCast(CFArrayGetValueAtIndex(address_list_, i), to: CFData.self)
//            let address4 = UnsafePointer<sockaddr_in>(CFDataGetBytePtr(data))
//            addr4_ = unsafeBitCast(address4?.pointee, to: sockaddr_in.self)
//            if addr4_.sin_family == sa_family_t(AF_INET) {
//                // IPv4
//                sa_family_ = UInt8(AF_INET)
//                addr4_.sin_family = sa_family_
//                addr4_.sin_len = UInt8(MemoryLayout.size(ofValue: addr4_))
//                addr4_.sin_port = port_.bigEndian
//                sock_ = socket(AF_INET, SOCK_DGRAM, 0)
//                socketReady_ = true
//                print("Osc: ready IPv4")
//                return
//            }
//        }
//        
//        // IPv6
//        for i in 0 ..< CFArrayGetCount(address_list_) {
//            let data = unsafeBitCast(CFArrayGetValueAtIndex(address_list_, i), CFData.self)
//            let address6 = UnsafePointer<sockaddr_in6>(CFDataGetBytePtr(data))
//            addr6_ = unsafeBitCast(address6.memory, sockaddr_in6.self)
//            if addr6_.sin6_family == sa_family_t(AF_INET6) {
//                // IPv6
//                sa_family_ = UInt8(AF_INET6)
//                addr6_.sin6_family = sa_family_
//                addr6_.sin6_len = UInt8(sizeofValue(addr6_))
//                addr6_.sin6_port = port_.bigEndian
//                sock_ = socket(AF_INET6, SOCK_DGRAM, 0)
//                socketReady_ = true
//                print("Osc: ready IPv6")
//                return
//            }
//        }
//    }
//    
//    func Send() {
//        if !socketReady_ {
//            print("Osc: socket not ready")
//            return
//        }
//        if port_ == 0 {
//            print("Osc: bud port number")
//        }
//        
//        sendbuf_.append(0x00)
//        sendbufFill4byte()
//        sendbuf_ += databuf_
//        
//        if (sa_family_ == UInt8(AF_INET)) {
//            withUnsafePointer(&addr4_) { ptr -> Void in
//                let addrptr = UnsafePointer<sockaddr>(ptr)
//                sendto(sock_, sendbuf_, sendbuf_.count, 0,  addrptr, socklen_t(MemoryLayout<sockaddr_in>.size))
//            }
//        } else {
//            withUnsafePointer(to: &addr6_) { ptr -> Void in
//                let addrptr = UnsafePointer<sockaddr>(ptr)
//                sendto(sock_, sendbuf_, sendbuf_.count, 0,  addrptr, socklen_t(sizeof(sockaddr_in6.self)))
//            }
//        }
//    }
//    
//    func Send(host: String, port: Int) {
//        SetHost(host, callback: {
//            self.SetPort(port)
//            self.Send()
//        })
//    }
//    
//    func PushAddress(adrs: String) {
//        ClearArg()
//        sendbuf_ += adrs.utf8
//        sendbuf_.append(0x00)
//        sendbufFill4byte()
//        sendbuf_.append(0x2C)
//        message_ += adrs
//    }
//    
//    func PushArg(arg: Int) {
//        let argI32:Int32 = Int32(arg)
//        databuf_ += toByteArray(value: argI32.bigEndian)
//        sendbuf_.append(0x69)
//        argcount_ += 1
//        message_ += " " + String(arg)
//    }
//    
//    func PushArg(arg: Float) {
//        let i:UInt32 = unsafeBitCast(Float32(arg), to: UInt32.self)
//        databuf_ += toByteArray(value: i.bigEndian)
//        sendbuf_.append(0x66)
//        argcount_ += 1
//        message_ += " " + String(arg)
//    }
//    
//    func PushArg(arg: String) {
//        databuf_ += arg.utf8
//        databuf_.append(0x00)
//        databufFill4byte()
//        sendbuf_.append(0x73)
//        argcount_ += 1
//        message_ += " \"" + String(arg) + "\""
//    }
//    
//    func ClearArg() {
//        argcount_ = 0
//        sendbuf_ = []
//        databuf_ = []
//        message_ = ""
//    }
//    
//    private func sendbufFill4byte() {
//        while sendbuf_.count % 4 != 0 {
//            sendbuf_.append(0x00)
//        }
//    }
//    
//    private func databufFill4byte() {
//        while databuf_.count % 4 != 0 {
//            databuf_.append(0x00)
//        }
//    }
//    
//    private func toByteArray<T>(value: T) -> [UInt8] {
//        var value = value
//        return withUnsafePointer(to: &value) {
//            Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>($0), count: sizeof(T)))
//        }
//    }
//}
