# windows-clipboard-sanitiser
Strip invisible Unicode, normalise text, optionally fix smart quotes.

# Clipboard Sanitiser (PowerShell)

A small background script that watches your clipboard and strips the invisible rubbish that breaks paste, formatting, and tooling.

Author: TABARC-Code  
Plugin URI: https://github.com/TABARC-Code/

## What this does

Every `IntervalMs` it:

- Reads clipboard text
- Removes zero-width and direction control characters (common in copy/paste from web pages, PDFs, chat apps)
- normalises line endings to Windows CRLF
- Optionally fixes “smart quotes” and ellipsis into plain ASCII characters
- Writes the cleaned text back to the clipboard only if it changed

It runs forever until you stop it.

## Why you want it

Because you paste something that looks normal, then:
- a terminal command breaks
- A JSON file refuses to parse
- A username/password field rejects the input
- Yyour editor shows “nothing” but the diff does

Invisible Unicode control characters are the quiet kind of annoying.

## Script location

In your toolbox repo this is:

`scripts/03-Clipboard-Sanitiser.ps1`

It imports:

`src/Tabarc.Toolbox.psm1`

## Usage

Basic run:

```powershell
.\scripts\03-Clipboard-Sanitiser.ps1
Run with quote fixing:

powershell
Copy code
.\scripts\03-Clipboard-Sanitiser.ps1 -FixQuotes
Change polling interval (milliseconds):

powershell
Copy code
.\scripts\03-Clipboard-Sanitiser.ps1 -IntervalMs 100
Stop it with Ctrl + C.

Parameters
-FixQuotes
Also converts:

curly single quotes (U+2018, U+2019) to '

curly double quotes (U+201C, U+201D) to "

ellipsis (U+2026) to ...

-IntervalMs (default 300)
How often to check the clipboard. Lower is more responsive, higher is quieter.

What it removes
This line is the main hit squad:

powershell
Copy code
$s = $s -replace '[\u200B-\u200F\u202A-\u202E\u2066-\u2069]', ''
That range includes:

zero-width space and friends

direction overrides (LTR/RTL embedding characters)

isolate markers used by some apps and sites

These characters are often harmless visually and disastrous structurally.

Logging
When it modifies the clipboard it calls:

Write-TbLog "Sanitised clipboard"

Default log path from the module:
logs/toolbox.log

If you are not seeing logs, check the module import path and ensure the repo structure is intact.

Known limitations
Only works on text clipboard content. If you copy an image or file list, it ignores it.

Some apps place non-text formats on the clipboard first. The GetText() call may not reflect what you expect in those moments.

It does not attempt to preserve rich text formatting. This is deliberate. i get fed up of arguments of this. its as is.

## Security note
This script reads clipboard contents repeatedly.
If you copy sensitive material (passwords, tokens), do not run this unless you accept that risk. yOU MESS UP YOUR FAULT.

It does not transmit anything, but “local only” is not the same as “risk free”.
