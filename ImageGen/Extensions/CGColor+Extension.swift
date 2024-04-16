//
//  File.swift
//  
//
//  Created by Denis Dmitriev on 04.09.2023.
//

import CoreImage

extension CGColor {
    
    public enum ColorDifferenceResult: Comparable {
        
        /// There is no difference between the two colors.
        case indentical(CGFloat)
        
        /// The difference between the two colors is not perceptible by human eye.
        case similar(CGFloat)
        
        /// The difference between the two colors is perceptible through close observation.
        case close(CGFloat)
        
        /// The difference between the two colors is perceptible at a glance.
        case near(CGFloat)
        
        /// The two colors are different, but not opposite.
        case different(CGFloat)
        
        /// The two colors are more opposite than similar.
        case far(CGFloat)
        
        init(value: CGFloat) {
            if value == 0 {
                self = .indentical(value)
            } else if value <= 1.0 {
                self = .similar(value)
            } else if value <= 2.0 {
                self = .close(value)
            } else if value <= 10.0 {
                self = .near(value)
            } else if value <= 50.0 {
                self = .different(value)
            } else {
                self = .far(value)
            }
        }
        
        var associatedValue: CGFloat {
            switch self {
            case .indentical(let value),
                 .similar(let value),
                 .close(let value),
                 .near(let value),
                 .different(let value),
                 .far(let value):
                 return value
            }
        }
        
        public static func < (lhs: CGColor.ColorDifferenceResult, rhs: CGColor.ColorDifferenceResult) -> Bool {
            return lhs.associatedValue < rhs.associatedValue
        }
                
    }
    
    /// Computes the difference between the passed in `CGColor` instance.
    ///
    /// - Parameters:
    ///   - color: The color to compare this instance to.
    ///   - formula: The algorithm to use to make the comparaison.
    /// - Returns: The different between the passed in `CGColor` instance and this instance.
    public func difference(from color: CGColor, using formula: DeltaEFormula = .CIE94) -> ColorDifferenceResult {
        switch formula {
        case .euclidean:
            let differenceValue = sqrt(pow(self.red255 - color.red255, 2) + pow(self.green255 - color.green255, 2) + pow(self.blue255 - color.blue255, 2))
            let roundedDifferenceValue = differenceValue.rounded(.toNearestOrEven, precision: 100)
            return ColorDifferenceResult(value: roundedDifferenceValue)
        case .CIE76:
            let differenceValue = sqrt(pow(color.L - self.L, 2) + pow(color.a - self.a, 2) + pow(color.b - self.b, 2))
            let roundedDifferenceValue = differenceValue.rounded(.toNearestOrEven, precision: 100)
            return ColorDifferenceResult(value: roundedDifferenceValue)
        case .CIE94:
            let differenceValue = CGColor.deltaECIE94(lhs: self, rhs: color)
            let roundedDifferenceValue = differenceValue.rounded(.toNearestOrEven, precision: 100)
            return ColorDifferenceResult(value: roundedDifferenceValue)
        case .CIEDE2000:
            let differenceValue = CGColor.deltaCIEDE2000(lhs: self, rhs: color)
            let roundedDifferenceValue = differenceValue.rounded(.toNearestOrEven, precision: 100)
            return ColorDifferenceResult(value: roundedDifferenceValue)
        case .CMC:
            let differenceValue = CGColor.deltaCMC(lhs: self, rhs: color)
            let roundedDifferenceValue = differenceValue.rounded(.toNearestOrEven, precision: 100)
            return ColorDifferenceResult(value: roundedDifferenceValue)
        }
    }
    
