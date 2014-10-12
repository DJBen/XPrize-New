//
//  Style.swift
//  XPrize-New
//
//  Created by Sihao Lu on 8/31/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit

var DefaultTheme: Style.Theme {
    get {
        return Style.defaultTheme()
    }
}

class Style: NSObject {
    class Theme {
        let colors: ColorTheme
        let fonts: FontTheme

        var mainColor: UIColor {
            get {
                return self.colors.mainColor
            }
        }
        var pureColor: UIColor {
            get {
                return self.colors.pureColor
            }
        }
        var pureTextColor: UIColor {
            get {
                return self.colors.pureTextColor
            }
        }
        var darkTextColor: UIColor {
            get {
                return self.colors.darkTextColor
            }
        }
        var darkerTextColor: UIColor {
            get {
                return self.colors.darkerTextColor
            }
        }

        class ColorTheme: ArrayLiteralConvertible {
            let mainColor: UIColor
            let pureColor: UIColor
            let pureTextColor: UIColor
            let darkTextColor: UIColor
            let darkerTextColor: UIColor

            required init(mainColor: UIColor, pureColor: UIColor, pureTextColor: UIColor, darkTextColor: UIColor, darkerTextColor: UIColor) {
                self.mainColor = mainColor
                self.pureTextColor = pureTextColor
                self.pureColor = pureColor
                self.darkTextColor = darkTextColor
                self.darkerTextColor = darkerTextColor
            }

            required convenience init(arrayLiteral elements:  Int...) {
                let colors = elements.map { colorHex -> UIColor in
                    return UIColor.colorFromHex(colorHex)
                }
                self.init(mainColor: colors[0], pureColor: colors[1], pureTextColor: colors[2], darkTextColor: colors[3], darkerTextColor: colors[4])
            }
        }

        class FontTheme: ArrayLiteralConvertible {
            let mediumFontName: String
            let lightFontName: String
            let titleFontName: String

            required init(lightFontName: String, mediumFontName: String, titleFontName: String) {
                self.mediumFontName = mediumFontName
                self.lightFontName = lightFontName
                self.titleFontName = titleFontName
            }

            required convenience init(arrayLiteral elements: String...) {
                self.init(lightFontName: elements[0], mediumFontName: elements[1], titleFontName: elements[2])
            }
        }

        init(colors: ColorTheme, fonts: FontTheme) {
            self.colors = colors
            self.fonts = fonts
        }

        func lightFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: fonts.lightFontName, size: size)!
        }

        func mediumFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: fonts.mediumFontName, size: size)!
        }

        func titleFontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: fonts.titleFontName, size: size)!
        }
    }

    // Visit http://paletton.com/#uid=50V0u0kussnkrEHpbwgvblwC0ev for more info

    /**
    class func leftColors() -> Theme {
        return [0xe2680b, 0xffa35c, 0xff8d36, 0xab4d04, 0x733200, 0xffcba3]
    }
    class func centerColors() -> Theme {
        return [0xe2980b, 0xffc75c, 0xffba36, 0xab7204, 0x734c00]
    }
    class func rightColors() -> Theme {
        return [0xe2bb0b, 0xffe15c, 0xffda36, 0xab8d04, 0x735e00]
    }
    class func complementColors() -> Theme {
        return [0x164197, 0x5379c4, 0x325aab, 0x0e3072, 0x061e4d]
    }
    */

    class func defaultTheme() -> Theme {
        return Theme(colors: [0xff8858, 0xffffff, 0xffffff, 0xff8858, 0xa7431b], fonts: ["FreightSansProLight-Regular", "FreightSansProMedium-Regular", "FreightSansProBook-Regular"])
    }
}

extension UILabel {
    class func navigationTitleLabelWithTitle(title: String) -> UILabel {
        let titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = title
        titleLabel.textColor = Style.defaultTheme().darkTextColor
        // TODO: font
        titleLabel.font = UIFont(name: "Opificio", size: 18)
        titleLabel.sizeToFit()
        return titleLabel
    }
}

extension UIFont {
    class func aezonLightFontOfSize(size: CGFloat) -> UIFont {
        return Style.defaultTheme().lightFontWithSize(size)
    }
    class func aezonMediumFontOfSize(size: CGFloat) -> UIFont {
        return Style.defaultTheme().mediumFontWithSize(size)
    }
    class func aezonTitleFontOfSize(size: CGFloat) -> UIFont {
        return Style.defaultTheme().titleFontWithSize(size)
    }
}

extension UIColor {
    func colorAfterAddingHueWithAngle(angle: CGFloat) -> UIColor {
        let addComponent = angle / 360
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        hue += addComponent
        if hue < 0 {
            hue += 1
        }
        if hue > 1 {
            hue -= 1
        }
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    class func colorFromHex(hex: Int) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        let alpha = CGFloat(1.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
