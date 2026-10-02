# Change Log

All notable changes to the "rql" extension will be documented in this file.

Check [Keep a Changelog](http://keepachangelog.com/) for recommendations on how to structure this file.

## [Unreleased]

## [0.0.6]

- Rodzaje źródeł `DECLARE`: słowa kluczowe `BINFILE`, `TEXTFILE` i `DEVICE` (retractordb #346).
- `FILE` w `DECLARE` zaraz po interwale oznaczony zakresem `invalid.deprecated`; `FILE` w `SELECT` bez zmian.
- `DEVICE` i `TEXTSOURCE` usunięte z profili pamięci (nie są profilami `STORAGE`); `TEXTSOURCE` zostaje jako typ w plikach `.desc`.
- Initial release