    private static func deltaECIE94(lhs: CGColor, rhs: CGColor) -> CGFloat {
        let kL: CGFloat = 1.0
        let kC: CGFloat = 1.0
        let kH: CGFloat = 1.0
        let k1: CGFloat = 0.045
        let k2: CGFloat = 0.015
        let sL: CGFloat = 1.0
        
        let c1 = sqrt(pow(lhs.a, 2) + pow(lhs.b, 2))
        let sC = 1 + k1 * c1
        let sH = 1 + k2 * c1
        
        let deltaL = lhs.L - rhs.L
        let deltaA = lhs.a - rhs.a
        let deltaB = lhs.b - rhs.b
                
        let c2 = sqrt(pow(rhs.a, 2) + pow(rhs.b, 2))
        let deltaCab = c1 - c2

        let deltaHab = sqrt(pow(deltaA, 2) + pow(deltaB, 2) - pow(deltaCab, 2))
        
        let p1 = pow(deltaL / (kL * sL), 2)
        let p2 = pow(deltaCab / (kC * sC), 2)
        let p3 = pow(deltaHab / (kH * sH), 2)
        
        let deltaE = sqrt(p1 + p2 + p3)
        
        return deltaE
    }
    
    private static func deltaCIEDE2000(lhs: CGColor, rhs: CGColor) -> CGFloat {
        let kL: CGFloat = 1.0
        let kC: CGFloat = 1.0
        let kH: CGFloat = 1.0
        let k1: CGFloat = 0.045
        let k2: CGFloat = 0.015
        let sL: CGFloat = 1.0
        
        let c1 = sqrt(pow(lhs.a, 2) + pow(lhs.b, 2))
        let sC = 1 + k1 * c1
        let sH = 1 + k2 * c1
        
        let deltaL = lhs.L - rhs.L
        let deltaA = lhs.a - rhs.a
        let deltaB = lhs.b - rhs.b
                
        let c2 = sqrt(pow(rhs.a, 2) + pow(rhs.b, 2))
        let deltaCab = c1 - c2

        let deltaHab = sqrt(pow(deltaA, 2) + pow(deltaB, 2) - pow(deltaCab, 2))
        
        let pi = CGFloat.pi
        let cAverage = (c1 + c2) / 2
        let cHelp = sqrt(pow(cAverage, 7) / (pow(cAverage, 7) + pow(25, 7)))
        
        let b1 = lhs.b
        let a1 = lhs.a
        let a1Trait = a1 + (a1 / 2) * (1 - (1 / 2) * cHelp)
        
        let b2 = rhs.b
        let a2 = rhs.a
        let a2Trait = a1 + (a2 / 2) * (1 - (1 / 2) * cHelp)
        
        let h1Shift = atan(b1 / a1Trait).truncatingRemainder(dividingBy: 2 * pi)
        let h2Shift = atan(b2 / a2Trait).truncatingRemainder(dividingBy: 2 * pi)
        
        let deltaHAverage = (h1Shift - h2Shift) > pi
        let extraAngle = deltaHAverage ? 2 * pi : .zero
        let hAverage = (h1Shift + h2Shift + extraAngle) / 2
        let valueRtHelp = 5 * pi / 36
        let expValue = pow((hAverage - 11 * valueRtHelp) / valueRtHelp, 2)
        
        let rT = -2 * cHelp * sin((pi / 6) * exp(-expValue))
        
        let p1 = pow(deltaL / (kL * sL), 2)
        let p2 = pow(deltaCab / (kC * sC), 2)
        let p3 = pow(deltaHab / (kH * sH), 2)
        let p4 = rT * (deltaCab * deltaHab) / (sC * sH)
        
        let deltaE = sqrt(p1 + p2 + p3 + p4)
        
        return deltaE
    }
    
    ///http://www.brucelindbloom.com/index.html?Eqn_DeltaE_CMC.html
    private static func deltaCMC(lhs: CGColor, rhs: CGColor) -> CGFloat {
        let lab1 = Lab(L: lhs.L, a: lhs.a, b: lhs.b)
        let lab2 = Lab(L: rhs.L, a: rhs.a, b: rhs.b)

        let c1 = sqrt(pow(lab1.a, 2) + pow(lab1.b, 2))
        let c2 = sqrt(pow(lab2.a, 2) + pow(lab2.b, 2))
        let deltaC = c1 - c2

        let deltaA = lab1.a - lab2.a
        let deltaB = lab1.b - lab2.b

        let deltaH = sqrt(pow(deltaA, 2) + pow(deltaB, 2) - pow(deltaC, 2))

        let deltaL = lab1.L - lab2.L

        let sL = lab1.L < 16 ? 0.511 : (0.040975 * lab1.L) / (1 + 0.01765 * lab1.L)

        let sC = (0.0638 * c1) / (1 + 0.0131 * c1) + 0.638

        let h = lab1.a == 0 ? 0 : atan(lab1.b / lab1.a)
        let h1 = h >= 0 ? h : h + 360

        let t = 164...345 ~= h1 ? 0.56 + abs(0.2 * cos(h1 + 168)) : 0.36 + abs(0.4 * cos(h1 + 35))

        let f = sqrt(pow(c1, 4) / (pow(c1, 4) + 1900))

        let sH = sC * (f * t + 1 - f)

        let p1 = pow((deltaL / sL), 2)
        let p2 = pow((deltaC / sC), 2)
        let p3 = pow((deltaH / sH), 2)

        let deltaE = sqrt(p1 + p2 + p3) / 2 // because result from 0...200 / 100 = 0...100
        
        return deltaE
    }
}



