# RQL Code HighLight

Rozszerzenie VS Code dodające podświetlanie składni dla języka zapytań **RQL** (RetractorDB Query Language) używanego przez silnik bazy danych [RetractorDB](https://github.com/michalwidera/retractordb).

## Funkcje

Rozszerzenie obsługuje pliki `.rql` oraz `.desc` i podświetla:

| Kategoria | Przykłady |
|---|---|
| Słowa kluczowe | `SELECT`, `DECLARE`, `RULE`, `FROM`, `STREAM`, `WHEN`, `DO`, `DUMP` |
| Dyrektywy kompilatora | `STORAGE`, `ROTATION`, `SUBSTRAT` |
| Operatory logiczne | `AND`, `OR`, `NOT` |
| Typy danych | `INTEGER`, `FLOAT`, `DOUBLE`, `STRING`, `BYTE`, `CHAR`, `UINT` |
| Profile pamięci | `MEMORY`, `DIRECT`, `POSIX`, `POSIXSHD`, `DEVICE`, `TEXTSOURCE` |
| Agregatory | `MIN`, `MAX`, `AVG`, `SUMC` |
| Funkcje wbudowane | `Sqrt`, `Ceil`, `Abs`, `ToNumber`, `FloatCast`, `to_integer`, `isnull`, ... |

Dodatkowo obsługiwane są:

- komentarze liniowe `//` i hashowe `# ` (wymagana spacja po `#`)
- komentarze blokowe `/* ... */`
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

Gramatyka jest utrzymywana w pliku `syntaxes/rql.iro` (format [Iro](https://eeyo.io/iro/)) i synchronizowana z `RQL.g4` projektu RetractorDB. Wygenerowany plik `syntaxes/rql.tmLanaguage` jest gotowy do użycia bez dodatkowych kroków.

Aby przeregenerować `tmLanguage` po zmianie `rql.iro`:

1. Otwórz [https://eeyo.io/iro/](https://eeyo.io/iro/) i wklej zawartość `syntaxes/rql.iro`.
2. W sekcji eksportu wybierz **TextMate** i skopiuj wynik do `syntaxes/rql.tmLanaguage`.

## Znane problemy

- Nazwa pliku gramatyki (`rql.tmLanaguage`) zawiera literówkę — zachowana dla zgodności wstecznej z `package.json`.

## Historia zmian

### 0.0.2

- Dodano słowa kluczowe `DISPOSABLE`, `ONESHOT`, `HOLD`, `ROTATION`, `TO`, `NOT`
- Dodano funkcję `isnull`
- Usunięto tokeny nieistniejące w gramatyce (`RATIONAL`, `REF`, `RETMEMORY`)
- Poprawiono regex komentarzy — nie wymagają początku linii

### 0.0.1

- Pierwsze wydanie z podstawowym podświetlaniem składni RQL
