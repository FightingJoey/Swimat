import Foundation

enum IndentType: Character {
    case parentheses = "(", square = "[", curly = "{"

    func stopSymbol() -> Character {
        switch self {
        case .parentheses:
            return ")"
        case .square:
            return "]"
        case .curly:
            return "}"
        }
    }

}

class Indent {
    static var char: String = ""
    static var size: Int = 0
    static var paraAlign = true
    var count: Int // general indent count
    var extra: Int // from extra indent
    var indentAdd: Bool // same line flag, if same line add only one indent
    var extraAdd: Bool
    var isLeading: Bool
    var leading: Int // leading for smart align
    var inSwitch: Bool // is in switch block
    var inCase: Bool // is case statement
    var block: IndentType

    init() {
        count = 0
        extra = 0
        indentAdd = false
        extraAdd = false
        isLeading = false
        leading = 0
        inSwitch = false
        inCase = false
        block = .curly
    }

    init(with indent: Indent, offset: Int, type: IndentType?) {
        self.block = type ?? .curly
        self.count = indent.count
        self.extra = indent.extra
        self.isLeading = indent.isLeading
        self.inSwitch = false
        self.inCase = false

        if (block != .parentheses || !Indent.paraAlign) && !indent.indentAdd {
            self.count += 1
            self.indentAdd = true
        } else if indent.indentAdd {
            self.indentAdd = true
            if indent.count > 0 {
                indent.count -= 1
            }
        } else {
            self.indentAdd = false
        }
        if !indent.extraAdd {
//            if block != .curly {
            self.count += indent.extra
//            }
            self.extraAdd = true
        } else {
            self.extraAdd = false
        }

        switch block {
        case .curly:
            self.leading = indent.leading
        case .parentheses:
            self.leading = max(offset - count * Indent.size - 1, 0)
        case .square:
            self.leading = indent.leading
        }
        if !Indent.paraAlign {
            self.leading = 0
        }
    }

}