struct RGB: Hashable {
    let R: CGFloat
    let G: CGFloat
    let B: CGFloat
}

extension CGColor {
    // MARK: - Public
    
    /// The red (R) channel of the RGB color space as a value from 0.0 to 1.0.
    public var red: CGFloat {
        CIColor(cgColor: self).red
    }
    
    /// The green (G) channel of the RGB color space as a value from 0.0 to 1.0.
    public var green: CGFloat {
        CIColor(cgColor: self).green
    }
    
    /// The blue (B) channel of the RGB color space as a value from 0.0 to 1.0.
    public var blue: CGFloat {
        CIColor(cgColor: self).blue
    }
    
    /// The alpha (a) channel of the RGBa color space as a value from 0.0 to 1.0.
//    public var alpha: CGFloat {
//        CIColor(cgColor: self).alpha
//    }
    
    // MARK: Internal
    
    var red255: CGFloat {
        self.red * 255.0
    }
    
    var green255: CGFloat {
        self.green * 255.0
    }
    
    var blue255: CGFloat {
        self.blue * 255.0
    }
    
    var rgb: RGB {
        return RGB(R: self.red, G: self.green, B: self.blue)
    }
}

public struct HSL {
    let hue: Double
    let saturation: Double
    let lightness: Double
    
    init?(cgColor: CGColor) {
        let red = UInt8(cgColor.red255)
        let green = UInt8(cgColor.green255)
        let blue = UInt8(cgColor.blue255)
        
        let hsl = HSLCalculator.convert(red: red, green: green, blue: blue)
        
        self.hue = hsl.hue
        self.saturation = hsl.saturation
        self.lightness = hsl.lightness
    }
    
    init(hue: Double, saturation: Double, lightness: Double) {
        self.hue = hue
        self.saturation = saturation
        self.lightness = lightness
    }
}

struct HSLCalculator {
    
    /// Input RGB color with 0...255 color channels
    static func convert(red: UInt8, green: UInt8, blue: UInt8) -> HSL {
        let red = Double(red)
        let green = Double(green)
        let blue = Double(blue)
        let minColor = min(red, green, blue)
        let maxColor = max(red, green, blue)

        let lightness = 1/2 * (maxColor + minColor) / 255.0

        let delta = (maxColor - minColor) / 255.0

        let saturation: Double
        
        switch lightness {
        case 0:
            saturation = 0.0
        case 1:
            saturation = 0.0
        default:
            saturation = delta / (1 - abs(2 * lightness - 1))
        }

        let hue: Double
        if (delta == 0) {
            hue = 0
        } else {
            switch(maxColor) {
            case red:
                let segment = (green - blue) / (delta * 255)
                var shift = 0 / 60.0 // R° / (360° / hex sides)
                if segment < 0 { // hue > 180, full rotation
                    shift = 360 / 60 // R° / (360° / hex sides)
                }
                hue = segment + shift
            case green:
                let segment = (blue - red) / (delta * 255)
                let shift   = 120.0 / 60.0 // G° / (360° / hex sides)
                hue = segment + shift
            case blue:
                let segment = (red - green) / (delta * 255)
                let shift   = 240.0 / 60.0 // B° / (360° / hex sides)
                hue = segment + shift
            default:
                hue = .zero
            }
        }
        
        return HSL(hue: hue * 60, saturation: saturation * 100, lightness: lightness * 100)
    }
}


