# RQL Code HighLight

Rozszerzenie VS Code dodające podświetlanie składni dla języka zapytań **RQL** (RetractorDB Query Language) używanego przez silnik bazy danych [RetractorDB](https://github.com/michalwidera/retractordb).

## Funkcje

Rozszerzenie obsługuje pliki `.rql` oraz `.desc` i podświetla:

| Kategoria | Przykłady |
|---|---|
| Słowa kluczowe | `SELECT`, `DECLARE`, `RULE`, `FROM`, `STREAM`, `WHEN`, `DO`, `DUMP` |
| Rodzaje źródeł `DECLARE` | `BINFILE`, `TEXTFILE`, `DEVICE`, opcja `TIMEOUT` |
| Formy przestarzałe | `FILE` w `DECLARE` zaraz po interwale oraz agregatory przyrostkowe (`s.min`, `s.max`, `s.avg`, `s.sumc`) - zakres `invalid.deprecated` |
| Dyrektywy kompilatora | `STORAGE`, `ROTATION`, `SUBSTRAT` |
| Operatory | `AND`, `OR`, `NOT`, `=`, `!=`, `<`, `<=`, `>`, `>=`, `+`, `-`, `*`, `/`, `~`, `^`, `#`, `&`, `%`, `@`, `$`, `:` |
| Typy danych | `INTEGER`, `FLOAT`, `DOUBLE`, `STRING`, `BYTE`, `CHAR`, `UINT`; dodatkowo `RATIONAL` w deskryptorach |
| Polecenia deskryptorów | `TYPE`, `REF`, `RETENTION`, `RETMEMORY` wewnątrz `{ ... }` |
| Profile pamięci | `MEMORY`, `DIRECT`, `POSIX`, `POSIXSHD`, `GENERIC` (oraz typ `TEXTSOURCE` w plikach `.desc`) |
| Agregatory | `MIN`, `MAX`, `AVG`, `SUMC` |
| Funkcje wbudowane | `Sqrt`, `Ceil`, `Floor`, `Abs`, `round`, `trunc`, `sin`, `cos`, `exp`, `tan`, `log`, `log2`, `isnull`, `null2zero`, `IsZero`, `IsNonZero`, `Length`, `to_integer`, `to_float`, `to_double`, `to_string`; skróty `int`, `float`, `real`, `str` |

Dodatkowo obsługiwane są:

- komentarze liniowe `//`; w RQL komentarzem `#` jest cały wiersz, którego pierwszym niebiałym znakiem jest `#`, a w deskryptorach `# ` może zaczynać komentarz także po poleceniu
- zagnieżdżone komentarze blokowe `/* ... */`
- napisy RQL `'...'` z podwojonym apostrofem `''` oraz ścieżki deskryptorów `REF "..."`
- liczby całkowite i tokeny zmiennoprzecinkowe, w tym `.5`, `5.` i zapis z wykładnikiem `E`; podświetlanie tokenu nie oznacza, że parser dopuszcza go w każdym miejscu
- identyfikatory zawierające `$` bez kolorowania ich fragmentów jako słów kluczowych lub liczb
- automatyczne zamykanie nawiasów `()`, `[]`, `{}`
- automatyczne zamykanie cudzysłowów `'...'`

## Wymagania

- Visual Studio Code w wersji **1.81.0** lub nowszej

## Instalacja

### Metoda 1 — z pliku `.vsix` (zalecana)

1. Pobierz plik `rql-<wersja>.vsix` z sekcji [Releases](../../releases) tego repozytorium.

2. Otwórz VS Code i przejdź do panelu rozszerzeń:
   - skrót: `Ctrl+Shift+X` (Windows/Linux) lub `Cmd+Shift+X` (macOS)

3. Kliknij ikonę `...` (menu kontekstowe) w prawym górnym rogu panelu rozszerzeń i wybierz:
   ```
   Install from VSIX...
   ```

4. Wskaż pobrany plik `.vsix` i potwierdź instalację.

5. Przeładuj okno VS Code (`Ctrl+Shift+P` → `Developer: Reload Window`).

### Metoda 2 — instalacja z linii poleceń

Jeśli masz zainstalowany interfejs `code` w PATH:

```bash
code --install-extension rql-<wersja>.vsix
```

### Metoda 3 — budowanie ze źródeł

**Wariant A — przez `vsce`** (wymaga Node.js v16+ i npm; nie działa w WSL jeśli npm pochodzi z Windows):

```bash
git clone https://github.com/michalwidera/rql-vscode.git
cd rql-vscode
npm install -g @vscode/vsce
vsce package
code --install-extension rql-*.vsix
```

**Wariant B — przez Python 3** (działa wszędzie, bez zależności):

```bash
git clone https://github.com/michalwidera/rql-vscode.git
cd rql-vscode
python3 build.py
code --install-extension rql-*.vsix
```

Skrypt `build.py` jest dołączony do repozytorium i tworzy poprawne archiwum `.vsix` bez żadnych zewnętrznych narzędzi.

### Metoda 4 — tryb deweloperski (bez pakowania)

Aby edytować i testować rozszerzenie bez budowania paczki:

1. Sklonuj repozytorium do katalogu `~/.vscode/extensions/`:
   ```bash
   git clone https://github.com/michalwidera/rql-vscode.git \
       ~/.vscode/extensions/rql-vscode
   ```

2. Przeładuj VS Code (`Ctrl+Shift+P` → `Developer: Reload Window`).

## Weryfikacja instalacji

Otwórz dowolny plik z rozszerzeniem `.rql` lub `.desc`. W prawym dolnym rogu paska stanu VS Code powinno pojawić się `RQL`. Składnia powinna być kolorowana zgodnie z kategorią tokenów.

Jeśli kolorowanie nie działa, upewnij się że wybrany motyw kolorystyczny obsługuje zakresy TextMate (`keyword`, `type`, `comment`, `string`, `constant`).

## Aktualizacja gramatyki

Gramatyka jest utrzymywana w pliku `syntaxes/rql.iro` (format [Iro](https://eeyo.io/iro/)) i synchronizowana z `RQL.g4` oraz `DESC.g4` projektu RetractorDB. Nazwy funkcji skalarnych pochodzą z `src/include/rqlFunctions.hpp`. Wygenerowany plik `syntaxes/rql.tmLanaguage` jest gotowy do użycia bez dodatkowych kroków. Deskryptory mają osobny kontekst podświetlania wewnątrz `{ ... }`.

Aby przeregenerować `tmLanguage` po zmianie `rql.iro`:

```bash
./build.sh install-iro   # instalacja gotowego wydania CLI
./build.sh compile-iro   # eksport syntaxes/rql.iro do syntaxes/rql.tmLanaguage
```

`compile-iro` szuka polecenia `iro` w `PATH`, a następnie w katalogu instalatora (`IRO_INSTALL_DIR`, domyślnie `~/.local/bin`). Sprawdza wynik kompilacji przed zastąpieniem używanej gramatyki. W razie braku CLI wskazuje polecenie instalacji.

Alternatywnie można wkleić plik do [Iro online](https://eeyo.io/iro/), wybrać eksport **TextMate** i zapisać wynik jako `syntaxes/rql.tmLanaguage`.

## Znane problemy

- Nazwa pliku gramatyki (`rql.tmLanaguage`) zawiera literówkę — zachowana dla zgodności wstecznej z `package.json`.
- Oznaczanie przestarzałego `DECLARE ... FILE` wymaga interwału i `FILE` w tym samym fizycznym wierszu.

## Historia zmian

### 0.0.7

- Dodano opcję `TIMEOUT` oraz osobny kontekst deskryptorów z `TYPE`, `REF`, `RETMEMORY` i `RATIONAL`.
- Poprawiono podświetlanie ścieżek `REF "..."`, podwojonych apostrofów i zagnieżdżonych komentarzy blokowych.
- Uzupełniono operatory i liczby, w tym `.5`, `5.` oraz tokeny z wykładnikiem `E`.
- Poprawiono komentarze `# ` w deskryptorach i identyfikatory zawierające `$`.
- Agregatory przyrostkowe oznaczono jako przestarzałe; usunięto `CACHE` i `NOCACHE` z listy słów kluczowych.
- Uaktualniono opis funkcji skalarnych i składni komentarzy.

### 0.0.6

- Dodano rodzaje źródeł `DECLARE`: `BINFILE`, `TEXTFILE` i `DEVICE` (RetractorDB #346).
- Oznaczono `FILE` w `DECLARE` zaraz po interwale zakresem `invalid.deprecated`; `FILE` w `SELECT` zachowuje dotychczasowe podświetlanie.
- Usunięto `DEVICE` i `TEXTSOURCE` z profili `STORAGE`; `TEXTSOURCE` pozostaje typem w plikach `.desc`.

### 0.0.2

- Dodano słowa kluczowe `DISPOSABLE`, `ONESHOT`, `HOLD`, `ROTATION`, `TO`, `NOT`
- Dodano funkcję `isnull`
- Usunięto tokeny nieistniejące w gramatyce (`RATIONAL`, `REF`, `RETMEMORY`)
- Poprawiono regex komentarzy — nie wymagają początku linii

### 0.0.1

- Pierwsze wydanie z podstawowym podświetlaniem składni RQL
