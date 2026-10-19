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
| Stałe nazwane | `LET` jako słowo kluczowe; nazwa w deklaracji `LET NAZWA = wartość` i odwołanie `?NAZWA` - zakres `variable.other.constant.rql` |
| Błędne odwołania do stałej | samotne `?`, `? NAZWA` ze spacją, `?A$B`, `?1` - zakres `invalid.illegal.rql` |
| Operatory logiczne | `AND`, `OR`, `NOT` - osobny zakres `keyword.operator.logical.rql` |
| Pozostałe operatory | `=`, `!=`, `<`, `<=`, `>`, `>=`, `+`, `-`, `*`, `/`, `~`, `^`, `#`, `&`, `%`, `@`, `$`, `:` |
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
- odwołania do stałych w każdym miejscu, np. `src@(?STEP, ?WIDTH)`, `src[?LAST-$]`, `-?OFFSET`; `?` wewnątrz napisu lub komentarza pozostaje częścią napisu lub komentarza
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

## Kolory w jasnym i ciemnym motywie

Od wersji **0.0.8** operatory logiczne `AND`, `OR` i `NOT` mają osobny zakres TextMate. Można dzięki temu nadać im kolor różny od poleceń i typów danych. Napisy w apostrofach oraz ścieżki deskryptorów w cudzysłowach także mają własne zakresy. Od wersji **0.0.9** osobny zakres mają również stałe nazwane `LET` i `?NAZWA`.

Gramatyka klasyfikuje tokeny, a konkretne kolory wybiera motyw lub ustawienia VS Code. Wartości `color` w `rql.iro` nie ustawiają kolorów w VS Code. Poniższa paleta wymaga dodania konfiguracji do `settings.json`; instalacja rozszerzenia sama jej nie włącza.

| Kategoria | Zakres TextMate | Jasny motyw | Ciemny motyw |
|---|---|---|---|
| Polecenia, np. `SELECT`, `DECLARE` | `keyword.rql` | `#A31515` - ciemnoczerwony | `#F48771` - jasnoczerwony |
| Typy, np. `INTEGER`, `BYTE`, `STRING` | `storage.type.rql` | `#006B75` - ciemny turkus | `#4EC9B0` - jasny turkus |
| Operatory logiczne `AND`, `OR`, `NOT` | `keyword.operator.logical.rql` | `#795E00` - ochra | `#DCDCAA` - jasnożółty |
| Napisy `'...'` oraz ścieżki `REF "..."` | `string.quoted.single.rql`, `string.quoted.double.rql` | `#7A3E9D` - ciemnofioletowy | `#CE9FF2` - jasnofioletowy |
| Stałe nazwane: nazwa po `LET` i `?NAZWA` | `variable.other.constant.rql` | `#0451A5` - ciemnoniebieski | `#4FC1FF` - jasnoniebieski |

Paletę sprawdzono dla `Light 2026`, `Dark 2026`, `Light Modern`, `Dark Modern`, `Light+` i `Dark+`. Kontrast wszystkich pięciu kategorii względem tła edytora tych motywów przekracza 6:1. Ciemny turkus w jasnym motywie zastępuje jaskrawy `#33FFFF`, który jest słabo widoczny na białym tle.

Otwórz **Preferences: Open User Settings (JSON)** i dodaj poniższą konfigurację. W WSL można użyć **Preferences: Open Remote Settings (JSON)**. Jeśli `editor.tokenColorCustomizations` już istnieje, połącz wpisy z obecną konfiguracją.

```json
{
  "editor.tokenColorCustomizations": {
    "[*Light*][*light*]": {
      "textMateRules": [
        {
          "scope": "keyword.rql",
          "settings": { "foreground": "#A31515" }
        },
        {
          "scope": "storage.type.rql",
          "settings": { "foreground": "#006B75" }
        },
        {
          "scope": "keyword.operator.logical.rql",
          "settings": { "foreground": "#795E00" }
        },
        {
          "scope": ["string.quoted.single.rql", "string.quoted.double.rql"],
          "settings": { "foreground": "#7A3E9D" }
        },
        {
          "scope": "variable.other.constant.rql",
          "settings": { "foreground": "#0451A5" }
        }
      ]
    },
    "[*Dark*][*dark*][Monokai][Monokai Dimmed][Abyss][Red][Tomorrow Night Blue][Default High Contrast]": {
      "textMateRules": [
        {
          "scope": "keyword.rql",
          "settings": { "foreground": "#F48771" }
        },
        {
          "scope": "storage.type.rql",
          "settings": { "foreground": "#4EC9B0" }
        },
        {
          "scope": "keyword.operator.logical.rql",
          "settings": { "foreground": "#DCDCAA" }
        },
        {
          "scope": ["string.quoted.single.rql", "string.quoted.double.rql"],
          "settings": { "foreground": "#CE9FF2" }
        },
        {
          "scope": "variable.other.constant.rql",
          "settings": { "foreground": "#4FC1FF" }
        }
      ]
    }
  }
}
```

Reguły wybierają paletę według nazwy motywu: `Light` lub `light` dla jasnej i `Dark` lub `dark` dla ciemnej. Dodatkowo wymieniono kilka ciemnych motywów bez tych słów w nazwie. Motywy niepasujące do żadnego wpisu zachowują własną paletę; aby zastosować powyższe kolory, dopisz ich nazwę w odpowiedniej grupie. Kolory zmieniają się wraz z wyborem pasującego motywu, bez ponownego budowania rozszerzenia. Szczegóły opisuje [dokumentacja konfiguracji motywów VS Code](https://code.visualstudio.com/docs/configure/themes#_editor-syntax-highlighting).

Zakres `invalid.illegal.rql` dla błędnych odwołań `?` koloruje sam motyw - większość motywów wyróżnia go bez dodatkowej konfiguracji.

Kolorowanie napisów, np. `'dane.txt'`, dotyczy literałów tekstowych. Nazwy pól zadeklarowanych jako `STRING` nadal mają zakres `variable.other.rql`, tak jak pozostałe identyfikatory. Rozróżnianie ich według typu wymagałoby dodania analizy semantycznej do rozszerzenia.

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
- Nazwa stałej po `LET` jest oznaczana tylko wtedy, gdy stoi w tym samym fizycznym wierszu co `LET`. Rozszerzenie nie sprawdza, czy stała `?NAZWA` została zadeklarowana - robi to dopiero parser RetractorDB.

## Historia zmian

### 0.0.9

- Dodano słowo kluczowe `LET`/`let` oraz zakres `variable.other.constant.rql` dla nazwy w deklaracji `LET NAZWA = wartość` i odwołań `?NAZWA` (RetractorDB #440).
- Błędne odwołania (`?` samotne, ze spacją, z `$` w nazwie lub z cyfrą na początku) oznaczono zakresem `invalid.illegal.rql`.
- Dodano kolory stałych nazwanych do palety jasnego i ciemnego motywu.

### 0.0.8

- Wydzielono `AND`, `OR` i `NOT` do zakresu `keyword.operator.logical.rql`.
- Opisano konfigurację osobnych kolorów poleceń, typów, operatorów logicznych i napisów dla jasnych oraz ciemnych motywów.

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