struct Lab {
    let L: CGFloat
    let a: CGFloat
    let b: CGFloat
}

struct LabCalculator {
    static func convert(RGB: RGB) -> Lab {
        let XYZ = XYZCalculator.convert(rgb: RGB)
        let Lab = LabCalculator.convert(XYZ: XYZ)
        return Lab
    }
    
    static let referenceX: CGFloat = 95.047
    static let referenceY: CGFloat = 100.0
    static let referenceZ: CGFloat = 108.883
    
    static func convert(XYZ: XYZ) -> Lab {
        func transform(value: CGFloat) -> CGFloat {
            if value > 0.008856 {
                return pow(value, 1 / 3)
            } else {
                return (7.787 * value) + (16 / 116)
            }
        }
        
        let X = transform(value: XYZ.X / referenceX)
        let Y = transform(value: XYZ.Y / referenceY)
        let Z = transform(value: XYZ.Z / referenceZ)
        
        let L = ((116.0 * Y) - 16.0).rounded(.toNearestOrEven, precision: 100)
        let a = (500.0 * (X - Y)).rounded(.toNearestOrEven, precision: 100)
        let b = (200.0 * (Y - Z)).rounded(.toNearestOrEven, precision: 100)
        
        return Lab(L: L, a: a, b: b)
    }
}

extension CGColor {
    
    /// The L* value of the CIELAB color space.
    /// L* represents the lightness of the color from 0 (black) to 100 (white).
    public var L: CGFloat {
        let Lab = LabCalculator.convert(RGB: self.rgb)
        return Lab.L
    }
    
    /// The a* value of the CIELAB color space.
    /// a* represents colors from green to red.
    public var a: CGFloat {
        let Lab = LabCalculator.convert(RGB: self.rgb)
        return Lab.a
    }
    
    /// The b* value of the CIELAB color space.
    /// b* represents colors from blue to yellow.
    public var b: CGFloat {
        let Lab = LabCalculator.convert(RGB: self.rgb)
        return Lab.b
    }
    
}

struct XYZ {
    let X: CGFloat
    let Y: CGFloat
    let Z: CGFloat
}

struct XYZCalculator {
    
    static func convert(rgb: RGB) -> XYZ {
        func transform(value: CGFloat) -> CGFloat {
            if value > 0.04045 {
                return pow((value + 0.055) / 1.055, 2.4)
            }
            
            return value / 12.92
        }
        
        let red = transform(value: rgb.R) * 100.0
        let green = transform(value: rgb.G) * 100.0
        let blue = transform(value: rgb.B) * 100.0
        
        let X = (red * 0.4124 + green * 0.3576 + blue * 0.1805).rounded(.toNearestOrEven, precision: 100)
        let Y = (red * 0.2126 + green * 0.7152 + blue * 0.0722).rounded(.toNearestOrEven, precision: 100)
        let Z = (red * 0.0193 + green * 0.1192 + blue * 0.9505).rounded(.toNearestOrEven, precision: 100)

        return XYZ(X: X, Y: Y, Z: Z)
    }
    
}

extension CGColor {
    
    /// The X value of the XYZ color space.
    public var X: CGFloat {
        let XYZ = XYZCalculator.convert(rgb: self.rgb)
        return XYZ.X
    }
    
    /// The Y value of the XYZ color space.
    public var Y: CGFloat {
        let XYZ = XYZCalculator.convert(rgb: self.rgb)
        return XYZ.Y
    }
    
    /// The Z value of the XYZ color space.
    public var Z: CGFloat {
        let XYZ = XYZCalculator.convert(rgb: self.rgb)
        return XYZ.Z
    }
    
}


extension CGColor {
    
    /// Computes the complementary color of the current color instance.
    /// Complementary colors are opposite on the color wheel.
    public var complementaryColor: CGColor {
        let red: CGFloat = (255.0 - red255) / 255.0
        let green: CGFloat = (255.0 - green255) / 255.0
        let blue: CGFloat = (255.0 - blue255) / 255.0
        
        let components: [CGFloat] = [red, green, blue, alpha]
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        
        let cgColor = CGColor(colorSpace: colorSpace, components: components) ?? self
        return cgColor
    }
    
}
