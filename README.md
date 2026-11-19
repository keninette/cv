# CV

My CV in two versions, built from HTML pages and exported to PDF with headless Edge (or Chrome):

| Version | Source                                | PDF                                              |
| ------- | ------------------------------------- | ------------------------------------------------ |
| Graphic | `src/index.html` and `src/components` | `build/CV-GAUTHIER-HUGENDOBLER-Delphine.pdf`     |
| ATS     | `src/ats/ats.md`                      | `build/CV-GAUTHIER-HUGENDOBLER-Delphine-ATS.pdf` |

## Graphic version

`src/index.html` includes the components (`header`, `experiences`, `know-me`), each with its own HTML and CSS file. Global styles and the A4 page layout are in `src/style.css`.

## ATS version

A plain, one-column version for Applicant Tracking Systems (no icons, images or columns, so the text is read in the right order).

- The content lives in `src/ats/ats.md`: edit this file to update the ATS CV.
- `src/ats/ats.html` renders it with [marked](https://marked.js.org/) and a few print styles.

When the content of the graphic CV changes, update `ats.md` too.

## Preview

```sh
npm install
npm run dev
```

It serves `src` with live reload. The graphic CV is at the root, the ATS CV at `/ats/ats.html`.

## Export to PDF

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\export-pdf.ps1
```

It exports both versions into `build/`, using the first browser found among the usual Edge and Chrome install paths. No server is needed. To check the result, open the PDFs in `build/`.

## Formatting

```sh
npx prettier . --check
```
