//
//  HTMLParser.swift
//  Santa Barbara Bus
//
//  Created by Bjarte Sjursen on 29/10/16.
//  Copyright © 2016 Bjarte Sjursen. All rights reserved.
//

//Responsibility: 
//Given a html document, this class should be good at
//Searching the document and parsing relevant DOM objects

import Foundation

enum HTMLTag : String {
    case a = "a"
    case abbr = "abbr"
    case acronym = "acronym"
    case address = "address"
    case applet = "applet"
    case area = "area"
    case article = "article"
    case aside = "aside"
    case audio = "audio"
    case b = "b"
    case base = "base"
    case basefont = "basefont"
    case bdi = "bdi"
    case bdo = "bdo"
    case big = "big"
    case blockquote = "blockquote"
    case body = "body"
    case br = "br"
    case button = "button"
    case canvas = "canvas"
    case caption = "caption"
    case center = "center"
    case cite = "cite"
    case code = "code"
    case col = "col"
    case colgroup = "colgroup"
    case datalist = "datalist"
    case dd = "dd"
    case del = "del"
    case details = "details"
    case dfn = "dfn"
    case dialog = "dialog"
    case dir = "dir"
    case div = "div"
    case dl = "dl"
    case dt = "dt"
    case em = "em"
    case embed = "embed"
    case fieldset = "fieldset"
    case figcaption = "figcaption"
    case figure = "figure"
    case font = "font"
    case footer = "footer"
    case form = "form"
    case frame = "frame"
    case frameset = "frameset"
    case h1 = "h1"
    case h2 = "h2"
    case h3 = "h3"
    case h4 = "h4"
    case h5 = "h5"
    case h6 = "h6"
    case head = "head"
    case header = "header"
    case hr = "hr"
    case html = "html"
    case i = "i"
    case iframe = "iframe"
    case img = "img"
    case input = "input"
    case ins = "ins"
    case kbd = "kbd"
    case keygen = "keygen"
    case label = "label"
    case legend = "legend"
    case li = "li"
    case link = "link"
    case main = "main"
    case map = "map"
    case mark = "mark"
    case menu = "menu"
    case menuitem = "menuitem"
    case meta = "meta"
    case meter = "meter"
    case nav = "nav"
    case noframes = "noframes"
    case noscript = "noscript"
    case object = "object"
    case ol = "ol"
    case optgroup = "optgroup"
    case option = "option"
    case output = "output"
    case p = "p"
    case param = "param"
    case pre = "pre"
    case progress = "progress"
    case q = "q"
    case rp = "rp"
    case rt = "rt"
    case ruby = "ruby"
    case s = "s"
    case samp = "samp"
    case script = "script"
    case section = "section"
    case select = "select"
    case small = "small"
    case source = "source"
    case span = "span"
    case strike = "strike"
    case strong = "strong"
    case style = "style"
    case sub = "sub"
    case summary = "summary"
    case sup = "sup"
    case table = "table"
    case tbody = "tbody"
    case td = "td"
    case textarea = "textarea"
    case tfoot = "tfoot"
    case th = "th"
    case thead = "thead"
    case time = "time"
    case title = "title"
    case tr = "tr"
    case track = "track"
    case tt = "tt"
    case u = "u"
    case ul = "ul"
    case hvar = "var"
    case video = "video"
    case wbr = "wbr"
}
enum FileType{
    case js
    case css
    case html
}

class HTML {
    
    //Properties
    public var document = Array<String>()
    
    //Initializers
    public init(rawDocument : String){
        rawDocument.enumerateLines(invoking: {
            line, inOut in
            self.document.append(line)
        })
    }
    
    public init(document : [String]){
        self.document = document
    }
    
    //Functions
    
    public func findByTag(tag : HTMLTag) -> [String] {
        return [""]
    }
    
    public func findByClass(htmlClass : String) -> [String]{
        return [""]
    }
    
    public func findById(id : String) -> [String]{
        return [""]
    }
    
    public func findByType(fileType : FileType)-> [String]{
        return [""]
    }
    
