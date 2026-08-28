# Supported Elements

Find the focused configuration and visitor available for every parsed Markdown node.

## Overview

### Document and Blocks

| Element | Visitor |
| --- | --- |
| Document | `IDocumentVisitor` |
| Block quote | `IBlockQuoteVisitor` |
| Code block | `ICodeBlockVisitor` |
| Custom block | `ICustomBlockVisitor` |
| Heading | `IHeadingVisitor` |
| Thematic break | `IThematicBreakVisitor` |
| HTML block | `IHTMLBlockVisitor` |
| List item | `IListItemVisitor` |
| Ordered list | `IOrderedListVisitor` |
| Unordered list | `IUnorderedListVisitor` |
| Paragraph | `IParagraphVisitor` |
| Block directive | `IBlockDirectiveVisitor` |

### Inline Elements

| Element | Visitor |
| --- | --- |
| Text | `ITextVisitor` |
| Strong | `IStrongVisitor` |
| Emphasis | `IEmphasisVisitor` |
| Strikethrough | `IStrikethroughVisitor` |
| Link | `ILinkVisitor` |
| Image | `IImageVisitor` |
| Inline code | `IInlineCodeVisitor` |
| Inline HTML | `IInlineHTMLVisitor` |
| Custom inline | `ICustomInlineVisitor` |
| Line break | `ILineBreakVisitor` |
| Soft break | `ISoftBreakVisitor` |
| Symbol link | `ISymbolLinkVisitor` |
| Inline attributes | `IInlineAttributesVisitor` |

### Tables

| Element | Visitor |
| --- | --- |
| Table | `ITableVisitor` |
| Table head | `ITableHeadVisitor` |
| Table body | `ITableBodyVisitor` |
| Table row | `ITableRowVisitor` |
| Table cell | `ITableCellVisitor` |

### Doxygen

| Element | Visitor |
| --- | --- |
| Discussion | `IDoxygenDiscussionVisitor` |
| Note | `IDoxygenNoteVisitor` |
| Abstract | `IDoxygenAbstractVisitor` |
| Parameter | `IDoxygenParameterVisitor` |
| Returns | `IDoxygenReturnsVisitor` |

Every element has a matching `MarkdownDefault…Visitor`. Application-level post-processing is
available through `ICustomVisitor` after the focused visitors finish rendering.
