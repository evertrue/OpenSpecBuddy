//
//  MarkdownView.swift
//  OpenSpecBuddy
//

import SwiftUI
import Markdown
import OSLog

struct MarkdownView: View {
    let content: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                MarkdownContent(content: content)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct MarkdownContent: View {
    let content: String

    var body: some View {
        let _ = Logger.parsing.debug("Parsing markdown content (\(content.count) characters)")
        let document = Document(parsing: content)
        MarkdownBlockSequence(blocks: Array(document.blockChildren))
    }
}

struct MarkdownBlockSequence: View {
    let blocks: [BlockMarkup]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                MarkdownBlockView(block: block)
            }
        }
    }
}

struct MarkdownBlockView: View {
    let block: any BlockMarkup

    var body: some View {
        switch block {
        case let heading as Heading:
            HeadingView(heading: heading)

        case let paragraph as Paragraph:
            ParagraphView(paragraph: paragraph)

        case let codeBlock as CodeBlock:
            CodeBlockView(codeBlock: codeBlock)

        case let list as UnorderedList:
            UnorderedListView(list: list)

        case let list as OrderedList:
            OrderedListView(list: list)

        case let blockquote as BlockQuote:
            BlockQuoteView(blockquote: blockquote)

        case _ as ThematicBreak:
            Divider()
                .padding(.vertical, 8)

        default:
            Text(block.format())
                .font(.body)
        }
    }
}

struct HeadingView: View {
    let heading: Heading

    var body: some View {
        Text(renderInlineMarkup(heading.inlineChildren))
            .font(fontForLevel(heading.level))
            .fontWeight(.bold)
            .padding(.top, heading.level == 1 ? 8 : 4)
    }

    private func fontForLevel(_ level: Int) -> Font {
        switch level {
        case 1: return .title
        case 2: return .title2
        case 3: return .title3
        default: return .headline
        }
    }
}

struct ParagraphView: View {
    let paragraph: Paragraph

    var body: some View {
        Text(renderInlineMarkup(paragraph.inlineChildren))
            .font(.body)
    }
}

struct CodeBlockView: View {
    let codeBlock: CodeBlock

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            Text(codeBlock.code)
                .font(.system(.body, design: .monospaced))
                .textSelection(.enabled)
                .padding(12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .textBackgroundColor).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        )
    }
}

struct UnorderedListView: View {
    let list: UnorderedList

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(Array(list.listItems.enumerated()), id: \.offset) { _, item in
                ListItemView(item: item, bullet: "\u{2022}")
            }
        }
        .padding(.leading, 16)
    }
}

struct OrderedListView: View {
    let list: OrderedList

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(Array(list.listItems.enumerated()), id: \.offset) { index, item in
                ListItemView(item: item, bullet: "\(index + 1).")
            }
        }
        .padding(.leading, 16)
    }
}

struct ListItemView: View {
    let item: ListItem
    let bullet: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if let checkbox = item.checkbox {
                Image(systemName: checkbox == .checked ? "checkmark.square.fill" : "square")
                    .foregroundStyle(checkbox == .checked ? .green : .secondary)
            } else {
                Text(bullet)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(item.children.enumerated()), id: \.offset) { _, child in
                    if let paragraph = child as? Paragraph {
                        Text(renderInlineMarkup(paragraph.inlineChildren))
                    } else if let nestedList = child as? UnorderedList {
                        UnorderedListView(list: nestedList)
                    } else if let nestedList = child as? OrderedList {
                        OrderedListView(list: nestedList)
                    }
                }
            }
        }
    }
}

struct BlockQuoteView: View {
    let blockquote: BlockQuote

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.secondary.opacity(0.5))
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(blockquote.children.enumerated()), id: \.offset) { _, child in
                    if let paragraph = child as? Paragraph {
                        Text(renderInlineMarkup(paragraph.inlineChildren))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.leading, 12)
        }
        .padding(.vertical, 4)
    }
}

private func renderInlineMarkup(_ children: some Sequence<InlineMarkup>) -> AttributedString {
    var result = AttributedString()

    for child in children {
        switch child {
        case let text as Markdown.Text:
            result += AttributedString(text.string)

        case let strong as Strong:
            var strongText = renderInlineMarkup(strong.inlineChildren)
            strongText.font = .body.bold()
            result += strongText

        case let emphasis as Emphasis:
            var emphasisText = renderInlineMarkup(emphasis.inlineChildren)
            emphasisText.font = .body.italic()
            result += emphasisText

        case let code as InlineCode:
            var codeText = AttributedString(code.code)
            codeText.font = .system(.body, design: .monospaced)
            codeText.backgroundColor = Color(nsColor: .textBackgroundColor).opacity(0.5)
            result += codeText

        case let link as Markdown.Link:
            var linkText = renderInlineMarkup(link.inlineChildren)
            if let destination = link.destination, let url = URL(string: destination) {
                linkText.link = url
                linkText.foregroundColor = .blue
            }
            result += linkText

        case _ as SoftBreak:
            result += AttributedString(" ")

        case _ as LineBreak:
            result += AttributedString("\n")

        default:
            result += AttributedString(child.format())
        }
    }

    return result
}
