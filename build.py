#!/usr/bin/env python3
"""Build rql-vscode extension as a .vsix package without external tools."""

import json
import os
import zipfile

with open("package.json") as f:
    pkg = json.load(f)

name = pkg["name"]
version = pkg["version"]
display_name = pkg["displayName"]
description = pkg["description"]
engine = pkg["engines"]["vscode"]
out = f"{name}-{version}.vsix"

manifest = f"""<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011" xmlns:d="http://schemas.microsoft.com/developer/vsx-schema-design/2011">
  <Metadata>
    <Identity Language="en-US" Id="{name}" Version="{version}" Publisher="undefined" />
    <DisplayName>{display_name}</DisplayName>
    <Description xml:space="preserve">{description}</Description>
    <Tags>{name},__ext_rql,__ext_desc</Tags>
    <Categories>Programming Languages</Categories>
    <GalleryFlags>Public</GalleryFlags>
    <Properties>
      <Property Id="Microsoft.VisualStudio.Code.Engine" Value="{engine}" />
      <Property Id="Microsoft.VisualStudio.Code.ExtensionDependencies" Value="" />
      <Property Id="Microsoft.VisualStudio.Code.ExtensionPack" Value="" />
      <Property Id="Microsoft.VisualStudio.Code.ExtensionKind" Value="ui,workspace" />
      <Property Id="Microsoft.VisualStudio.Code.LocalizedLanguages" Value="" />
      <Property Id="Microsoft.VisualStudio.Services.GitHubFlavoredMarkdown" Value="true" />
    </Properties>
  </Metadata>
  <Installation>
    <InstallationTarget Id="Microsoft.VisualStudio.Code"/>
  </Installation>
  <Dependencies/>
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Code.Manifest"            Path="extension/package.json"    Addressable="true" />
    <Asset Type="Microsoft.VisualStudio.Services.Content.Details" Path="extension/README.md"        Addressable="true" />
    <Asset Type="Microsoft.VisualStudio.Services.Content.Changelog" Path="extension/CHANGELOG.md"  Addressable="true" />
  </Assets>
</PackageManifest>"""

content_types = """<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension=".vsixmanifest" ContentType="text/xml" />
  <Default Extension=".json"         ContentType="application/json" />
  <Default Extension=".md"           ContentType="text/markdown" />
  <Default Extension=".tmLanguage"   ContentType="text/xml" />
  <Default Extension=".tmLanaguage"  ContentType="text/xml" />
  <Default Extension=".xml"          ContentType="text/xml" />
</Types>"""

files_to_include = [
    ("package.json",                    "extension/package.json"),
    ("README.md",                       "extension/README.md"),
    ("CHANGELOG.md",                    "extension/CHANGELOG.md"),
    ("language-configuration.json",     "extension/language-configuration.json"),
    ("syntaxes/rql.tmLanaguage",        "extension/syntaxes/rql.tmLanaguage"),
]

with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    z.writestr("extension.vsixmanifest", manifest)
    z.writestr("[Content_Types].xml", content_types)
    for src, dst in files_to_include:
        if os.path.exists(src):
            z.write(src, dst)
            print(f"  + {dst}")
        else:
            print(f"  MISSING: {src}")

print(f"\nZbudowano: {out} ({os.path.getsize(out)} bajtów)")
