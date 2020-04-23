// https://github.com/rase-rocks/Geoflash

import Foundation

struct GeoRange {
    let min: Double
    let max: Double
}

struct Geoflash {
    
    static let lat          = GeoRange(min: -90.0, max: 90.0)
    static let lng          = GeoRange(min: -180.0, max: 180.0)
    
    static let BASE32       = Array("0123456789bcdefghjkmnpqrstuvwxyz")
    
    static func hash(latitude: Double, longitude: Double, precision: Int = 12) -> String {
        
        var lat             = Geoflash.lat
        var lng             = Geoflash.lng

        var hash            = Array<Character>()

        var isEven          = true
        var char            = 0
        var count           = 0

        func compare(range: GeoRange, source: Double) -> GeoRange {
            
            let mean        = (range.min + range.max) / 2
            let isLow       = source < mean
            let (min, max)  = isLow ? (range.min, mean) : (mean, range.max)
            
            if !isLow {
                
                let mask = 0b10000 >> count
                char |= mask
                
            }
            
            return GeoRange(min: min, max: max)
            
        }

        repeat {
                        
            if isEven {
                
                lng = compare(range: lng, source: longitude)
                
            } else {
                
                lat = compare(range: lat, source: latitude)
                
            }
            
            isEven  = !isEven
            count   += 1
            
            if count == 5 {
                
                hash.append(BASE32[char])
                count   = 0
                char    = 0
                
            }

        } while hash.count < precision

        return String(hash)
        
    }
    
}
