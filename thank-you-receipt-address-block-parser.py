#!/usr/bin/env python3
"""
Extract address blocks from donation-receipt PDFs produced by Paperless-NGX.

Usage:
    python extract_addresses.py receipts.pdf [-o addresses.csv]
Requires:
    pip install pdfplumber
"""

from pathlib import Path
import csv
import re
import sys
import pdfplumber

# ⚙️  --- settings -------------------------------------------------------------
ADDRESS_RE = re.compile(
    r"""^(.+?)\n                     # line 1 – person / org name
        (\d{1,6} .+?)\n              # line 2 – street / unit (starts with digits)
        ([A-Za-z .'-]+,\s?[A-Z]{2}\s\d{5}(?:-\d{4})?)$  # line 3 – City, ST ZIP
    """,
    re.MULTILINE | re.VERBOSE,
)

# -----------------------------------------------------------------------------
def extract_blocks(pdf_path: Path):
    """Yield (name, street, city_state_zip) tuples found in *pdf_path*."""
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            text = page.extract_text() or ""
            # Paperless sometimes inserts double-spaces; normalise first
            text = re.sub(r"[ \t]{2,}", " ", text)
            for match in ADDRESS_RE.finditer(text):
                yield match.groups()
                break                     # only want the first address on a page

def main():
    if len(sys.argv) < 2:
        print("Usage: extract_addresses.py file.pdf [-o out.csv]", file=sys.stderr)
        sys.exit(1)

    pdf_file = Path(sys.argv[1]).expanduser()
    out_csv  = None
    if "-o" in sys.argv:
        out_csv = Path(sys.argv[sys.argv.index("-o") + 1]).expanduser()

    blocks = list(extract_blocks(pdf_file))

    # ── output ────────────────────────────────────────────────────────────────
    if out_csv:
        with out_csv.open("w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["Name", "Street", "CityStateZip"])
            writer.writerows(blocks)
        print(f"Wrote {len(blocks)} addresses to {out_csv}")
    else:
        for name, street, city in blocks:
            print(name)
            print(street)
            print(city)
            print("-" * 40)

if __name__ == "__main__":
    main()
