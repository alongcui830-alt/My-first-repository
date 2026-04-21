---
name: pdf-reader
description: Extract text and metadata from PDF files using pdfjs-dist (Node.js). Use when user wants to read, analyze, or get info about a PDF file.
metadata:
  openclaw:
    emoji: "📄"
    requires:
      bins: ["node"]
---

# PDF Reader Skill

Extract text and retrieve metadata from PDF files using pdfjs-dist.

## When to Use

✅ **USE this skill when:**

- "Read this PDF" / "What's in this PDF?"
- "Extract text from this PDF"
- "Get metadata about this PDF"
- "Summarize this PDF document"
- Any task involving reading PDF content

❌ **DON'T use this skill when:**

- Creating or editing PDFs
- Scanned images (no OCR capability)
- Password-protected PDFs (will return error)

## Commands

### Extract Text

Extracts plain text from the specified PDF file.

```bash
node skills/pdf-reader/reader.mjs extract /path/to/document.pdf
node skills/pdf-reader/reader.mjs extract /path/to/document.pdf --max_pages 5
```

**Parameters:**

- `file_path` (string, required): Path to the PDF file
- `--max_pages` (integer, optional): Maximum number of pages to extract

**Output:** Plain text content from the PDF.

### Get Metadata

Retrieve metadata about the document.

```bash
node skills/pdf-reader/reader.mjs metadata /path/to/document.pdf
```

**Output:** JSON object with PDF metadata including:

- `title`: Document title
- `author`: Document author
- `subject`: Document subject
- `creator`: Application that created the PDF
- `producer`: PDF producer
- `creationDate`: Creation date
- `modDate`: Modification date
- `format`: PDF format version
- `pages`: Total page count

## Error Handling

- Returns error message if file not found or not a valid PDF
- Returns error if PDF is encrypted and requires password
- Gracefully handles corrupted or malformed PDFs

## Implementation Notes

- Uses pdfjs-dist (bundled with OpenClaw) — no extra dependencies needed
- Extracts text layer only (no OCR for scanned documents)
- Handles large PDFs with the `--max_pages` option