    //Seem to fail at elements stretching over multiple lines
    public func parse(tag : HTMLTag) -> [HTML] {
        
        var openingTagLineIndeces = Array<Int>()
        var closingTagLineIndeces = Array<Int>()
        let closingTag = "</\(tag.rawValue)>"
        let openingTag = "<\(tag.rawValue)"
        
        //Find all relevant line indeces containing the tag of interest
        for i in 0..<document.count {
            if document[i].contains(openingTag) {
                openingTagLineIndeces.append(i)
            }
            if document[i].contains(closingTag) {
                closingTagLineIndeces.append(i)
            }
        }
        
        var HTMLSnippets = Array<HTML>()
        
        //Group together relevant HTML
        while !closingTagLineIndeces.isEmpty {
            
            //Take front element of closing tag
            let frontClosingTagLineIndex = closingTagLineIndeces.removeFirst()
            
            //Init this to a guaranteed valid value
            var nearestPrecedingOpeningTagLineIndex = openingTagLineIndeces.first
            var openingTagLineIndexToRemove = 0
            //Set value high so it starts in a valid state
            var indexDifference = 100000
            
            //Find the preceding opening tag line element that is nearest
            for i in 0..<openingTagLineIndeces.count {
                //If the opening tag line index size exceeds the closing tag line index, then remove the previous element and end search
                if openingTagLineIndeces[i] > frontClosingTagLineIndex {
                    break
                }
                else if (frontClosingTagLineIndex - openingTagLineIndeces[i]) <= indexDifference && !isClosingTagEvidentBetween(openingTagIndex: openingTagLineIndeces[i], and: frontClosingTagLineIndex, closingTagIndeces: closingTagLineIndeces) {
                    indexDifference = frontClosingTagLineIndex - openingTagLineIndeces[i]
                    nearestPrecedingOpeningTagLineIndex = openingTagLineIndeces[i]
                    openingTagLineIndexToRemove = i
                }
            }
            
            //Remove nearest preceding opening tag
            openingTagLineIndeces.remove(at: openingTagLineIndexToRemove)
            
            var linesInHTMLSnippet = Array<String>()
            //Make an html snippet
            if nearestPrecedingOpeningTagLineIndex != nil {
                for i in nearestPrecedingOpeningTagLineIndex!...frontClosingTagLineIndex {
                    let line = document[i].trimmingCharacters(in: .whitespaces)
                    linesInHTMLSnippet.append(line)
                }
            }
            else {
                print("nearestPrecedingOpeningTagLineIndex was nil")
                fatalError()
            }
            
            let HTMLSnippet = HTML(document: linesInHTMLSnippet)
            
            HTMLSnippets.append(HTMLSnippet)
        }
        
        
        var trimmedHTMLSnippets = Array<HTML>()
        for HTMLSnippet in HTMLSnippets {
            var multiLineHTMLElement = Array<String>()
            var i = 0
            for line in HTMLSnippet.document {
                i += 1
                //Check if HTML element is a one liner
                if line.contains(closingTag) && line.contains(openingTag) {
                    for line in line.components(separatedBy: openingTag) {
                        if line.contains(closingTag) {
                            let relevantLinePart = "<\(tag.rawValue)\(line)"
                            let backTrimmedRelevantLinePart = relevantLinePart.components(separatedBy: closingTag)[0]
                            trimmedHTMLSnippets.append(HTML(rawDocument: "\(backTrimmedRelevantLinePart)\(closingTag)"))
                        }
                    }
                }
                //It is not a one liner
                else {
                    if line.contains(openingTag){
                        let relevantLinePart = "<\(tag.rawValue)\(line.components(separatedBy: openingTag)[1])"
                        multiLineHTMLElement.append(relevantLinePart)
                    }
                    else if line.contains(closingTag) && HTMLSnippet.document.count == i {
                        let backTrimmedRelevantLinePart = line.components(separatedBy: closingTag)[0]
                        multiLineHTMLElement.append("\(backTrimmedRelevantLinePart)\(closingTag)")
                        trimmedHTMLSnippets.append(HTML(document: multiLineHTMLElement))
                        multiLineHTMLElement.removeAll()
                    }
                    else {
                        multiLineHTMLElement.append(line)
                    }
                }
            }
        }

        
        return trimmedHTMLSnippets
    }
    
    private func isClosingTagEvidentBetween(openingTagIndex : Int, and currentClosingTagIndex : Int, closingTagIndeces : [Int]) -> Bool {
        for closingTagIndex in closingTagIndeces {
            if closingTagIndex > currentClosingTagIndex && closingTagIndex < openingTagIndex {
                return true
            }
        }
        return false
    }

}
