# TABARC-Code
param(
  [switch]$FixQuotes,
  [int]$IntervalMs = 300
)

Add-Type -AssemblyName System.Windows.Forms

function Clean([string]$s) {
  if ($null -eq $s) { return $null }
  $s = $s -replace '[\u200B-\u200F\u202A-\u202E\u2066-\u2069]', ''
  $s = $s -replace "`r`n|`r|`n", "`r`n"
  if ($FixQuotes) {
    $s = $s -replace '[\u2018\u2019]', "'"
    $s = $s -replace '[\u201C\u201D]', '"'
    $s = $s -replace '\u2026', '...'
  }
  $s
}

$last = ""
while ($true) {
  Start-Sleep -Milliseconds $IntervalMs
  try { $t = [System.Windows.Forms.Clipboard]::GetText() } catch { continue }
  if ($t -and $t -ne $last) {
    $c = Clean $t
    if ($c -ne $t) {
      [System.Windows.Forms.Clipboard]::SetText($c)
      $last = $c
    } else { $last = $t }
  }
}
