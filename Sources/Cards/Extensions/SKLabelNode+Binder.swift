import Foundation
import SpriteKit
import RxSwift
import RxCocoa

extension Reactive where Base: SKLabelNode {


    public var blendMode: Binder<SKBlendMode> {
        return Binder(self.base) { view, blendMode in
            view.blendMode = blendMode
        }
    }



    public var colorBlendFactor: Binder<CGFloat> {
        return Binder(self.base) { view, colorBlendFactor in
            view.colorBlendFactor = colorBlendFactor
        }
    }



    public var fontName: Binder<String?> {
        return Binder(self.base) { view, fontName in
            view.fontName = fontName
        }
    }

    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) { view, fontSize in
            view.fontSize = fontSize
        }
    }

    public var horizontalAlignmentMode: Binder<SKLabelHorizontalAlignmentMode> {
        return Binder(self.base) { view, horizontalAlignmentMode in
            view.horizontalAlignmentMode = horizontalAlignmentMode
        }
    }

    public var text: Binder<String?> {
        return Binder(self.base) { view, text in
            view.text = text
        }
    }

    public var verticalAlignmentMode: Binder<SKLabelVerticalAlignmentMode> {
        return Binder(self.base) { view, verticalAlignmentMode in
            view.verticalAlignmentMode = verticalAlignmentMode
        }
    }

}
