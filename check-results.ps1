# Run from the project root in Windows PowerShell 5.1 or PowerShell 7.
$ErrorActionPreference = 'Stop'
$required = @(
  'mvn-verify-alldefs.txt',
  'jacoco-alldefs.csv',
  'mvn-test-M1.txt',
  'mvn-test-M2.txt',
  'mvn-test-M3.txt',
  'mvn-verify-final.txt',
  'jacoco-final.csv'
)
$results = Join-Path (Get-Location) 'results'
$missing = @()
$badEncoding = @()
$utf8Strict = [System.Text.UTF8Encoding]::new($false, $true)

foreach ($name in $required) {
  $path = Join-Path $results $name
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    $missing += $name
    continue
  }
  try {
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $offset = if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { 3 } else { 0 }
    [void]$utf8Strict.GetString($bytes, $offset, $bytes.Length - $offset)
  } catch {
    $badEncoding += $name
  }
}

Write-Host "Required evidence files: $($required.Count)"
Write-Host "Missing files: $($missing.Count)"
if ($missing.Count) { $missing | ForEach-Object { Write-Host "  MISSING: $_" } }
Write-Host "Invalid UTF-8 files: $($badEncoding.Count)"
if ($badEncoding.Count) { $badEncoding | ForEach-Object { Write-Host "  NOT UTF-8: $_" } }

foreach ($name in @('mvn-verify-alldefs.txt','mvn-verify-final.txt')) {
  $path = Join-Path $results $name
  if (Test-Path $path) {
    $content = Get-Content -Raw -Encoding UTF8 $path
    if ($content -match 'BUILD SUCCESS') { Write-Host "PASS: $name contains BUILD SUCCESS" }
    else { Write-Host "FAIL: $name does not contain BUILD SUCCESS" }
  }
}

foreach ($name in @('jacoco-alldefs.csv','jacoco-final.csv')) {
  $path = Join-Path $results $name
  if (Test-Path $path) {
    try {
      $rows = Import-Csv -LiteralPath $path
      $classRows = @($rows | Where-Object { $_.CLASS -eq 'DataFlowTargets' })
      if (-not $classRows) { $classRows = @($rows | Where-Object { $_.CLASS -like '*DataFlowTargets*' }) }
      if ($classRows) {
        $missed = [int]$classRows[0].BRANCH_MISSED
        Write-Host "$name : DataFlowTargets BRANCH_MISSED=$missed"
        if ($name -eq 'jacoco-final.csv' -and $missed -ne 0) { Write-Host 'FAIL: final branch coverage must have BRANCH_MISSED=0' }
      } else { Write-Host "WARN: DataFlowTargets row not found in $name" }
    } catch { Write-Host "FAIL: Cannot parse $name as CSV: $_" }
  }
}

if ($missing.Count -eq 0 -and $badEncoding.Count -eq 0) {
  Write-Host 'File existence and UTF-8 checks passed.' -ForegroundColor Green
} else {
  Write-Host 'Evidence is incomplete. Generate missing Maven/JaCoCo files first.' -ForegroundColor Yellow
  exit 1
}
