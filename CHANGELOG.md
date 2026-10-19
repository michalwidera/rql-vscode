# Change Log

All notable changes to the "rql" extension will be documented in this file.

Check [Keep a Changelog](http://keepachangelog.com/) for recommendations on how to structure this file.

## [Unreleased]

## [0.0.9]

- Dodano slowo kluczowe `LET`/`let` i stale nazwane RetractorDB #440: nazwa w deklaracji `LET NAZWA = wartosc` oraz odwolanie `?NAZWA` maja zakres `variable.other.constant.rql`.
- Samotne `?`, `?` ze spacja przed nazwa oraz `?` z nazwa niedozwolona w RQL (z `$` albo zaczynajaca sie od cyfry) maja zakres `invalid.illegal.rql`; `?` w napisie i komentarzu pozostaje napisem lub komentarzem.

## [0.0.8]

- Wydzielono `AND`, `OR` i `NOT` do zakresu `keyword.operator.logical.rql`, aby umozliwic osobny kolor operatorow logicznych.

## [0.0.7]

- Dodano `TIMEOUT` i osobny kontekst deskryptorow z `TYPE`, `REF`, `RETMEMORY` oraz `RATIONAL`.
- Poprawiono podswietlanie sciezek `REF "..."`, podwojonych apostrofow i zagniezdzonych komentarzy blokowych.
- Uzupelniono operatory i liczby, w tym `.5`, `5.` oraz tokeny z wykladnikiem `E`.
- Poprawiono komentarze `# ` w deskryptorach i identyfikatory zawierajace `$`.
- Agregatory przyrostkowe oznaczono jako przestarzale; usunieto `CACHE` i `NOCACHE` z listy slow kluczowych.
- Uaktualniono opis funkcji skalarnych i skladni komentarzy w README.

## [0.0.6]

- Rodzaje źródeł `DECLARE`: słowa kluczowe `BINFILE`, `TEXTFILE` i `DEVICE` (retractordb #346).
- `FILE` w `DECLARE` zaraz po interwale oznaczony zakresem `invalid.deprecated`; `FILE` w `SELECT` bez zmian.
- `DEVICE` i `TEXTSOURCE` usunięte z profili pamięci (nie są profilami `STORAGE`); `TEXTSOURCE` zostaje jako typ w plikach `.desc`.
- Initial release
